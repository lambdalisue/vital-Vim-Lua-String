function! s:expose() abort
  "if exists('s:module_exposed') || !has('lua')
  "  return
  "endif
  "let s:module_exposed = 1
  lua << EOF
do
  local M = {}
  local escape_quotes = function(x)
    return string.gsub(x, '"', '\\"')
  end
  M.vim = {}
  M.vim.strwidth = function(x)
    return vim.eval(string.format('strwidth("%s")', escape_quotes(x)))
  end
  M.vim.strchars = function(x)
    return vim.eval(string.format('strchars("%s")', escape_quotes(x)))
  end

  if utf8 == nil then
    local ok, utf8 = pcall(require, 'lua-utf8')
    if not ok then
      print('lua-utf8 is not available.')
      utf8 = nil
    end
  end

  if utf8 then
    local ambi_is_double = vim.eval('&ambiwidth') == 'double'
    M.utf8 = {}
    M.utf8.strwidth = function(x)
      return utf8.width(x, ambi_is_double, 1)
    end
    M.utf8.strchars = utf8.len
    M.strwidth = M.utf8.strwidth
    M.strchars = M.utf8.strchars
  else
    M.strwidth = M.vim.strwidth
    M.strchars = M.vim.strchars
  end
  vital_vim_lua_string = M
end
EOF
endfunction
