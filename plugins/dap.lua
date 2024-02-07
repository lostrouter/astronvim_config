return {
  {
    "microsoft/vscode-js-debug",
    opt = true,
    build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      "microsoft/vscode-js-debug"
    },
    init = function()
      local utils = require("dap-vscode-js.utils")
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
        debugger_path = utils.join_paths(utils.get_runtime_dir(), "lazy/vscode-js-debug"),
        -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          } ,
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Tests vitest",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "--trace-warnings",
              "./node_modules/vitest/vitest.mjs",
              "--inspect",
              "run",
              "--pool",
              "forks",
              "--poolOptions.forks.singleFork",
              "--silent",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Tests jest",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/.bin/jest",
              "--no-coverage",
              "--runInBand",
              "${file}"
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          }
        }
      end
    end
  }
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     -- require("dap").adapters["pwa-node"] = {
  --     --   type = "server",
  --     --   host = "127.0.0.1",
  --     --   port = "${port}",
  --     --   executable = {
  --     --     command = "node",
  --     --     -- 💀 Make sure to update this path to point to your installation
  --     --     args = {
  --     --       require("mason-registry").get_package("js-debug-adapter"):get_install_path()
  --     --         .. "/js-debug/src/dapDebugServer.js",
  --     --       "${port}",
  --     --     },
  --     --   },
  --     -- }
  --     require("dap-vscode-js").setup({
  --       -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --       debugger_path = "(runtimedir)/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
  --       -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  --       adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  --       -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  --       -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  --       -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
  --     })
  --
  --     for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  --       require("dap").configurations[language] = {
  --         {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Launch file",
  --           program = "${file}",
  --           cwd = "${workspaceFolder}",
  --         },
  --         {
  --           type = "pwa-node",
  --           request = "attach",
  --           name = "Attach",
  --           processId = require("dap.utils").pick_process,
  --           cwd = "${workspaceFolder}",
  --         } ,
  --         {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Debug Tests vitest",
  --           -- trace = true, -- include debugger info
  --           runtimeExecutable = "node",
  --           runtimeArgs = {
  --             "./node_modules/vitest/vitest.mjs",
  --           },
  --           rootPath = "${workspaceFolder}",
  --           cwd = "${workspaceFolder}",
  --           console = "integratedTerminal",
  --           internalConsoleOptions = "neverOpen",
  --         },
  --         {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Debug Tests jest",
  --           -- trace = true, -- include debugger info
  --           runtimeExecutable = "node",
  --           runtimeArgs = {
  --             "./node_modules/.bin/jest",
  --             "--no-coverage",
  --             "--runInBand",
  --             "${file}"
  --           },
  --           rootPath = "${workspaceFolder}",
  --           cwd = "${workspaceFolder}",
  --           console = "integratedTerminal",
  --           internalConsoleOptions = "neverOpen",
  --         }
  --       }
  --     end
  --   end,
  -- },
}

