{ ... }:

{
  plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        file_ignore_patterns = [
          "node_modules/"
          "%.git/"
        ];
      };
    };
  };
}
