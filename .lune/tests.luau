local fs = require("@lune/fs")
local process = require("@lune/process")
local test = require("../tests/test")
local useRequire = require("./use_require")

local TESTS_DIR = "tests"
local SPEC_PATTERN = "%.spec%.luau$"

local function findTestFiles(dir: string): { string }
	local files = {}

	if not fs.isDir(dir) then
		return files
	end

	for _, entry in ipairs(fs.readDir(dir)) do
		local path = dir .. "/" .. entry
		if fs.isDir(path) then
			local subFiles = findTestFiles(path)
			for _, file in subFiles do
				table.insert(files, file)
			end
		elseif string.match(entry, SPEC_PATTERN) then
			table.insert(files, path)
		end
	end

	return files
end

local function runTests()
	local testFiles = findTestFiles(TESTS_DIR)
	table.sort(testFiles)

	if #testFiles == 0 then
		print("No test files found")
		process.exit(0)
	end

	print(`Found {#testFiles} test file(s)\n`)

	for _, filePath in testFiles do
		print(`Loading {filePath}...`)
		local requirePath = "../" .. filePath:gsub("%.luau$", "")
		useRequire(requirePath)
	end

	print()

	local tests = test.getTests()
	local passed = 0
	local failed = 0
	local errors: { { name: string, error: string } } = {}

	for _, testCase in ipairs(tests) do
		local success, err = pcall(function()
			testCase.fn()
		end)

		if success then
			print(`✓ {testCase.name}`)
			passed += 1
		else
			print(`✗ {testCase.name}`)
			failed += 1
			table.insert(errors, { name = testCase.name, error = err })
		end
	end

	print(`\n{passed} passed, {failed} failed`)

	if #errors > 0 then
		print("\nFailures:")
		for _, entry in ipairs(errors) do
			print(`\n{entry.name}:`)
			print(`  {entry.error}`)
		end
	end

	process.exit(if failed > 0 then 1 else 0)
end

runTests()
