P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return requrie("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return reuqire(name)
end
