local M = {}

local output = {}

local tsErrorFilePattern = "(%a+/%a+.ts%(%d,%d%)): error .+: .+%."
local tsErrorMessagePattern = "%a+/%a+.ts%(%d,%d%): error .+: (.+)%."

local function print_stdout(chan_id, data, name)
  -- TS build
  P(data)

  local filePath = string.match(data[1], tsErrorFilePattern)

  if filePath ~= nil then
    local error = string.match(data[1], tsErrorMessagePattern)
    table.insert(output, { file = filePath, error = error })
  end


  -- ES lint
  if data[2] ~= nil and string.sub(data[2], 1, 1) == '/' then -- Start of path to file with error
    local errors = {}

    for i = 3, table.maxn(data) do
      if data[i] == "" then -- Useless information from here
        break
      end

      table.insert(output, { file = data[2], error = data[i] })
    end
  end
end

local function on_exit(chan_id, data, name)
  -- for _, value in ipairs(output) do
  -- print(value)
  -- end
  P(output)
end

M.lint = function ()
  output = {}
  local job_id = vim.fn.jobstart("npm run bl", {
    on_stdout = print_stdout,
    on_exit = on_exit
  })
end

return M
