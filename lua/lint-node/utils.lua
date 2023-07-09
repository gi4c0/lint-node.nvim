local M = {}

M.split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

M.checkConfig = function(config)
  if not config then
    error("No config provided for lint-node. Use require('lint-node').setup{cfg}", 2)
  end

  if not config.command then
    error("No command provided to execute in the setup function. Use require('lint-node').setup{command = 'your_command'}", 2)
  end
end

M.debug = function(data, debug, level)
  if debug then
    print("---- Debug info "..level.." ----")
    P(data)
    print "--------------------"
  end
end

M.stringStartsWith = function(str, subStr)
  return string.sub(str, 1, string.len(subStr)) == subStr
end

M.trimStr = function(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

M.find_index = function (table, fn)
  for i, v in ipairs(table) do
    if fn(v) then
      return i
    end
  end
  return nil
end

return M
