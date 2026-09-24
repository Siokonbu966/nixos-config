{ ... }:

{
  diagnostic.settings = {
    virtual_text = true;
    float = {
      border = "rounded";
      source = true;
      wrap = true;
    };
    "my/notify" = {
      log_level.__raw = "vim.log.levels.INFO";
      severity.__raw = "vim.diagnostic.severity.ERROR";
      virtual_text = true;
    };
  };

  opts = {
    updatetime = 300;
    winborder = "rounded";
  };

  highlight.FloatBorder = {
    fg = "#c0a0e0";
    bold = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "gK";
      action.__raw = ''
        function()
          local new_config = not vim.diagnostic.config().virtual_lines
          vim.diagnostic.config({ virtual_lines = new_config })
        end
      '';
      options = {
        desc = "Toggle diagnostic virtual_lines";
      };
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = ''
        function()
          -- open_float は常に enter=false で開くため、focus=true だけでは
          -- カーソルは移動しない。返り値の winnr に明示的に入る必要がある。
          local _, winnr = vim.diagnostic.open_float({ scope = "cursor" })
          if winnr then
            vim.api.nvim_set_current_win(winnr)
          end
        end
      '';
      options = {
        desc = "Show diagnostic float";
      };
    }
  ];

  extraConfigLua = ''
    vim.diagnostic.handlers["my/notify"] = {
      show = function(namespace, bufnr, diagnostics, opts)
        local level = opts["my/notify"].log_level
        local name = vim.diagnostic.get_namespace(namespace).name
        local msg = string.format("%d diagnostics in buffer %d from %s", #diagnostics, bufnr, name)
        vim.notify(msg, level)
      end,
    }
  '';
}
