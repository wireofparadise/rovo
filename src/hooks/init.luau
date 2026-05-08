local state = require("@self/state")
local effect = require("./hooks/effect")
local ref = require("@self/ref")

return {
	state = state,
	ref = ref,
	effect = effect,
}
