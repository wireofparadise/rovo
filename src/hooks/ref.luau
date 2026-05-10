local Reconciler = require("../reconciler")
local Types = require("../types")

return function<T>(initialValue: T): Types.Ref<T>
	local fiber = Reconciler.currentFiber
	if not fiber then
		error("'Rovo.ref' cannot be called outside of a component render")
	end

	fiber.hookIndex += 1
	local index = fiber.hookIndex

	if fiber.hooks[index] == nil then
		fiber.hooks[index] = { current = initialValue }
	end

	return fiber.hooks[index]
end
