local viewer = require "lint-node.telescope-view"
local parsers = require "lint-node.parsers"
local utils = require "lint-node.utils"

local M = {}

M._config = {}

-- { path = pathToFile, message = "error message", lnum = 25, column = 2 }
local output = {}

local function print_stdout(chan_id, data, name)
  if M._config.debug then
    print "---- Debug info input ----"
    P(data)
    print "--------------------"
  end
  -- TS build
  parsers.parseTsError(data[1], output)

  -- ES lint
  parsers.parseEsLintError(data[1], output)
end

local function on_exit(chan_id, data, name)
  if M._config.debug then
    print "---- Debug info output ----"
    P(output)
    print "--------------------"
  end
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
  utils.checkConfig(config)

  M._config = {
    command = config.command,
    key = config.key or "<leader>eL",
    debug = config.debug or false
  }

  vim.keymap.set("n", M._config.key, M.lint, { silent = true, noremap = true })
end

return M
