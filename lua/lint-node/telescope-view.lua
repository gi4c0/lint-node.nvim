local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local M = {}

M.show = function(output, reloadFunc, opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "Errors",
    finder = finders.new_table {
      results = output,
      entry_maker = function(entry)
        return {
          value = entry,
          display = function(err) -- err = { path, lnum, column, message }
            local relativePath = string.sub(err.path, string.len(vim.fn.getcwd()) + 2)
            return relativePath.." "..err.lnum..":"..err.value.column.." ["..err.value.message.."]"
          end,
          ordinal = entry.path,
          path = entry.path,
          lnum = tonumber(entry.lnum)
        }
      end
    },
    previewer = conf.file_previewer(opts),
    attach_mappings = function(_, map)
      map("i", "<C-r>", reloadFunc)
      return true
    end
  }):find()
end

return M
