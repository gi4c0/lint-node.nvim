local viewer = require "lint-node.telescope-view"
local parsers = require "lint-node.parsers"
local utils = require "lint-node.utils"

local M = {}

M._config = {}

-- { path = pathToFile, message = "error message", lnum = 25, column = 2 }
local output = {}

local function print_stdout(chan_id, data, name)
  utils.debug(data, M._config.debug, "input")
  parsers.parseTsError(data[1], output) -- TS build
  parsers.parseEsLintError(data[1], output) -- ES lint
end

local function on_exit(chan_id, data, name)
  utils.debug(output, M._config.debug, "output")
  viewer.show(output)
  print ""
end

local function on_error(_, data)
  utils.debug(data, M._config.debug, "error")
  local noCommandError = "ERR! Missing script"

  if utils.stringStartsWith(utils.trimStr(data[1]), noCommandError) then
    error("Command '"..M._config.command.."' not found")
  end
end


M.lint = function()
  output = {}

  vim.fn.jobstart(M._config.command, { on_stdout = print_stdout, on_exit = on_exit, on_stderr = on_error })
  print "Searching for errors..."
end

M.setup = function(config)
  utils.checkConfig(config)

  M._config = {
    command = config.command,
    key = config.key or "<leader>eL",
    debug = config.debug or false
  }

  vim.keymap.set("n", M._config.key, M.lint, { silent = true, noremap = true })
end

return M
