use std::fs;
use zed_extension_api::{
    self as zed, serde_json::{self, json}, settings::LspSettings, LanguageServerId, Result,
};

const SERVER_ID: &str = "pico8-luals";

/// PICO-8 API globals, so LuaLS does not flag them as undefined.
const PICO8_GLOBALS: &[&str] = &[
    "_draw", "_init", "_update", "_update60", "abs", "add", "all", "atan2", "band", "bnot", "bor", "btn", "btnp", "bxor", "camera", "cartdata", "ceil", "chr", "circ", "circfill", "clip", "cls", "cocreate", "color", "coresume", "cos", "costatus", "count", "cstore", "cursor", "del", "deli", "dget", "dset", "extcmd", "fget", "fillp", "flip", "flr", "foreach", "fset", "ipairs", "line", "lshr", "map", "max", "memcpy", "memset", "menuitem", "mget", "mid", "min", "mset", "music", "ord", "pairs", "pal", "palt", "peek", "peek2", "peek4", "pget", "poke", "poke2", "poke4", "print", "printh", "pset", "rect", "rectfill", "reload", "rnd", "rotl", "rotr", "run", "sfx", "sget", "sgn", "shl", "shr", "sin", "split", "spr", "sqrt", "srand", "sset", "sspr", "stat", "stop", "sub", "t", "time", "tline", "tonum", "tostr", "yield"];

struct Pico8Extension {
    cached_binary_path: Option<String>,
}

impl Pico8Extension {
    fn binary_path(
        &mut self,
        id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<(String, Vec<String>)> {
        let binary = LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|s| s.binary);
        let args = binary
            .as_ref()
            .and_then(|b| b.arguments.clone())
            .unwrap_or_default();
        let path = match binary.and_then(|b| b.path).or_else(|| worktree.which("lua-language-server")) {
            Some(p) => p,
            None => self.download(id)?,
        };
        Ok((path, args))
    }

    fn download(&mut self, id: &LanguageServerId) -> Result<String> {
        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).is_ok_and(|m| m.is_file()) {
                return Ok(path.clone());
            }
        }
        zed::set_language_server_installation_status(
            id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let release = zed::latest_github_release(
            "LuaLS/lua-language-server",
            zed::GithubReleaseOptions { require_assets: true, pre_release: false },
        )?;
        let (platform, arch) = zed::current_platform();
        let (os, ext, ftype, exe) = match platform {
            zed::Os::Mac => ("darwin", "tar.gz", zed::DownloadedFileType::GzipTar, ""),
            zed::Os::Linux => ("linux", "tar.gz", zed::DownloadedFileType::GzipTar, ""),
            zed::Os::Windows => ("win32", "zip", zed::DownloadedFileType::Zip, ".exe"),
        };
        let arch = match arch {
            zed::Architecture::Aarch64 => "arm64",
            zed::Architecture::X8664 => "x64",
            zed::Architecture::X86 => return Err("unsupported platform x86".into()),
        };
        let asset_name = format!("lua-language-server-{}-{os}-{arch}.{ext}", release.version);
        let asset = release
            .assets
            .iter()
            .find(|a| a.name == asset_name)
            .ok_or_else(|| format!("no asset found matching {asset_name:?}"))?;
        let dir = format!("lua-language-server-{}", release.version);
        let bin = format!("{dir}/bin/lua-language-server{exe}");
        if !fs::metadata(&bin).is_ok_and(|m| m.is_file()) {
            zed::set_language_server_installation_status(
                id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );
            zed::download_file(&asset.download_url, &dir, ftype)
                .map_err(|e| format!("failed to download file: {e}"))?;
            if let Ok(entries) = fs::read_dir(".") {
                for entry in entries.flatten() {
                    if entry.file_name().to_str() != Some(&dir) {
                        fs::remove_dir_all(entry.path()).ok();
                    }
                }
            }
        }
        self.cached_binary_path = Some(bin.clone());
        Ok(bin)
    }
}

impl zed::Extension for Pico8Extension {
    fn new() -> Self {
        Self { cached_binary_path: None }
    }

    fn language_server_command(
        &mut self,
        id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let (command, args) = self.binary_path(id, worktree)?;
        Ok(zed::Command { command, args, env: vec![] })
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
        // User-provided `lsp.pico8-luals.settings` wins over our defaults.
        if let Some(settings) = LspSettings::for_worktree(SERVER_ID, worktree)
            .ok()
            .and_then(|s| s.settings)
        {
            return Ok(Some(settings));
        }
        Ok(Some(json!({
            "Lua": {
                "runtime": {
                    "version": "Lua 5.4",
                    "nonstandardSymbol": [
                        "!=", "+=", "-=", "*=", "/=", "//=", "%=", "^=", "..=", "|=", "&=", "^^=", "<<=", ">>=", ">>>=", "<<>=", ">><="
                    ]
                },
                "diagnostics": {
                    "globals": PICO8_GLOBALS,
                    "disable": ["lowercase-global"]
                },
                "workspace": { "checkThirdParty": false },
                "telemetry": { "enable": false }
            }
        })))
    }
}

zed::register_extension!(Pico8Extension);
