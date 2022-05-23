{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.8.19";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3892754/tree_style_tab-3.8.19-fx.xpi";
      sha256 = "fdcaf0e7b28e369ef04f3584f7abd28174557bf05cc90ac9d290046ef1821396";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }