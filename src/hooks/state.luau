local Reconciler = require("../reconciler")

return function<T>(initialValue: T): (T, (newValue: T) -> ())
	local fiber = Reconciler.currentFiber
	if not fiber then
		error("'Rovo.state' cannot be called outside of a component render")
	end

	fiber.hookIndex += 1
	local index = fiber.hookIndex

	if fiber.hooks[index] == nil then
		fiber.hooks[index] = initialValue
	end

	local function setState(newValue: T)
		fiber.hooks[index] = newValue
		Reconciler.scheduleUpdate(fiber)
	end

	return fiber.hooks[index], setState
end
