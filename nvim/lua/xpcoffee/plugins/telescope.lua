return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/which-key.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local builtins = require('telescope.builtin')
    local action_state = require('telescope.actions.state')
    local actions = require('telescope.actions')
    local themes = require('telescope.themes')

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
        }
      },
      pickers = {
        find_files = {
          hidden = true
        }
      }
    })

    telescope.load_extension("fzf")

    local function live_grep_selection()
      local selection = vim.fn.getregion(
        vim.fn.getpos("v"),
        vim.fn.getpos(".")
      )

      builtins.live_grep {
        default_text = table.concat(selection)
      }
    end

    -- keymaps
    require("which-key").add({ "<leader>f", group = "files" })
    vim.keymap.set('n', '<leader>ff', builtins.find_files, { desc = 'Find file' })
    vim.keymap.set('n', '<leader>fg', builtins.live_grep, { desc = 'Grep through files' })
    vim.keymap.set('v', '<leader>fg', live_grep_selection, { desc = 'Grep through files' })
    vim.keymap.set('n', '<leader><leader>u', builtins.lsp_references, { desc = 'Usages/references' })
    vim.keymap.set('n', '<leader><leader>f', builtins.lsp_document_symbols, { desc = 'File symbols' })
    vim.keymap.set('n', '<leader><leader>p', builtins.lsp_dynamic_workspace_symbols, { desc = 'Project symbols' })
    vim.keymap.set('n', '<leader><leader>m', builtins.marks, { desc = 'Marks' })


    -- delete buffers
    local function buffers(opts)
      opts = opts or {}
      opts.previewer = false
      opts.attach_mappings = function(prompt_bufnr, map)
        local delete_buf = function()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          local multi_selections = current_picker:get_multi_selection()

          if next(multi_selections) == nil then
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.api.nvim_buf_delete(selection.bufnr, { force = true })
          else
            actions.close(prompt_bufnr)
            for _, selection in ipairs(multi_selections) do
              vim.api.nvim_buf_delete(selection.bufnr, { force = true })
            end
          end
        end

        map('n', 'm', actions.toggle_selection)
        map('n', 'd', delete_buf)
        return true
      end
      builtins.buffers(themes.get_dropdown(opts))
    end
    vim.keymap.set('n', '<leader>fb', buffers, { desc = 'Find buffer' })
  end
}
