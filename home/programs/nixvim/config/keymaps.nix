{ ... }:

{
  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = { desc = "Telescope find files"; };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options = { desc = "Telescope live grep"; };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options = { desc = "Telescope buffers"; };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options = { desc = "Telescope help tags"; };
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<cmd>bprev<CR>";
      options = { desc = "move previous tab"; };
    }
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>bnext<CR>";
      options = { desc = "move next tab"; };
    }
    {
      mode = "n";
      key = "fo";
      action = "<cmd>Oil<CR>";
      options = { desc = "open oil"; };
    }
    {
      mode = "n";
      key = "<leader>hh";
      action = "<cmd>DiffviewOpen HEAD~1<CR>";
      options = { desc = "1つ前とのdiff"; };
    }
    {
      mode = "n";
      key = "<leader>hf";
      action = "<cmd>DiffviewFileHistory %<CR>";
      options = { desc = "ファイルの変更履歴"; };
    }
    {
      mode = "n";
      key = "<leader>hc";
      action = "<cmd>DiffviewClose<CR>";
      options = { desc = "diffの画面閉じる"; };
    }
    {
      mode = "n";
      key = "<leader>hd";
      action = "<cmd>Diffview<CR>";
      options = { desc = "コンフリクト解消画面表示"; };
    }
    {
      mode = "n";
      key = "tc";
      action = "<cmd>bdelete<CR>";
      options = { desc = "close current buffer"; };
    } 
    {
    mode = "n";
      key = "<A-k>";
      action = "<cmd>noh<CR>";
      options = { desc = "disable hilight"; };
    }
  ];
}
