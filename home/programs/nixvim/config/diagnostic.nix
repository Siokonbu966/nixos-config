{ ... }:

{
  diagnostic.settings = {
    virtual_text = true;
    float = {
      border = "rounded";
      source = true;
    };
  };

  opts.updatetime = 300;
  # show diagnostic on hover
  #
  #autoCmd = [
  #  {
  #    event = [ "CursorHold" ];
  #    callback.__raw = ''
  #      function()
  #        vim.diagnostic.open_float(nil, {
  #          focusable = false,
  #          close_events = {
  #            "BufLeave",
  #            "CursorMoved",
  #            "InsertEnter",
  #            "FocusLost",
  #          },
  #          border = "rounded",
  #          source = "if_many",
  #          prefix = " ",
  #          scope = "cursor",
  #        })
  #      end
  #    '';
  #  }
  #  {
  #    event = [ "CursorHold" ];
  #    callback.__raw = ''
  #      function()
  #        vim.lsp.buf.hover({
  #          border = "rounded",
  #          focusable = false,
  #        })
  #      end
  #    '';
  #  }
  #];
  extraConfigLua = ''
    local border = "rounded"

    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#c0a0e0", bold = true })

    local orig_hover = vim.lsp.buf.hover
    vim.lsp.buf.hover = function(opts)
      return orig_hover(vim.tbl_extend("force", opts or {}, { border = border }))
    end

    local orig_signature = vim.lsp.buf.signature_help
    vim.lsp.buf.signature_help = function(opts)
      return orig_signature(vim.tbl_extend("force", opts or {}, { border = border }))
    end

    local orig_code_action = vim.lsp.buf.code_action
    vim.lsp.buf.code_action = function(opts)
      return orig_code_action(vim.tbl_extend("force", opts or {}, { border = border }))
    end

    vim.diagnostic.handlers["my/notify"] = {
      show = function(namespace, bufnr, diagnostics, opts)
        local level = opts["my/notify"].log_level
        local name = vim.diagnostic.get_namespace(namespace).name
        local msg = string.format("%d diagnostics in buffer %d from %s", #diagnostics, bufnr, name)
        vim.notify(msg, level)
      end,
    }

    vim.diagnostic.config({
      ["my/notify"] = {
        log_level = vim.log.levels.INFO,
        severity = vim.diagnostic.severity.ERROR,
        virtual_text = true,
      },
    })

 
    vim.keymap.set("n", "gK", function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = "Toggle diagnostic virtual_lines" })
  '';
}
