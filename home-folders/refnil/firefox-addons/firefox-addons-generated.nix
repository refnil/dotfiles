{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.8.7";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3807070/tree_style_tab_-3.8.7-fx.xpi";
      sha256 = "791e89cf720b0b7cc33a5b1fe6c1552490958b06e4ac0a456805fdbb3975b49c";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }