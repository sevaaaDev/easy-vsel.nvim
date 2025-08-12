local utils = require("easy-vsel.utils")
local easy_select_last_cmd = ""
local M = {
	config = {},
}
function M.easy_vsel_e()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("normal! e")
	end
	utils.mark_til_eol()
	easy_select_last_cmd = "e"
end
function M.easy_vsel_b()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("normal! b")
	end
	utils.mark_til_bol()
	easy_select_last_cmd = "b"
end

M.setup = function(config)
	M.config.overlay_color = config.overlay_color or "Search"
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "v:*",
		callback = function()
			utils.clear_mark("my_overlay_ns")
			easy_select_last_cmd = ""
		end,
	})
	local function keymap(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.remap = true
		opts.silent = true
		vim.keymap.set(mode, lhs, rhs, opts)
	end
	keymap("v", "e", M.easy_vsel_e)
	keymap("v", "b", M.easy_vsel_b)
	for i = 1, 9, 1 do
		keymap("v", tostring(i), function()
			if easy_select_last_cmd == "" then
				return vim.keycode(tostring(i))
			end
			return vim.keycode(i .. easy_select_last_cmd)
		end, { expr = true })
	end
end

return M
