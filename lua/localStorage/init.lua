local M = {} -- M stands for module, a naming convention

local storePath = vim.fn.stdpath("data") .. "/localStorage.json";
local localStorage = {};

function saveData()
  local ok, f = pcall(io.open, storePath, 'w')
  if ok and f then
    f:write(vim.json.encode(localStorage))
    f:close()
  end
end


function loadData()
   local common = require('core.common')
   local ok, rawData = pcall(vim.fn.readfile, storePath)
   if ok and rawData and #rawData > 0 then 
     local storeData = table.concat(rawData, '\n')
     local data = vim.json.decode(storeData)
     localStorage = data;
   else
     saveData()
   end
   return localStorage
end

function getItem(key, defaultValue)
  return localStorage[key] or defaultValue or nil
end

function setItem(key, value)
  localStorage[key] = value;
  saveData()
end

function M.setup()
  loadData()
end

M.api = {
  setItem = setItem,
  getItem = getItem,
};

return M
