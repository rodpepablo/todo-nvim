local TodoRepo = require("todo-nvim.todo_repo")
local StoreChecker = require("tests.test-util.store_checker")

local STORE_DIR = "./"
local STORE_NAME = "test-store.json"

local storeChecker = StoreChecker.createStoreChecker(STORE_DIR, STORE_NAME)

local assertSameContent = function(ok, checker)
	assert.are.same(true, ok)
	assert.are.same(true, checker.storeExists())
	assert.are.same("{}\n", checker.storeContent())
end

describe("TodoRepo", function()
	it("Create store if it does not exist", function()
		storeChecker.deleteStore()
		local repo = TodoRepo:new(STORE_DIR, STORE_NAME)

		local ok, err = repo:createStoreIfItDoesNotExist()

		assertSameContent(ok, storeChecker)
	end)

	it("Create store subfolder if it does not exist", function()
		local storeDir = "./test-dir/"
		local storeName = STORE_NAME
		local checker = StoreChecker.createStoreChecker(storeDir, storeName)

		local repo = TodoRepo:new(storeDir, storeName)

		local ok, err = repo:createStoreIfItDoesNotExist()

		assertSameContent(ok, storeChecker)
		checker.deleteStore()
		checker.deleteFolder()
	end)

	it("Default values for store path and name should be defined if not provided", function()
		local preservedDir = TodoRepo._STORE_DIR
		local preservedName = TodoRepo._STORE_NAME
		TodoRepo._STORE_DIR = "tempDir/"
		TodoRepo._STORE_NAME = "store-name.json"
		local repo = TodoRepo:new()

		local expectedStorePath = TodoRepo._STORE_DIR .. TodoRepo._STORE_NAME

		assert.are.same(TodoRepo._STORE_DIR, repo.storeDir)
		assert.are.same(TodoRepo._STORE_NAME, repo.storeName)
		assert.are.same(expectedStorePath, repo.storePath)

		TodoRepo._STORE_DIR = preservedDir
		TodoRepo._STORE_NAME = preservedName
	end)

	it("Default values for store path and name should be related to the std data path", function()
		local repo = TodoRepo:new()

		local expectedDir = vim.fn.stdpath("data") .. "/todo-nvim/"
		local expectedName = "todo-nvim-store.json"
		assert.are.same(expectedDir, TodoRepo._STORE_DIR)
		assert.are.same(expectedName, TodoRepo._STORE_NAME)
	end)
end)

storeChecker.deleteStore()
