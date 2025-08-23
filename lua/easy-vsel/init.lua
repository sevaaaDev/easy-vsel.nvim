local M = {}
local core = require("easy-vsel.core")

local function keymap(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.remap = true
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function setup_count_keymap()
	for i = 1, 9, 1 do
		keymap("v", tostring(i), function()
			return core.repeat_motion(i)
		end, { expr = true })
	end
end
local function e()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("norm! e")
	end
	core.e()
end
local function b()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("norm! b")
	end
	core.b()
end
M.setup = function(config)
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "v:*",
		callback = function()
			core.clear()
		end,
	})
	keymap("v", "e", e)
	keymap("v", "b", b)
	setup_count_keymap()
end

return M
