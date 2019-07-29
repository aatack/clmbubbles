--- Split a string at each instance of a separator.
function splitstring(string, separator)
  local segments = {}
  local start = 1
  for i = 1, #string do
    local c = string:sub(i, i)
    if c == separator then
      table.insert(segments, string:sub(start, i - 1))
      start = i + 1
    end
  end
  table.insert(segments, string:sub(start, #string))
  return segments
end
