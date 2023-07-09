local utils = require "lint-node.utils"

local M = {}

local tsErrorFilePattern = "(%a+/%a+.ts)%(%d,%d%): error .+: .+%."
local tsErrorLineAndNumberPattern = "%a+/%a+.ts%((%d,%d)%): error .+: .+%."
local tsErrorMessagePattern = "%a+/%a+.ts%(%d,%d%): error .+: (.+)%."

M.parseTsError = function(str, output)
  -- TS build
  local filePath = string.match(str, tsErrorFilePattern)
  local errorMessage = string.match(str, tsErrorMessagePattern)
  local lineAndNumber = string.match(str, tsErrorLineAndNumberPattern)

  if filePath ~= nil and errorMessage ~= nil and lineAndNumber ~= nil then
    local splittedLineAndNumber = utils.split(lineAndNumber, ",")
    table.insert(output, {
      path = vim.fn.getcwd().."/"..filePath,
      message = errorMessage,
      lnum = splittedLineAndNumber[1],
      column = splittedLineAndNumber[2]
    })

    return
  end
end

M.parseEsLintError = function(str, output)
  if str ~= nil and string.sub(str, 1, 2) == "[{" then -- ES lint output
    local parsed = vim.json.decode(str)

    for _, file in ipairs(parsed) do
      for _, error in ipairs(file.messages) do
        table.insert(output, {
          path = file.filePath,
          message = error.message,
          lnum = error.line,
          column = error.column
        })
      end
    end
  end
end

return M
