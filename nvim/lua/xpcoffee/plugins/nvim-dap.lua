local js_adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'pwa-extensionHost' }
local js_languages = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "folke/which-key.nvim",
      config = function()
        require("which-key").add({ "<leader><leader>d", group = "debugger" })
      end
    },
    {
      "microsoft/vscode-js-debug",
      -- see npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
      -- see https://www.youtube.com/watch?v=Ul_WPhS2bis
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      config = function()
        require("dap-vscode-js").setup({
          adapters = js_adapters, -- which adapters to register in nvim-dap
          debugger_path = vim.fn.resolve(vim.fn.stdpath('data') .. '/lazy/vscode-js-debug')
        })
      end

    },
    "rcarriga/nvim-dap-ui",
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {}
    },
  },
  keys = {
    {
      "<leader><leader>da",
      function()
        -- load configs from launch.json
        if (vim.fn.filereadable("./vscode/launch.json")) then
          local vscode = require("dap.ext.vscode")
          vscode.load_launchjs(nil, {})
        end

        require("dap").continue()
      end,
      desc = "Run with Args"
    },
    { "<leader><leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader><leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
    { "<leader><leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
    { "<leader><leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
    { "<leader><leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
    { "<leader><leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
    { "<leader><leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
    { "<leader><leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
    { "<leader><leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
    { "<leader><leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
    { "<leader><leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
    { "<leader><leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
    { "<leader><leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
    { "<leader><leader>ds", function() require("dap").session() end,                                              desc = "Session" },
    { "<leader><leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
    { "<leader><leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
  },
  config = function()
    local dap = require("dap")

    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = { '--interpreter=vscode' },
    }

    -- dap.configurations.cs = {
    --   {
    --     type = "coreclr",
    --     name = "launch - netcoredbg",
    --     request = "launch",
    --     program = function()
    --       return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    --     end,
    --   },
    -- }

    -- default debugger options for js
    for _, language in ipairs(js_languages) do
      dap.configurations[language] = {
        {
          request = 'attach',
          name = 'Attach to Node process',
          address = '127.0.0.1',
          -- prompt for port
          port = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                  prompt = "Enter the port",
                  default = "9229"
                },
                function(port)
                  if port == nil or port == "" then
                    return
                  else
                    coroutine.resume(co, port)
                  end
                end
              )
            end)
          end,
          sourceMaps = true,
          cwd = "${workspaceFolder}",
          type = 'pwa-node',
          -- skipping files doesn't actually seem to be working; still seeing issues reading sources
          skipFiles = {
            "${workspaceFolder}/node_modules/**/*.js",
            "${workspaceFolder}/dist/**/*.js",
            "node_modules/**",
            "dist/**",
            "<node_internals>/**"
          }
        },
        {
          -- placeholder to show which configs are from launch.json file
          name = "---- launch.json ----",
          type = "",
          request = "launch"
        }
      }
    end
  end
}
