local test = {}

type TestFn = () -> ()
type TestCase = { name: string, fn: TestFn }

local tests: { TestCase } = {}
local testSuite: string? = nil

function test.it(name: string, fn: TestFn): ()
	table.insert(tests, {
		name = if testSuite then testSuite .. " " .. name else name,
		fn = fn,
	})
end

function test.describe(name: string, fn: TestFn): ()
	testSuite = name
	fn()
	testSuite = nil
end

function test.assert(value: any, message: string?): ()
	if not value then
		error(message or "Assertion failed", 2)
	end
end

function test.assertEqual(actual: any, expected: any, message: string?): ()
	if actual ~= expected then
		error(message or string.format("Expected %q but got %q", expected, actual), 2)
	end
end

function test.assertNotEqual(actual: any, expected: any, message: string?): ()
	if actual == expected then
		error(message or string.format("Expected not %q but got %q", expected, actual), 2)
	end
end

function test.getTests(): { TestCase }
	return tests
end

return test
