{ pkgs, ... }:

{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        snippet = {
          expand = "function(args) vim.fn['vsnip#anonymous'](args.body) end";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
        mapping = {
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-l>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        window = {
          completion = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
          };
          documentation = {
            border = "rounded";
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder";
          };
        };
        experimental = {
          ghost_text = true;
        };
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-vsnip.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-vsnip
  ];
}
