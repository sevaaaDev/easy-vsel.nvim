local easy_select_last_cmd = ""
local M = {}
local function mark_col(namespaces, pos, count)
	vim.api.nvim_buf_set_extmark(0, namespaces, pos[1] - 1, pos[2], {
		virt_text = { { tostring(count), "Search" } }, -- text and highlight group
		virt_text_pos = "overlay", -- overlays the actual character
	})
end

local function mark_til(direction, start_pos)
	local namespaces = vim.api.nvim_create_namespace("my_overlay_ns")
	local i = 1
	local last_pos = start_pos
	local next_pos = start_pos
	while true do
		vim.cmd("normal! " .. direction)
		next_pos = vim.api.nvim_win_get_cursor(0)
		if last_pos[1] ~= next_pos[1] then
			break
		end
		local letter = tostring(i)
		if i == 1 then
			letter = direction
		end
		mark_col(namespaces, next_pos, letter)
		i = i + 1
		if i == 10 then
			break
		end
		last_pos = next_pos
	end
	vim.api.nvim_win_set_cursor(0, start_pos)
end
local function mark_til_eol(start_pos)
	mark_til("e", start_pos)
end

local function mark_til_bol(start_pos)
	mark_til("b", start_pos)
end
local function clear_mark(namespaces)
	if vim.api.nvim_get_namespaces()[namespaces] then
		vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()[namespaces], 0, -1)
	end
end

-- move e
-- mark
-- loop til cursor change line
-- 	if prev pos line != curr pos line
local function easy_select_e()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("normal! e")
	end
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	clear_mark("my_overlay_ns")
	mark_til_eol(orig_pos)
	easy_select_last_cmd = "e"
end
local function easy_select_b()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("normal! b")
	end
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	clear_mark("my_overlay_ns")
	mark_til_bol(orig_pos)
	easy_select_last_cmd = "b"
end

M.setup = function(config)
	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "v:*",
		callback = function()
			clear_mark("my_overlay_ns")
			easy_select_last_cmd = ""
		end,
	})
	local function keymap(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.remap = true
		opts.silent = true
		vim.keymap.set(mode, lhs, rhs, opts)
	end
	keymap("v", "e", easy_select_e)
	keymap("v", "b", easy_select_b)
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
