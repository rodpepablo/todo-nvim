local M = {}

function M.createStoreChecker(storeDir, storeName)
	local storePath = storeDir .. storeName
	local checker = {}

	checker.storeExists = function()
		local stat = vim.loop.fs_stat(storePath)
		return stat and stat.type == "file"
	end

	checker.storeContent = function()
		local file = io.open(storePath, "r")
		if not file then
			return nil
		end

		local content = file:read("*a")
		file:close()

		return content
	end

	checker.deleteStore = function()
		if checker.storeExists() then
			os.remove(storePath)
		end
	end

	checker.deleteFolder = function()
		vim.fn.delete(storeDir, "rf")
	end

	return checker
end

return M
