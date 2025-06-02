{lib, ...}: {
  plugins = {
    fidget.enable = lib.mkForce false;
    git-conflict.enable = true;
    lsp.servers.cucumber_language_server = {
      cmd = ["npx" "cucumber-language-server" "--stdio"];
      enable = lib.mkForce false;
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>fmt";
      # action = "<cmd>!ghokin fmt replace .<CR>";
      action.__raw = ''
        function()
           local filepath = vim.fn.expand('%:p')
           local escaped_path = vim.fn.shellescape(filepath)
           vim.cmd('!ghokin fmt replace ' .. escaped_path)
        end
      '';
      options = {
        desc = "Reformat";
      };
    }
    {
      mode = "n";
      key = "<leader>tb";
      action.__raw = ''
        function()
         require('dap').run({
           type = "go",
           name = "TestAllSuites",
           request = "launch",
           mode = "test",
           program = "./tests",
           args = { "-test.run", "TestAllSuites", "-godog.tags", "@wip"},
         })
         end
      '';
      options = {
        desc = "Debug bdd test";
      };
    }
  ];
}
