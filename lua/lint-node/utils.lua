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

return M
