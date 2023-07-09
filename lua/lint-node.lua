local M = {}

M._config = {}

local defaults = {
  command = "npm run bl"
}

-- { file = pathToFile, error = "error message", place = 25:1 }
local output = {}

local function split (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local tsErrorFilePattern = "(%a+/%a+.ts)%(%d,%d%): error .+: .+%."
local tsErrorLineAndNumberPattern = "%a+/%a+.ts%((%d,%d)%): error .+: .+%."
local tsErrorMessagePattern = "%a+/%a+.ts%(%d,%d%): error .+: (.+)%."

local function print_stdout(chan_id, data, name)
  -- TS build
  local filePath = string.match(data[1], tsErrorFilePattern)
  local errorMessage = string.match(data[1], tsErrorMessagePattern)
  local lineAndNumber = string.match(data[1], tsErrorLineAndNumberPattern)

  if filePath ~= nil and errorMessage ~= nil and lineAndNumber ~= nil then
    local splittedLineAndNumber = split(lineAndNumber, ",")
    table.insert(output, {
      file = vim.fn.getcwd().."/"..filePath,
      error = errorMessage,
      place = splittedLineAndNumber[1]..":"..splittedLineAndNumber[2]
    })

    return
  end

  -- ES lint

  if data[1] ~= nil and string.sub(data[1], 1, 2) == "[{" then -- ES lint output
    local parsed = vim.json.decode(data[1])

    for _, file in ipairs(parsed) do
      for _, error in ipairs(file.messages) do
        table.insert(output, {
          file = file.filePath,
          error = error.message,
          place = error.line..":"..error.column
        })
      end
    end
  end
end

local function on_exit(chan_id, data, name)
  P(output)
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
