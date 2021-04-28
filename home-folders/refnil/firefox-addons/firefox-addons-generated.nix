{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.7.4";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3752249/tree_style_tab_-3.7.4-fx.xpi";
      sha256 = "9e7a9b1ea63c62511e915e301ec7c8f93fabb4551b908bbd4f8e719adf9336d6";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }