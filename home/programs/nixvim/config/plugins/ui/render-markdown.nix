{
  plugins.render-markdown = {
    enable = true;
  };

  autoCmd = [
    {
      event = "InsertEnter";
      pattern = "*";
      command = "RenderMarkdown disable";
    }
    {
      event = "InsertLeave";
      pattern = "*";
      command = "RenderMarkdown enable";
    }
  ];
}
