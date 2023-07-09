local viewer = require "lint-node.telescope-view"
local parsers = require "lint-node.parsers"

local M = {}

M._config = {}

local defaults = {
  command = "npm run bl"
}

-- { file = pathToFile, error = "error message", place = 25, column = 2 }
local output = {}

local function print_stdout(chan_id, data, name)
  -- TS build
  parsers.parseTsError(data[1], output)

  -- ES lint
  parsers.parseEsLintError(data[1], output)
end

local function on_exit(chan_id, data, name)
  viewer.show(output)
end

M.lint = function()
  output = {}
  local job_id = vim.fn.jobstart(M._config.command, {
    on_stdout = print_stdout,
    on_exit = on_exit
  })
end

M.setup = function(config)
  config = config or {}

  M._config = {
    command = config.command or defaults.command
  }
end

M.setup() -- setup default config
return M
