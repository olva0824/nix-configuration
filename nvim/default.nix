{
  lib,
  pkgs,
  ...
}: let
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
in {
  imports = [
  ];

  programs.nixvim = {
    autoCmd = [
      {
        command = "setlocal tabstop=2 shiftwidth=2";
        event = [
          "BufEnter"
          "BufWinEnter"
        ];
        pattern = [
          "*.feature"
        ];
      }
    ];
    keymaps = [
      # Press 'H', 'L' to jump to start/end of a line (first/last character)
      {
        mode = ["n" "v"];
        key = "L";
        action = "$";
      }
      {
        mode = ["n"];
        key = "H";
        action = "^";
      }
      {
        mode = "n";
        key = "<leader>uid";
        action.__raw = ''
          function()
             local uuid = vim.fn.system("uuidgen"):gsub("\n", "")
             uuid = string.lower(uuid)
             vim.api.nvim_put({uuid}, "", true, true)
          end
        '';
        options = {
          desc = "Put UUID";
        };
      }
      {
        mode = ["n"];
        key = "<C-s>";
        action = "<cmd>w<cr>";
        options = {desc = "Save buffer";};
      }
      {
        mode = "n";
        key = "<leader>cp";
        action = "<cmd>MarkdownPreview<cr>";
        options = {
          desc = "Markdown Preview";
        };
      }
      {
        mode = ["n" "t"];
        key = "<C-n>";
        action = "<cmd>FloatermToggle<cr>";
        options = {
          silent = true;
          desc = "Terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit (root dir)";
        };
      }
      {
        mode = "n";
        key = "<leader>fmt";
        action = "<cmd>!ghokin fmt replace .<CR>";
        options = {
          desc = "Reformat";
        };
      }
      {
        mode = ["n"];
        key = "<leader>glb";
        action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
        options = {
          desc = "Blame current line";
        };
      }
      {
        mode = ["n"];
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        options = {desc = "Open file tree";};
      }
      {
        mode = "n";
        key = "<leader>fe";
        action = "<cmd>Telescope file_browser<cr>";
        options = {
          desc = "File browser";
        };
      }
      {
        mode = "n";
        key = "<leader>ut";
        action = "<cmd>UndotreeToggle<cr>";
        options = {
          desc = "Toggle undotree";
        };
      }
      {
        mode = "n";
        key = "<leader>fE";
        action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
        options = {
          desc = "File browser";
        };
      }
      {
        mode = "n";
        key = "<C-t>";
        action.__raw = ''
          function()
            require('telescope.builtin').live_grep({
              default_text="TODO",
              initial_mode="normal"
            })
          end
        '';
        options.silent = true;
      }

      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Git blame<CR>";
        options = {
          desc = "Enbale git blame";
        };
      }
      #DAP
      {
        mode = "n";
        key = "<leader>dB";
        action = "
        <cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>
      ";
        options = {
          silent = true;
          desc = "Breakpoint Condition";
        };
      }
      {
        mode = "n";
        key = "<leader>db";
        action = ":DapToggleBreakpoint<cr>";
        options = {
          silent = true;
          desc = "Toggle Breakpoint";
        };
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = ":DapContinue<cr>";
        options = {
          silent = true;
          desc = "Continue";
        };
      }
      {
        mode = "n";
        key = "<leader>da";
        action = "<cmd>lua require('dap').continue({ before = get_args })<cr>";
        options = {
          silent = true;
          desc = "Run with Args";
        };
      }
      {
        mode = "n";
        key = "<leader>dC";
        action = "<cmd>lua require('dap').run_to_cursor()<cr>";
        options = {
          silent = true;
          desc = "Run to cursor";
        };
      }
      {
        mode = "n";
        key = "<leader>dg";
        action = "<cmd>lua require('dap').goto_()<cr>";
        options = {
          silent = true;
          desc = "Go to line (no execute)";
        };
      }
      {
        mode = "n";
        key = "<leader>di";
        action = ":DapStepInto<cr>";
        options = {
          silent = true;
          desc = "Step into";
        };
      }
      {
        mode = "n";
        key = "<leader>dj";
        action = "
        <cmd>lua require('dap').down()<cr>
      ";
        options = {
          silent = true;
          desc = "Down";
        };
      }
      {
        mode = "n";
        key = "<leader>dk";
        action = "<cmd>lua require('dap').up()<cr>";
        options = {
          silent = true;
          desc = "Up";
        };
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require('dap').run_last()<cr>";
        options = {
          silent = true;
          desc = "Run Last";
        };
      }
      {
        mode = "n";
        key = "<leader>do";
        action = ":DapStepOut<cr>";
        options = {
          silent = true;
          desc = "Step Out";
        };
      }
      {
        mode = "n";
        key = "<leader>dO";
        action = ":DapStepOver<cr>";
        options = {
          silent = true;
          desc = "Step Over";
        };
      }
      {
        mode = "n";
        key = "<leader>dp";
        action = "<cmd>lua require('dap').pause()<cr>";
        options = {
          silent = true;
          desc = "Pause";
        };
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = ":DapToggleRepl<cr>";
        options = {
          silent = true;
          desc = "Toggle REPL";
        };
      }
      {
        mode = "n";
        key = "<leader>ds";
        action = "<cmd>lua require('dap').session()<cr>";
        options = {
          silent = true;
          desc = "Session";
        };
      }
      {
        mode = "n";
        key = "<leader>dt";
        action = ":DapTerminate<cr>";
        options = {
          silent = true;
          desc = "Terminate";
        };
      }
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<cr>";
        options = {
          silent = true;
          desc = "Dap UI";
        };
      }
      {
        mode = "n";
        key = "<leader>dw";
        action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
        options = {
          silent = true;
          desc = "Widgets";
        };
      }
      {
        mode = ["n" "v"];
        key = "<leader>de";
        action = "<cmd>lua require('dapui').eval()<cr>";
        options = {
          silent = true;
          desc = "Eval";
        };
      }

      #TESTS
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
        options = {
          desc = "Run File";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tT";
        action = "<cmd>lua require('neotest').run.run(vim.uv.cwd())<CR>";
        options = {
          desc = "Run All Test Files";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tr";
        action = "<cmd>lua require('neotest').run.run()<CR>";
        options = {
          desc = "Run Nearest";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>td";
        action = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>";
        options = {
          desc = "Run Nearest with debugger";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ts";
        action = "<cmd>lua require('neotest').summary.toggle()<CR>";
        options = {
          desc = "Toggle Summary";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>to";
        action = "<cmd>lua require('neotest').output.open{ enter = true, auto_close = true }<CR>";
        options = {
          desc = "Show Output";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tO";
        action = "<cmd>lua require('neotest').output_panel.toggle()<CR>";
        options = {
          desc = "Toggle Output Panel";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>tS";
        action = "<cmd>lua require('neotest').run.stop()<CR>";
        options = {
          desc = "Stop";
          silent = true;
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
      ### GIT signs
      {
        mode = "n";
        key = "<leader>hs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        options = {
          desc = "Stage hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>hr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        options = {
          desc = "Reset hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>ph";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options = {
          desc = "Preview hunk";
        };
      }
      {
        mode = "n";
        key = "<leader>hdt";
        action = "<cmd>Gvdiffsplit!<cr>";
        options = {
          desc = "Diff this";
        };
      }
      {
        mode = "n";
        key = "ga";
        action = "<cmd>diffget //2<cr>";
        options = {
          desc = "Accept left";
        };
      }
      {
        mode = "n";
        key = "gl";
        action = "<cmd>diffget //3<cr>";
        options = {
          desc = "Accept right";
        };
      }
    ];
    highlight.Todo = {
      fg = "Blue";
      bg = "Yellow";
    };

    match.TODO = "TODO";

    extraConfigLua = ''
      vim.keymap.set("n", "<C-a>", function()
          require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
          require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("n", "g<C-a>", function()
          require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
          require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("v", "<C-a>", function()
          require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "<C-x>", function()
          require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("v", "g<C-a>", function()
          require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("v", "g<C-x>", function()
          require("dial.map").manipulate("decrement", "gvisual")
      end)
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
      require('flit').setup {
      keys = { f = 'f', F = 'F', t = 't', T = 'T' },
      -- A string like "nv", "nvo", "o", etc.
      labeled_modes = "v",
      -- Repeat with the trigger key itself.
      clever_repeat = true,
      multiline = true,
      -- Like `leap`s similar argument (call-specific overrides).
      -- E.g.: opts = { equivalence_classes = {} }
      opts = {}
      }
      require'lspconfig'.protols.setup{}

    '';
    extraPlugins = with pkgs.vimPlugins; [
      # NOTE: This is how you would ad a vim plugin that is not implemented in Nixvim, also see extraConfigLuaPre below
      # `neodev` configure Lua LSP for your Neovim config, runtime and plugins
      # used for completion, annotations, and signatures of Neovim apis
      neodev-nvim
      flit-nvim
      dial-nvim
    ];
    extraConfigLuaPre =
      # lua
      ''
        local slow_format_filetypes = {}

        vim.api.nvim_create_user_command("FormatDisable", function(args)
           if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat-on-save",
          bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
          desc = "Re-enable autoformat-on-save",
        })
        vim.api.nvim_create_user_command("FormatToggle", function(args)
          if args.bang then
            -- Toggle formatting for current buffer
            vim.b.disable_autoformat = not vim.b.disable_autoformat
          else
            -- Toggle formatting globally
            vim.g.disable_autoformat = not vim.g.disable_autoformat
          end
        end, {
          desc = "Toggle autoformat-on-save",
          bang = true,
        })

        -- require('neodev').setup {}
      '';

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    opts = {
      completeopt = ["menu" "menuone" "noselect"];
      updatetime = 10;
      relativenumber = true;
      wrap = true;
      cursorline = true;
      number = true;
      smartindent = true;
      swapfile = false;
      breakindent = true;
      undofile = true;
      incsearch = true;
      ignorecase = true;
      colorcolumn = "135";
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      foldcolumn = "0";
      autoindent = true;
      foldlevel = 99;
      hlsearch = true;
      foldlevelstart = 99;
      foldenable = true;
      scrolloff = 16;
      # timeoutlen = 10;
      list = true;
      spell = true;
      spelllang = ["en_us"];
    };
    plugins = {
      web-devicons.enable = true;
      markdown-preview.enable = true;
      barbar = {
        enable = true;
        keymaps = {
          next.key = "<TAB>";
          previous.key = "<S-TAB>";
          close = {
            key = "d<TAB>";
            action = "<Cmd>BufferClose!<CR>";
          };
          closeAllButCurrent = {
            key = "D<TAB>";
          };
        };
      };
      bufferline.enable = true;
      undotree.enable = true;
      auto-session = {
        enable = true;
        settings = {
          enabled = true;
          auto_restore = true;
          auto_save = true;
        };
      };
      lazygit.enable = true;
      noice.enable = true; # think do I really need it
      fugitive.enable = true;
      ollama = {
        enable = true;
        model = "qwen2.5-coder:14b";
      };
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = {
              text = " ";
            };
            change = {
              text = " ";
            };
            delete = {
              text = " ";
            };
            untracked = {
              text = "";
            };
            topdelete = {
              text = "󱂥 ";
            };
            changedelete = {
              text = "󱂧 ";
            };
          };
        };
      };
      fidget = {
        #TODO do I really need it
        enable = true;
        logger = {
          level = "warn"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
          floatPrecision = 0.01; # Limit the number of decimals displayed for floats
        };
        progress = {
          pollRate = 0; # How and when to poll for progress messages
          suppressOnInsert = true; # Suppress new messages while in insert mode
          ignoreDoneAlready = false; # Ignore new tasks that are already complete
          ignoreEmptyMessage = false; # Ignore new tasks that don't contain a message
          clearOnDetach =
            # Clear notification group when LSP server detaches
            ''
              function(client_id)
                local client = vim.lsp.get_client_by_id(client_id)
                return client and client.name or nil
              end
            '';
          notificationGroup =
            # How to get a progress message's notification group key
            ''
              function(msg) return msg.lsp_client.name end
            '';
          ignore = []; # List of LSP servers to ignore
          lsp = {
            progressRingbufSize = 0; # Configure the nvim's LSP progress ring buffer size
          };
          display = {
            renderLimit = 16; # How many LSP messages to show at once
            doneTtl = 3; # How long a message should persist after completion
            doneIcon = "✔"; # Icon shown when all LSP progress tasks are complete
            doneStyle = "Constant"; # Highlight group for completed LSP tasks
            progressTtl = "math.huge"; # How long a message should persist when in progress
            progressIcon = {
              pattern = "dots";
              period = 1;
            }; # Icon shown when LSP progress tasks are in progress
            progressStyle = "WarningMsg"; # Highlight group for in-progress LSP tasks
            groupStyle = "Title"; # Highlight group for group name (LSP server name)
            iconStyle = "Question"; # Highlight group for group icons
            priority = 30; # Ordering priority for LSP notification group
            skipHistory = true; # Whether progress notifications should be omitted from history
            formatMessage = ''
              require ("fidget.progress.display").default_format_message
            ''; # How to format a progress message
            formatAnnote = ''
              function (msg) return msg.title end
            ''; # How to format a progress annotation
            formatGroupName = ''
              function (group) return tostring (group) end
            ''; # How to format a progress notification group's name
            overrides = {
              rust_analyzer = {
                name = "rust-analyzer";
              };
            }; # Override options from the default notification config
          };
        };
        notification = {
          pollRate = 10; # How frequently to update and render notifications
          filter = "info"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
          historySize = 128; # Number of removed messages to retain in history
          overrideVimNotify = true;
          redirect = ''
            function(msg, level, opts)
              if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
              end
            end
          '';
          configs = {
            default = "require('fidget.notification').default_config";
          };

          window = {
            normalHl = "Comment";
            winblend = 0;
            border = "none"; # none, single, double, rounded, solid, shadow
            zindex = 45;
            maxWidth = 0;
            maxHeight = 0;
            xPadding = 1;
            yPadding = 0;
            align = "bottom";
            relative = "editor";
          };
          view = {
            stackUpwards = true; # Display notification items from bottom to top
            iconSeparator = " "; # Separator between group name and icon
            groupSeparator = "---"; # Separator between notification groups
            groupSeparatorHl =
              # Highlight group used for group separator
              "Comment";
          };
        };
      };
      none-ls = {
        enable = true;
        sources = {
          formatting = {
            goimports.enable = true;
            gofmt.enable = true;
            # buf.enable = true;
            gofumpt.enable = true;
          };
          diagnostics = {
            # buf.enable = true;
            # golangci_lint.enable = true;
          };
        };
      };
      mini = {
        enable = true;

        modules = {
          ai = {
            n_lines = 500;
          };
          indentscope = {
            symbol = "│";
            options = {
              try_as_border = true;
            };
          };
          #TODO add alternative mapping for surround to avoid conflict with leap plugin
          surround = {
            mappings = {
              add = "gsa"; # -- Add surrounding in Normal and Visual modes
              delete = "gsd"; # -- Delete surrounding
              find = "gsf"; # -- Find surrounding (to the right)
              find_left = "gsF"; # -- Find surrounding (to the left)
              highlight = "gsh"; # -- Highlight surrounding
              replace = "gsr"; # -- Replace surrounding
              update_n_lines = "gsn"; # -- Update `n_lines`
            };
          };
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              local function on_format(err)
                if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 200, lsp_fallback = true }, on_format
             end
          '';

          format_after_save = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              return { lsp_fallback = true }
            end
          '';
          formatters_by_ft = {
            html = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            css = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            # go = ["gofmt" "goimports"];
            typescript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            python = [
              "black"
              "isort"
            ];
            lua = ["stylua"];
            nix = ["alejandra"];
            markdown = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            yaml = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            terraform = ["terraform_fmt"];
            bash = [
              "shellcheck"
              "shellharden"
              "shfmt"
            ];
            json = ["jq"];
            "_" = ["trim_whitespace"];
          };
          notify_on_error = true;
          formatters = {
            black = {
              command = "${lib.getExe pkgs.black}";
            };
            isort = {
              command = "${lib.getExe pkgs.isort}";
            };
            alejandra = {
              command = "${lib.getExe pkgs.alejandra}";
            };
            jq = {
              command = "${lib.getExe pkgs.jq}";
            };
            prettierd = {
              command = "${lib.getExe pkgs.prettierd}";
            };
            stylua = {
              command = "${lib.getExe pkgs.stylua}";
            };
            shellcheck = {
              command = "${lib.getExe pkgs.shellcheck}";
            };
            shfmt = {
              command = "${lib.getExe pkgs.shfmt}";
            };
            shellharden = {
              command = "${lib.getExe pkgs.shellharden}";
            };
            goftm = {
              comand = "${lib.getExe pkgs.gofumpt}";
            };
            #yamlfmt = {
            #  command = "${lib.getExe pkgs.yamlfmt}";
            #};
          };
        };
      };

      harpoon = {
        enable = true;

        keymapsSilent = true;

        keymaps = {
          addFile = "<leader>ha";
          toggleQuickMenu = "<C-e>";
          navFile = {
            "1" = "<leader>1";
            "2" = "<leader>2";
            "3" = "<leader>3";
            "4" = "<leader>4";
            "5" = "<leader>5";
            "6" = "<leader>6";
            "7" = "<leader>7";
          };
        };
      };
      leap = {
        enable = true;
      };
      floaterm = {
        enable = true;
        width = 0.8;
        height = 0.8;

        title = "ft";
      };
      luasnip.enable = true;
      lspkind = {
        enable = true;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            neorg = "[neorg]";
            cmp_tabby = "[Tabby]";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      indent-blankline = {
        enable = true;
      };
      # Inserts matching pairs of parens, brackets, etc.
      nvim-autopairs = {
        enable = true;
        settings.fast_wrap.chars = [
          "{"
          "["
          "("
          "'"
          "\""
        ];
      };
      cmp = {
        enable = true;

        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          completion = {
            completeopt = "menu,menuone,noinsert";
          };
          experimental = {ghost_text = true;};
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          mapping = {
            # Select the [n]ext item
            "<Tab>" = "cmp.mapping.select_next_item()";
            # Select the [p]revious item
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            # Scroll the documentation window [b]ack / [f]orward
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            # Accept ([y]es) the completion.
            #  This will auto-import if your LSP supports it.
            #  This will expand snippets if the LSP sent a snippet.
            "<C-y>" = "cmp.mapping.confirm { select = true }";
            # If you prefer more traditional completion keymaps,
            # you can uncomment the following lines.
            # "<CR>" = "cmp.mapping.confirm { select = true }";
            # "<Tab>" = "cmp.mapping.select_next_item()";
            # "<S-Tab>" = "cmp.mapping.select_prev_item()";

            # Think of <c-l> as moving to the right of your snippet expansion.
            #  So if you have a snippet that's like:
            #  function $name($args)
            #    $body
            #  end
            #
            # <c-l> will move you to the right of the expansion locations.
            # <c-h> is similar, except moving you backwards.
            "<C-l>" = ''
              cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                end
              end, { 'i', 's' })
            '';
            "<C-h>" = ''
              cmp.mapping(function()
                if luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                end
              end, { 'i', 's' })
            '';
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };

          sources = [
            {name = "path";}
            {name = "nvim_lsp";}
            {name = "cmp_tabby";}
            {
              name = "luasnip"; # snippets
            }
            {
              name = "buffer";
              # Words from other open buffers can also be suggested.
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            }
            {name = "neorg";}
          ];

          window = {
            completion = {border = "solid";};
            documentation = {border = "solid";};
          };
        };
      };
      cmp-spell = {
        enable = true;
      };
      #
      wilder = {
        enable = true;
        modes = [":" "/" "?"];
      };
      oil = {
        enable = true;
        settings = {
          keymaps = {
            "<C-r>" = "actions.refresh";
            "y." = "actions.copy_entry_path";
            "g?" = "actions.show_help";
            "<CR>" = "actions.select";
            "<C-p>" = "actions.preview";
            "<C-c>" = "actions.close";
            "g." = "actions.toggle_hidden";
            "-" = "actions.parent";
            "_" = "actions.open_cwd";
            "`" = "actions.cd";
          };
          view_options = {
            show_hidden = true;
          };
          win_opts = {
          };
          skip_confirm_for_simple_edits = true;
        };
      };
      telescope = {
        enable = true;
        extensions = {
          file-browser = {
            enable = true;
          };
          fzf-native = {
            enable = true;
          };
          ui-select = {
            settings = {
              specific_opts = {
                codeactions = true;
              };
            };
          };
          undo = {
            enable = true;
          };
        };
        settings = {
          defaults = {
            layout_config = {
              horizontal = {
                prompt_position = "top";
              };
            };
            sorting_strategy = "ascending";
          };
          pickers = {
            colorscheme = {
              enable_preview = true;
            };
            live_grep = {
              additional_args = ''
                function(_)
                  return { "--hidden" }
                 end
              '';
            };
          };
        };
        keymaps = {
          "<leader>sh" = {
            mode = "n";
            action = "help_tags";
            options = {
              desc = "[S]earch [H]elp";
            };
          };
          "<leader>sk" = {
            mode = "n";
            action = "keymaps";
            options = {
              desc = "[S]earch [K]eymaps";
            };
          };
          "<leader>ss" = {
            mode = "n";
            action = "builtin";
            options = {
              desc = "[S]earch [S]elect Telescope";
            };
          };
          "<leader>sw" = {
            mode = "n";
            action = "grep_string";
            options = {
              desc = "[S]earch current [W]ord";
            };
          };
          "<leader>sg" = {
            mode = "n";
            action = "live_grep";
            options = {
              desc = "[S]earch by [G]rep";
            };
          };
          "<leader>sd" = {
            mode = "n";
            action = "diagnostics";
            options = {
              desc = "[S]earch [D]iagnostics";
            };
          };
          "<leader>sr" = {
            mode = "n";
            action = "resume";
            options = {
              desc = "[S]earch [ ]esume";
            };
          };
          "<leader>sf" = {
            mode = "n";
            action = "oldfiles";
            options = {
              desc = "[S]earch Recent Files ('.' for repeat)";
            };
          };
          "<leader><leader>" = {
            mode = "n";
            action = "buffers";
            options = {
              desc = "[ ] Find existing buffers";
            };
          };
          "<leader>:" = {
            action = "command_history";
            options = {
              desc = "Command History";
            };
          };
          "<leader>b" = {
            action = "buffers";
            options = {
              desc = "+buffer";
            };
          };
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Find project files";
            };
          };
          "<C-p>" = {
            action = "git_files";
            options = {
              desc = "Search git files";
            };
          };
          "<leader>gc" = {
            action = "git_commits";
            options = {
              desc = "Commits";
            };
          };
          "<leader>gs" = {
            action = "git_status";
            options = {
              desc = "Status";
            };
          };
          "<leader>sa" = {
            action = "autocommands";
            options = {
              desc = "Auto Commands";
            };
          };
          "<leader>sb" = {
            action = "current_buffer_fuzzy_find";
            options = {
              desc = "Buffer";
            };
          };
          "<leader>sC" = {
            action = "commands";
            options = {
              desc = "Commands";
            };
          };
          "<leader>sD" = {
            action = "diagnostics";
            options = {
              desc = "Workspace diagnostics";
            };
          };
          "<leader>sH" = {
            action = "highlights";
            options = {
              desc = "Search Highlight Groups";
            };
          };

          "<leader>sM" = {
            action = "man_pages";
            options = {
              desc = "Man pages";
            };
          };
          "<leader>sm" = {
            action = "marks";
            options = {
              desc = "Jump to Mark";
            };
          };
          "<leader>so" = {
            action = "vim_options";
            options = {
              desc = "Options";
            };
          };
          "<leader>sR" = {
            action = "resume";
            options = {
              desc = "Resume";
            };
          };
          "<leader>uC" = {
            action = "colorscheme";
            options = {
              desc = "Colorscheme preview";
            };
          };
        };
      };
      lightline = {
        enable = true;
        settings = {
          active = {
            left = [
              [
                "mode"
                "paste"
              ]
              [
                "readonly"
                "filename"
                "modified"
                "gitbranch"
              ]
            ];
            right = [
              [
                "lineinfo"
              ]
              [
                "percent"
              ]
              [
                "fileformat"
                "fileencoding"
                "filetype"
              ]
            ];
          };
          component_function = {
            gitbranch = "FugitiveHead";
          };
        };
      };

      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>c";
            desc = "[C]ode";
          }
          {
            __unkeyed-1 = "<leader>d";
            desc = "[D]ebug";
          }
          {
            __unkeyed-1 = "<leader>r";
            desc = "[R]ename";
          }
          {
            __unkeyed-1 = "<leader>t";
            desc = "[T]est";
          }
          {
            __unkeyed-1 = "<leader>s";
            desc = "[S]earch";
          }
        ];
      };
      treesitter = {
        enable = true;
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        nixGrammars = true;
        settings = {
          # ensure_installed = ["java" "go" "zig" "yaml" "rust" "lua" "toml" "nix" "javascript" "typescript" "python" "proto" "sql"];
          highlight.enable = true;
          auto_install = true;
        };
      };
      otter = {
        enable = true;
        settings = {
          handle_leading_whitespace = true;
        };
      };
      treesitter-context.enable = true;
      treesitter-refactor = {
        enable = true;
        highlightDefinitions = {
          enable = true;
          # Set to false if you have an `updatetime` of ~100.
          clearOnCursorMove = false;
        };
      };
      yanky = {
        enable = true;
        enableTelescope = true;
      };
      hmts.enable = true;
      treesitter-textobjects = {
        enable = true;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ii" = "@conditional.inner";
            "ai" = "@conditional.outer";
            "il" = "@loop.inner";
            "al" = "@loop.outer";
            "at" = "@comment.outer";
          };
        };
        move = {
          enable = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {
            "<leader>a" = "@parameters.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.outer";
          };
        };
      };

      lsp = {
        enable = true;
        inlayHints = true;
        keymaps = {
          silent = true;
          lspBuf = {
            "<leader>rn" = {
              action = "rename";
              desc = "LSP: [R]e[n]ame";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "LSP: [C]ode [A]ction";
            };
          };
          diagnostic = {
            "<leader>cd" = {
              action = "open_float";
              desc = "Line Diagnostics";
            };
            "[d" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
            "]d" = {
              action = "goto_prev";
              desc = "Previous Diagnostic";
            };
          };
          extra = [
            # Jump to the definition of the word under your cusor.
            #  This is where a variable was first declared, or where a function is defined, etc.
            #  To jump back, press <C-t>.
            {
              mode = "n";
              key = "gd";
              action.__raw = "require('telescope.builtin').lsp_definitions";
              options = {
                desc = "LSP: [G]oto [D]efinition";
              };
            }
            # Find references for the word under your cursor.
            {
              mode = "n";
              key = "gr";
              action.__raw = "require('telescope.builtin').lsp_references";
              options = {
                desc = "LSP: [G]oto [R]eferences";
              };
            }
            # Jump to the implementation of the word under your cursor.
            #  Useful when your language has ways of declaring types without an actual implementation.
            {
              mode = "n";
              key = "gI";
              action.__raw = "require('telescope.builtin').lsp_implementations";
              options = {
                desc = "LSP: [G]oto [I]mplementation";
              };
            }
            # Jump to the type of the word under your cursor.
            #  Useful when you're not sure what type a variable is and you want to see
            #  the definition of its *type*, not where it was *defined*.
            {
              mode = "n";
              key = "gD";
              action.__raw = "require('telescope.builtin').lsp_type_definitions";
              options = {
                desc = "LSP: Type [D]efinition";
              };
            }
            # Fuzzy find all the symbols in your current document.
            #  Symbols are things like variables, functions, types, etc.
            {
              mode = "n";
              key = "<leader>lds";
              action.__raw = "require('telescope.builtin').lsp_document_symbols";
              options = {
                desc = "LSP: [D]ocument [S]ymbols";
              };
            }
            # Fuzzy find all the symbols in your current workspace.
            #  Similar to document symbols, except searches over your entire project.
            {
              mode = "n";
              key = "<leader>ws";
              action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              options = {
                desc = "LSP: [W]orkspace [S]ymbols";
              };
            }
          ];
        };
        onAttach = ''
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          -- The following two autocommands are used to highlight references of the
          -- word under the cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        '';

        servers = {
          cucumber_language_server = {
            enable = true;
            package = null;
          };
          nixd.enable = true;
          # nil-ls = {enable = true;};
          jsonls.enable = true;
          gopls = {
            enable = true;

            settings = {
              gopls = {
                gofumpt = true;
                codelenses = {
                  gc_details = false;
                  run_govulncheck = true;
                  generate = true;
                  test = true;
                  tidy = true;
                  upgrade_dependency = true;
                };
                analyses = {
                  fieldalignment = true;
                  nilness = true;
                  unusedparams = true;
                  unusedwrite = true;
                  useany = true;
                };
                hints = {
                  # assignVariableTypes = true;
                  # functionTypeParameters = true;
                  compositeLiteralFields = true;
                  compositeLiteralTypes = true;
                  constantValues = true;
                  # parameterNames = true;
                  rageVariableTypes = true;
                };
                # usePlaceholders = true;
                # experimentalPostfixCompletions = true;
                completeUnimported = true;
                staticcheck = true;
                # semanticTokens = true;
              };
            };
          };
          # bufls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          sqls = {
            enable = true;
            settings = {
              connections = [
                {
                  driver = "postgresql";
                  dataSourceName = "host=127.0.0.1 port=5432 user=backend password=12345 dbname=backend sslmode=disable";
                }
              ];
            };
          };
          ts_ls = {
            enable = true;
            filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact"];
            extraOptions = {
              settings = {
                javascript = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = true;
                    includeInlayFunctionLikeReturnTypeHints = true;
                    includeInlayFunctionParameterTypeHints = true;
                    includeInlayParameterNameHints = "all";
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                    includeInlayPropertyDeclarationTypeHints = true;
                    includeInlayVariableTypeHints = true;
                  };
                };
                typescript = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = true;
                    includeInlayFunctionLikeReturnTypeHints = true;
                    includeInlayFunctionParameterTypeHints = true;
                    includeInlayParameterNameHints = "all";
                    includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                    includeInlayPropertyDeclarationTypeHints = true;
                    includeInlayVariableTypeHints = true;
                  };
                };
              };
            };
          };
          eslint.enable = true;
          zls.enable = true;
          metals.enable = true;
          terraformls.enable = true;
          pyright.enable = true;
          yamlls.enable = true;
        };
      };
      lint = {
        #TODO consoder using it
        enable = true;
        linters = {
          buf_lint = {
            append_fname = false;
            args = ["--exclude-path .idea"];
          };
        };
        lintersByFt = {
          proto = ["buf_lint"];
          nix = ["statix"];
          lua = ["selene"];
          javascript = ["eslint_d"];
          javascriptreact = ["eslint_d"];
          typescript = ["eslint_d"];
          typescriptreact = ["eslint_d"];
          json = ["jsonlint"];
          java = ["checkstyle"];
          go = [
            "golangcilint"
          ];
        };
      };
      lsp-format = {
        #TODO consider using it
        enable = true;
      };
      lsp-status.enable = true;
      nvim-jdtls = {
        enable = true;
        data = "~/.cache/jdtls/workspace";
      };

      #TESTS
      neotest = {
        enable = true;
        adapters = {
          golang = {
            enable = true;
            settings = {
              dap_go_enabled = true;
            };
          };
          # java.enable = true;
          rust.enable = true;
          scala.enable = true;
          zig.enable = true;
        };
        settings = {
          log_level = "debug";
          diagnostic.severity = "info";
          output = {
            enabled = true;
          };
          output_panel = {
            enabled = true;
            open = "botright split | resize 15";
          };
          quickfix = {
            enabled = false;
          };
        };
      };

      #DEBUG
      dap = {
        enable = true;
        signs = {
          dapBreakpoint = {
            text = "●";
            texthl = "DapBreakpoint";
          };
          dapBreakpointCondition = {
            text = "●";
            texthl = "DapBreakpointCondition";
          };
          dapLogPoint = {
            text = "◆";
            texthl = "DapLogPoint";
          };
        };
        extensions = {
          # Creates a beautiful debugger UI
          dap-ui = {
            enable = true;

            # Set icons to characters that are more likely to work in every terminal.
            # Feel free to remove or use ones that you like more! :)
            # Don't feel like these are good choices.
            icons = {
              expanded = "▾";
              collapsed = "▸";
              current_frame = "*";
            };

            controls = {
              icons = {
                pause = "⏸";
                play = "▶";
                step_into = "⏎";
                step_over = "⏭";
                step_out = "⏮";
                step_back = "b";
                run_last = "▶▶";
                terminate = "⏹";
                disconnect = "⏏";
              };
            };
          };

          # Add your own debuggers here
          dap-go = {
            enable = true;
          };
        };
      };
    };
  };
}
