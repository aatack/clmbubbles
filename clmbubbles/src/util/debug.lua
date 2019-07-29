--- Display a table in a more human-legible form.
function tablestring(value)
  if type(value) == "table" then
    local string = "{ "
    local start = true
    for k, v in pairs(value) do
      if start then
        start = false
      else 
        string = string .. ", "
      end
      string = string .. k .. " = " .. tablestring(v)
    end
    return string .. " }"
  else
    return tostring(value)
  end
end

--- Print a table in a more human-legible form.
function pprint(value)
  print(tablestring(value))
end
