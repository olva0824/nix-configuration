{lib, ...}: {
  opts = {
    signcolumn = "yes";
  };
  autoCmd = [
    {
      callback.__raw = ''
        function()
            vim.lsp.buf.format({})
        end
      '';
      event = [
        "BufWritePre"
      ];
      pattern = [
        "*.*"
      ];
    }
  ];

  plugins = {
    lsp.servers.cucumber_language_server = {
      cmd = ["npx" "cucumber-language-server" "--stdio"];
      enable = lib.mkForce false;
    };
    blink-cmp-copilot.enable = true;
    lsp-format.enable = lib.mkForce false;
    blink-cmp = {
      enable = true;
      settings = {
        signature.enabled = true;
        completion = {
          list.selection.preselect = false;
          ghost_text.enabled = true;

          documentation = {
            auto_show = true;
          };
        };
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

          providers = {
            # latex = {
            #   name = "Latex";
            #   module = "blink-cmp-latex";
            #   opts = {
            #     insert_command = false;
            #   };
            # };
            lsp = {
              score_offset = 100;
            };
            spell = {
              module = "blink-cmp-spell";
              name = "Spell";
              score_offset = -10;
              opts = {
              };
            };
            dictionary = {
              module = "blink-cmp-dictionary";
              name = "Dict";
              score_offset = -15;
              min_keyword_length = 4;
              # Optional configurations
              opts = {
              };
            };
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
              score_offset = 100;
            };
          };
        };
        keymap = lib.mkForce {
          "<C-b>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-e>" = [
            "hide"
          ];
          "<C-f>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          "<Enter>" = [
            "accept"
            "fallback"
          ];
          "<C-p>" = [
            "snippet_backward"
            "fallback"
          ];
          "<C-n>" = [
            "snippet_forward"
            "fallback"
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
                            default = 'qwen3:14b',
                        },
                       num_ctx = {
                            default = 16000,
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
