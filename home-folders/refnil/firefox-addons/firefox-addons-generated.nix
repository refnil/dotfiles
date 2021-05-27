{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.8.1";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/3772067/tree_style_tab_-3.8.1-fx.xpi";
      sha256 = "a3024c9a803565640c63dfa135b0f59bb3f25bcc031fc5638fc6bd9d2f94fc06";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    }