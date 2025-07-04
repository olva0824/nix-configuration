{lib, ...}: {
  plugins = {
    fidget.enable = lib.mkForce false;
    git-conflict.enable = true;
    lsp.servers.cucumber_language_server = {
      cmd = ["npx" "cucumber-language-server" "--stdio"];
      enable = lib.mkForce false;
    };
    lsp.servers.ltex_plus.enable = lib.mkForce true;
    blink-cmp-copilot.enable = true;
    blink-cmp = {
      settings = {
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "spell"
            "copilot"
            # Make it too slow
            # "dictionary"
          ];
        };
      };
    };
    codecompanion = lib.mkForce {
      enable = true;
      settings = {
        adapters = {
          ollama = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('ollama', {
                    env = {
                        url = "http://127.0.0.1:11434",
                    },
                    schema = {
                        model = {
                            default = 'deepseek-r1:8b',
                        },
                       num_ctx = {
                            default = 32000,
                        },
                    },
                })
              end
            '';
          };
        };
        opts = {
          log_level = "TRACE";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };
        strategies = {
          agent = {
            adapter = "ollama";
          };
          chat = {
            adapter = "ollama";
          };
          inline = {
            adapter = "ollama";
          };
        };
      };
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
