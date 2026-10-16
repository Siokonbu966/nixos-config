{...}:
{
  plugins.mini = {
    enable = true;
    modules.icons = {
      style = "glyph";

      default = {};
      directory = {};
      extension = {};
      file = {};
      filetype = {};
      lsp = {};
      os = {};
    };
    modules.diff = {
      source.__raw = "require('mini.diff').gen_source.git()";
      view = {
        style = "sign";
        signs = {
          add = "┃";
          change = "┃";
          delete = "_";
        };
      };
    };
    mockDevIcons = true;
  };
  plugins.mini-icons = {
    enable = true;
    mockDevIcons = true;
  };
}
