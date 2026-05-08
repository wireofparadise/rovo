local Reconciler = require("../reconciler")
local Types = require("../types")

local function areDepcendenciesEqual(prev: Types.Array<any>?, next: Types.Array<any>?): boolean
	-- no dependency array = always re-run
	if prev == nil or next == nil then
		return false
	end

	if #prev ~= #next then
		return false
	end

	for i = 1, #prev do
		if prev[i] ~= next[i] then
			return false
		end
	end

	return true
end

return function(effect: () -> (() -> ())?, dependencies: Types.Array<any>?)
	local fiber = Reconciler.currentFiber
	if not fiber then
		error("'Rovo.effect' cannot be called outside of a component render")
	end

	fiber.hookIndex += 1
	local index = fiber.hookIndex

	if fiber.hooks[index] == nil then
		fiber.hooks[index] = {
			cleanup = effect(),
			dependencies = dependencies,
		} :: Types.Effect
		return
	end

	local hook: Types.Effect = fiber.hooks[index]

	if areDepcendenciesEqual(hook.dependencies, dependencies) then
		hook.dependencies = dependencies
		return
	end

	if hook.cleanup then
		hook.cleanup()
	end

	hook.dependencies = dependencies

	hook.cleanup = effect()
end
