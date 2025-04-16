local TodoRepo = {}
TodoRepo.__index = TodoRepo
TodoRepo._STORE_DIR = vim.fn.stdpath("data") .. "/todo-nvim/"
TodoRepo._STORE_NAME = "todo-nvim-store.json"

function TodoRepo:new(storeDir, storeName)
    local obj = setmetatable({}, self)
    obj.storeDir = storeDir or TodoRepo._STORE_DIR
    obj.storeName = storeName or TodoRepo._STORE_NAME
    obj.storePath = obj.storeDir .. obj.storeName
    return obj
end

function TodoRepo:createStoreIfItDoesNotExist()
    local file = io.open(self.storePath, "r")
    if not file then
        vim.fn.mkdir(self.storeDir, "p")
        local content = "{}\n"
        local newFile = io.open(self.storePath, "w")
        if not newFile then
            return false, "Could not open file for writing"
        end

        newFile:write(content)
        newFile:close()
    end

    return true
end

return TodoRepo
