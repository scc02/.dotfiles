local M = {}
M.get_listed_buf_count = function()
  local buf_len = #vim.fn.getbufinfo({ buflisted = 1 })
  return buf_len
  -- local count = 0
  -- for _text, value in ipairs(buf_len) do
  --   if value.hidden == 0 then
  --     count = count + 1
  --   end
  -- end
  -- return count
end

M.filter = function(arr, fn)
  if type(arr) ~= "table" then
    return arr
  end

  --  处理useCallback
  if #arr == 2 then
    local first_line = arr[1].lnum
    if first_line == arr[2].lnum then
      if (string.match(arr[1].text, 'useCallback') and string.match(arr[2].text, 'useCallback')) then
        return { arr[1] }
      end
    end
  end

  local filtered = {}
  for k, v in pairs(arr) do
    if fn(v, k, arr) then
      table.insert(filtered, v)
    end
  end

  return filtered
end

M.filterReactDTS = function(value)
  if string.match(value.user_data.targetUri, '/index.d.ts') == nil and string.match(value.user_data.targetUri, 'react') == nil then
    return true
  end
  return false
end
return M

