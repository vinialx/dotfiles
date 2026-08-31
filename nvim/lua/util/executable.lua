local M = {}

function M.has(cmd)
  return vim.fn.executable(cmd) == 1
end

return M
