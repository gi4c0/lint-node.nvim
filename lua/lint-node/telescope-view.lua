local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local utils = require "lint-node.utils"

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
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<C-r>", reloadFunc)


      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        local selection = action_state.get_selected_entry()
        local error_index = utils.find_index(output, function(item)
          return item.path == selection.path and item.lnum == selection.value.lnum and item.column == selection.value.column
        end)

        table.remove(output, error_index)
        vim.api.nvim_command("e +"..selection.lnum.." "..selection.path)
      end)
      return true
    end
  }):find()
end

return M
