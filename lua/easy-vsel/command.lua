local M = {}
local core = require("easy-vsel.core")
function M.e()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("norm! e")
	end
	core.e()
end

function M.b()
	for _ = 1, vim.v.count1, 1 do
		vim.cmd("norm! b")
	end
	core.b()
end

function M.repeat_selection(count)
	core.repeat_motion(count)
end
return M
