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
  extraConfigLua = ''
      function AddGherkinColumn(table_name, col_name, col_value)
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local new_lines = {}
      local i = 1
      local total = #lines
      local columns_added = false -- Track if we actually made any changes

      -- Helper trim function
      local function trim(s)
        return s:match("^%s*(.-)%s*$")
      end

      while i <= total do
        local line = lines[i]
        table.insert(new_lines, line)

        -- Match the specific table fixture step
        local pattern = '^%s*And the next fixtures exist in "' .. vim.pesc(table_name) .. '" table:'
        if line:match(pattern) then
          local j = i + 1
          local table_start = j

          -- find end of the table (blank or non-table line)
          while j <= total and lines[j]:match("^%s*|") do
            j = j + 1
          end
          local table_end = j - 1

          -- Ensure we actually found a table body
          if table_start <= table_end then
            -- START: Check if column exists
            local header_line = lines[table_start]
            local column_exists = false

            -- Iterate over columns between pipes |
            for col_text in header_line:gmatch("([^|]+)") do
              if trim(col_text) == col_name then
                column_exists = true
                break
              end
            end
            -- END: Check if column exists

            if column_exists then
              -- Column exists: print warning and add original lines
              print("⚠️ Column '" .. col_name .. "' already exists in table \"" .. table_name .. "\". Skipping.")
              for k = table_start, table_end do
                table.insert(new_lines, lines[k])
              end
            else
              -- Column does NOT exist: proceed with modification
              columns_added = true -- Mark that we are making a change

              -- START: Padding logic
              local header_len = string.len(col_name)
              local value_len = string.len(col_value)
              local max_len = math.max(header_len, value_len)

              local header_padding = string.rep(" ", max_len - header_len)
              local value_padding = string.rep(" ", max_len - value_len)

              local formatted_header = col_name .. header_padding
              local formatted_value = col_value .. value_padding
              -- END: Padding logic

              -- Add column to each row in this table
              for k = table_start, table_end do
                local l = lines[k]
                if l:match("^%s*|") then
                  if k == table_start then
                    table.insert(new_lines, (l:gsub("|%s*$", "| " .. formatted_header .. " |")))
                  else
                    table.insert(new_lines, (l:gsub("|%s*$", "| " .. formatted_value .. " |")))
                  end
                else
                  table.insert(new_lines, l)
                end
              end
            end
          end -- end if table_start <= table_end

          -- Skip over the processed lines
          i = table_end
        end

        i = i + 1
      end

      vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
      if columns_added then
        print("✅ Added column '" .. col_name .. "' to table \"" .. table_name .. "\"")
      end
    end
  '';

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
