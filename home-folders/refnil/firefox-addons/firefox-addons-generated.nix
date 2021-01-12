{ buildFirefoxXpiAddon, fetchurl, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.5.34";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3664524/tree_style_tab_-3.5.34-fx.xpi";
      sha256 = "5533ce0fd1060b7a289e666e77af8a6aa8a0c4df1e0c3ce8bf0297ff65bff066";
      meta = with stdenv.lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }