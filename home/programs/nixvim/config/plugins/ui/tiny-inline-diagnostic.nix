{ ... }:

{
  plugins.tiny-inline-diagnostic = {
    enable = true;
    settings = {
      options = {
        multilines = {
          enabled = true;
          always_show = true;
        };
        overflow = {
          mode = "wrap";
        };
      };
    };
  };

  # Disable default virtual text as recommended by the plugin
  extraConfigLua = ''
    vim.diagnostic.config({ virtual_text = false })
  '';
}
