-- ┌───────────────────────┐
-- │ harper_ls LSP config  │
-- └───────────────────────┘
--
-- Drop Harper diagnostics on lines that look like ASCII/Unicode diagrams
-- (e.g. Diagon output): lines containing `|`, `+--`, or box-drawing characters.

-- Box-drawing chars U+2500-U+257F are encoded as 0xE2 0x94..0x95 in UTF-8
local is_diagram_line = function(line)
  return line:find('|', 1, true) ~= nil
    or line:find('+-', 1, true) ~= nil
    or line:find('\226[\148\149]') ~= nil
end

local on_publish = vim.lsp.diagnostic.on_publish_diagnostics

return {
  handlers = {
    ['textDocument/publishDiagnostics'] = function(err, result, ctx)
      local bufnr = result and vim.uri_to_bufnr(result.uri)
      if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
        result.diagnostics = vim.tbl_filter(function(d)
          local row = d.range.start.line
          local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
          return not is_diagram_line(line)
        end, result.diagnostics)
      end
      return on_publish(err, result, ctx)
    end,
  },
}
