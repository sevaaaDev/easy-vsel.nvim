local M = {}
function M.mark_col(namespaces, pos, count)
	vim.api.nvim_buf_set_extmark(0, namespaces, pos[1] - 1, pos[2], {
		virt_text = { { tostring(count), "Search" } }, -- text and highlight group
		virt_text_pos = "overlay", -- overlays the actual character
	})
end
function M.clear_mark(namespaces)
	if vim.api.nvim_get_namespaces()[namespaces] then
		vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_get_namespaces()[namespaces], 0, -1)
	end
end

function M.mark_til(direction, start_pos)
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
		M.mark_col(namespaces, next_pos, letter)
		i = i + 1
		if i == 10 then
			break
		end
		last_pos = next_pos
	end
	vim.api.nvim_win_set_cursor(0, start_pos)
end
function M.mark_til_eol()
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	M.clear_mark("my_overlay_ns")
	M.mark_til("e", orig_pos)
end

function M.mark_til_bol()
	local orig_pos = vim.api.nvim_win_get_cursor(0)
	M.clear_mark("my_overlay_ns")
	M.mark_til("b", orig_pos)
end
return M
