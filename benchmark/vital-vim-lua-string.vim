scriptencoding utf-8

function! s:native_version(candidates) abort
  let result = []
  lua << EOF
do
  local M = vital_vim_lua_string
  local result = vim.eval('result')
  local candidates = vim.eval('a:candidates')
  for i = 0, #candidates-1 do
    local word = candidates[i]
    result[#result] = M.utf8.strwidth(word) .. M.utf8.strchars(word)
  end
end
EOF
  return result
endfunction

function! s:eval_version(candidates) abort
  let result = []
  lua << EOF
do
  local M = vital_vim_lua_string
  local result = vim.eval('result')
  local candidates = vim.eval('a:candidates')
  for i = 0, #candidates-1 do
    local word = candidates[i]
    result[#result] = M.vim.strwidth(word) .. M.vim.strchars(word)
  end
end
EOF
  return result
endfunction


function! s:timeit(name, fn, args) abort
  let outer = 5
  let inner = 10
  let timespans = []
  for n in range(1, outer)
    let start = reltime()
    for i in range(1, inner)
      call call(a:fn, deepcopy(a:args))
    endfor
    call add(timespans, str2float(reltimestr(reltime(start))))
  endfor
  let mean = eval(join(timespans, '+')) / len(timespans)
  echomsg printf('%s: %f s', a:name, mean)
endfunction

function! s:main() abort
  let LuaString = vital#vital#import('Vim.Lua.String')
  call LuaString.expose()
  let args = [map(range(1000), 'string(v:val)')]
  call s:timeit('native', function('s:native_version'), args)
  call s:timeit('eval', function('s:eval_version'), args)
endfunction

call s:main()
