local luacheck = {
  std = 'love+luajit',
  max_line_length = false,
  new_read_globals = { 'inspect', 'bit32', 'log' },
  files = {},
}

luacheck.files['test/**/*.lua'] = {
  read_globals = { 'describe', 'it', 'assert', 'before_each' },
}

return luacheck
