{ buildFirefoxXpiAddon, fetchurl, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.5.31";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3654280/tree_style_tab_-3.5.31-fx.xpi";
      sha256 = "1122178ebf5e8b0b62fa20353d8bb7ecb243acb16856291581337c895317145d";
      meta = with stdenv.lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }