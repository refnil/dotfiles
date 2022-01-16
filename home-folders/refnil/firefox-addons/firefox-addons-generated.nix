{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.8.13";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3848403/tree_style_tab-3.8.13-fx.xpi";
      sha256 = "25766bec2ba97c3299883316bf3662b03b5f796245d0aeaef8f50d7aa17d1a1c";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }