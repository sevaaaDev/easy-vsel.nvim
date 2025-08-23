local M = {}
local last_cmd = nil
local namespaces = "my_overlay_ns"

local function mark_col(ns, pos, count)
	vim.api.nvim_buf_set_extmark(0, ns, pos[1] - 1, pos[2], {
		virt_text = { { tostring(count), "Search" } }, -- text and highlight group
		virt_text_pos = "overlay", -- overlays the actual character
	})
end
local function clear_mark()
	if vim.api.nvim_get_namespaces()[namespaces] then
		vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()[namespaces], 0, -1)
	end
end

local function mark_til(direction, start_pos)
	local ns = vim.api.nvim_create_namespace(namespaces)
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
		mark_col(ns, next_pos, letter)
		i = i + 1
		if i == 10 then
			break
		end
		last_pos = next_pos
	end
	vim.api.nvim_win_set_cursor(0, start_pos)
end

-- WARN: one of the timer will still execute if you press 2 opposite motion (eg. b then e)
-- i could clear all timer in each func but this behaviour is rare and barely cause issue
local last_eol_timer
local function mark_til_eol()
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	clear_mark()
	mark_til("e", orig_pos)
	if last_eol_timer then
		last_eol_timer:close()
	end
	last_eol_timer = vim.defer_fn(function()
		clear_mark()
		last_eol_timer = nil
	end, 1000)
end

local last_bol_timer
local function mark_til_bol()
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	clear_mark()
	mark_til("b", orig_pos)
	if last_bol_timer then
		last_bol_timer:close()
	end
	last_bol_timer = vim.defer_fn(function()
		clear_mark()
		last_bol_timer = nil -- needed so i dont close a closed timer next run
	end, 1000)
end

---Mark count til end of line, and set core.last_cmd to e
function M.e()
	mark_til_eol()
	last_cmd = "e"
end

---Mark count til beginning of line, and set core.last_cmd to b
function M.b()
	mark_til_bol()
	last_cmd = "b"
end

---Repeat core.last_cmd by count
---@param count number|string
---@return string
function M.repeat_motion(count)
	return count .. last_cmd
end

---Clear mark and last_cmd
function M.clear()
	clear_mark()
	last_cmd = ""
end

return M
