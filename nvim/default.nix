{
  lib,
  pkgs,
  ...
}: {
  imports = [
  ];

  programs.nixvim = {
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
        key = "<leader>cp";
        action = "<cmd>MarkdownPreview<cr>";
        options = {
          desc = "Markdown Preview";
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
        mode = ["n"];
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        options = {desc = "Open file tree";};
      }

      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>Telescope diagnostics bufnr=0<cr>";
        options = {
        };
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
      {
        mode = "n";
        key = "<F5>";
        action.__raw = ''
          function()
            require('dap').continue()
          end
        '';
        options = {
          desc = "Debug: Start/Continue";
        };
      }
      {
        mode = "n";
        key = "<F1>";
        action.__raw = ''
          function()
            require('dap').step_into()
          end
        '';
        options = {
          desc = "Debug: Step Into";
        };
      }
      {
        mode = "n";
        key = "<F2>";
        action.__raw = ''
          function()
            require('dap').step_over()
          end
        '';
        options = {
          desc = "Debug: Step Over";
        };
      }
      {
        mode = "n";
        key = "<F3>";
        action.__raw = ''
          function()
            require('dap').step_out()
          end
        '';
        options = {
          desc = "Debug: Step Out";
        };
      }
      {
        mode = "n";
        key = "<leader>b";
        action.__raw = ''
          function()
            require('dap').toggle_breakpoint()
          end
        '';
        options = {
          desc = "Debug: Toggle Breakpoint";
        };
      }
      {
        mode = "n";
        key = "<leader>B";
        action.__raw = ''
          function()
            require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
          end
        '';
        options = {
          desc = "Debug: Set Breakpoint";
        };
      }
      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      {
        mode = "n";
        key = "<F7>";
        action.__raw = ''
          function()
            require('dapui').toggle()
          end
        '';
        options = {
          desc = "Debug: See last session result.";
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Git blame<CR>";
        options = {
          desc = "Enbale git blame";
        };
      }
    ];
    highlight.Todo = {
      fg = "Blue";
      bg = "Yellow";
    };

    match.TODO = "TODO";

    extraConfigLua = ''
      require("telescope").setup{
        pickers = {
          colorscheme = {
            enable_preview = true
          }
        }
      }
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
      require("telescope").load_extension("lazygit")
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
      lazygit-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "flit";
        src = pkgs.fetchFromGitHub {
          owner = "ggandor";
          repo = "flit.nvim";
          rev = "1ef72de6a02458d31b10039372c8a15ab8989e0d";
          hash = "sha256-lLlad/kbrjwPE8ZdzebJMhA06AqpmEI+PJCWz12LYRM=";
        };
      })
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

        require('neodev').setup {}
      '';

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    opts.completeopt = ["menu" "menuone" "noselect"];
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
      updatetime = 10;
      relativenumber = true;
      wrap = true;
      cursorline = true;
      number = true;
      smartindent = true;
      swapfile = true;
      breakindent = true;
      undofile = true;
      incsearch = true;
      ignorecase = true;
      # termguicolors = true; now it resolves automaticly
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
    };
    plugins = {
      markdown-preview.enable = true;
      barbar = {
        enable = true;
        keymaps = {
          next.key = "<TAB>";
          previous.key = "<S-TAB>";
          close.key = "q<TAB>";
        };
      };
      bufferline.enable = true;
      undotree.enable = true;
      auto-session = {
        enable = true;
        autoRestore.enabled = true;
        autoSave.enabled = true;
        autoSession.enabled = true;
      };

      noice.enable = true;
      startup = {
        enable = true;

        colors = {
          background = "#ffffff";
          foldedSection = "#ffffff";
        };

        sections = {
          header = {
            type = "text";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Header";
            margin = 5;
            content = [
              "            ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "            ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "            ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "            ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "            ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "            ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            highlight = "Statement";
            defaultColor = "";
            oldfilesAmount = 0;
          };

          body = {
            type = "mapping";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Menu";
            margin = 5;
            content = [
              [
                " Find File"
                "Telescope find_files"
                "<leader>ff"
              ]
              [
                "󰍉 Find Word"
                "Telescope live_grep"
                "<leader>gs"
              ]
              [
                " Recent Files"
                "Telescope oldfiles"
                "<leader>s"
              ]
              [
                " File Browser"
                "Telescope file_browser"
                "<leader>fe"
              ]
              [
                "Exit"
                "q!"
                "q"
              ]
            ];
            highlight = "string";
            defaultColor = "";
            oldfilesAmount = 0;
          };
        };
        options = {
          paddings = [1 3];
        };

        parts = [
          "header"
          "body"
        ];
      };
      fugitive.enable = true;
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
        sources.formatting = {
          goimports.enable = true;
          gofmt.enable = true;
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
      neo-tree = {
        enable = true;
        sources = ["filesystem" "buffers" "git_status" "document_symbols"];
        addBlankLineAtTop = false;

        filesystem = {
          bindToCwd = false;
          followCurrentFile = {
            enabled = true;
          };
        };

        defaultComponentConfigs = {
          indent = {
            withExpanders = true;
            expanderCollapsed = "";
            expanderExpanded = " ";
            expanderHighlight = "NeoTreeExpander";
          };

          gitStatus = {
            symbols = {
              added = " ";
              conflict = "󰩌 ";
              deleted = "󱂥";
              ignored = " ";
              modified = " ";
              renamed = "󰑕";
              staged = "󰩍";
              unstaged = "";
              untracked = "";
            };
          };
        };
      };
      conform-nvim = {
        enable = true;
        formatOnSave = ''
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

        formatAfterSave = ''
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
        notifyOnError = true;
        formattersByFt = {
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
          # javascript = [
          #   [
          #     "prettierd"
          #     "prettier"
          #   ]
          # ];
          go = ["gofmt" "goimports"];
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

      harpoon = {
        enable = true;

        keymapsSilent = true;

        keymaps = {
          addFile = "<leader>a";
          toggleQuickMenu = "<C-e>";
          navFile = {
            "1" = "<leader>1";
            "2" = "<leader>2";
            "3" = "<leader>3";
            "4" = "<leader>4";
          };
        };
      };
      leap = {
        enable = true;
        #highlightUnlabeledPhaseOneTargets = true;
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

            # Manually trigger a completion from nvim-cmp.
            #  Generally you don't need this, because nvim-cmp will display
            #  completions whenever it has completion options available.
            "<C-Space>" = "cmp.mapping.complete {}";

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
          "<leader>sf" = {
            mode = "n";
            action = "find_files";
            options = {
              desc = "[S]earch [F]iles";
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
              desc = "[S]earch [R]esume";
            };
          };
          "<leader>s" = {
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
          "<leader>fR" = {
            action = "resume";
            options = {
              desc = "Resume";
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
      lightline.enable = true;

      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>c";
            desc = "[C]ode";
          }
          {
            __unkeyed-1 = "<leader>d";
            desc = "[D]ocument";
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
        settings.ensure_installed = ["java" "go" "zig" "yaml" "rust" "lua" "toml" "nix" "javascript" "typescript" "python" "proto"];
      };
      treesitter-textobjects = {
        enable = false;
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
            # "K" = {
            #   action = "hover";
            #   desc = "LSP: Hover Documentation";
            # };
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
              key = "<leader>D";
              action.__raw = "require('telescope.builtin').lsp_type_definitions";
              options = {
                desc = "LSP: Type [D]efinition";
              };
            }
            # Fuzzy find all the symbols in your current document.
            #  Symbols are things like variables, functions, types, etc.
            {
              mode = "n";
              key = "<leader>ds";
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
          nixd.enable = true;
          nil-ls = {enable = true;};
          gopls.enable = true;
          # bufls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          tsserver = {
            enable = false;
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
        };
      };
      lint = {
        enable = true;
        lintersByFt = {
          proto = ["buf_lint"];
        };
      };
      lsp-format = {
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
          go.enable = true;
          # golang.enable = true;
          java.enable = true;
          rust.enable = true;
          scala.enable = true;
          zig.enable = true;
        };
        settings = {
          output = {
            enabled = true;
            open_on_run = true;
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