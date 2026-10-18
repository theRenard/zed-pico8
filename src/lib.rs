use std::fs;
use zed_extension_api::{self as zed, serde_json, settings::LspSettings, LanguageServerId, Result};

const SERVER_ID: &str = "pico8-ls";
/// Repo whose releases carry the bundled server (built by .github/workflows/build-server.yml).
const RELEASE_REPO: &str = "theRenard/zed-pico8";
const ASSET_NAME: &str = "pico8-ls-server.js";
const DIR_PREFIX: &str = "pico8-ls-";

struct Pico8Extension {
    cached_script_path: Option<String>,
}

impl Pico8Extension {
    /// Downloads (once per release) the bundled japhib/pico8-ls server and returns its absolute path.
    fn managed_server_script(&mut self, id: &LanguageServerId) -> Result<String> {
        if let Some(path) = &self.cached_script_path {
            if fs::metadata(path).is_ok_and(|m| m.is_file()) {
                return Ok(path.clone());
            }
        }

        zed::set_language_server_installation_status(
            id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let release = zed::latest_github_release(
            RELEASE_REPO,
            zed::GithubReleaseOptions { require_assets: true, pre_release: false },
        )?;
        let asset = release
            .assets
            .iter()
            .find(|a| a.name == ASSET_NAME)
            .ok_or_else(|| format!("no asset named {ASSET_NAME:?} in release {}", release.version))?;

        let dir = format!("{DIR_PREFIX}{}", release.version);
        let script = format!("{dir}/{ASSET_NAME}");

        if !fs::metadata(&script).is_ok_and(|m| m.is_file()) {
            zed::set_language_server_installation_status(
                id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );
            fs::create_dir_all(&dir).map_err(|e| format!("failed to create {dir}: {e}"))?;
            zed::download_file(
                &asset.download_url,
                &script,
                zed::DownloadedFileType::Uncompressed,
            )
            .map_err(|e| format!("failed to download language server: {e}"))?;

            // Remove older versions.
            if let Ok(entries) = fs::read_dir(".") {
                for entry in entries.flatten() {
                    let name = entry.file_name();
                    let name = name.to_string_lossy();
                    if name.starts_with(DIR_PREFIX) && name != dir {
                        fs::remove_dir_all(entry.path()).ok();
                    }
                }
            }
        }

        let absolute = std::env::current_dir()
            .map_err(|e| format!("failed to get working directory: {e}"))?
            .join(&script)
            .to_string_lossy()
            .to_string();
        self.cached_script_path = Some(absolute.clone());
        Ok(absolute)
    }
}

impl zed::Extension for Pico8Extension {
    fn new() -> Self {
        Self { cached_script_path: None }
    }

    fn language_server_command(
        &mut self,
        id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let binary = LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|s| s.binary);
        let user_args = binary.as_ref().and_then(|b| b.arguments.clone());
        let user_path = binary.and_then(|b| b.path);

        // 1. Explicit user override, 2. a `pico8-ls` executable on PATH (e.g. installed via Mason).
        if let Some(command) = user_path.or_else(|| worktree.which("pico8-ls")) {
            return Ok(zed::Command {
                command,
                args: user_args.unwrap_or_else(|| vec!["--stdio".to_string()]),
                env: vec![],
            });
        }

        // 3. Managed download, run with Zed's bundled Node.
        let script = self.managed_server_script(id)?;
        Ok(zed::Command {
            command: zed::node_binary_path()?,
            args: vec![script, "--stdio".to_string()],
            env: vec![],
        })
    }

    fn language_server_initialization_options(
        &mut self,
        _id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        Ok(LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|s| s.initialization_options))
    }

    fn language_server_workspace_configuration(
        &mut self,
        _id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        Ok(LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|s| s.settings))
    }
}

zed::register_extension!(Pico8Extension);
