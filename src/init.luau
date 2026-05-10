local Hooks = require("@self/hooks")
local Node = require("@self/node")
local Reconciler = require("@self/reconciler")
local Types = require("@self/types")

export type Node = Types.Node
export type Props = Types.Props
export type Ref<T> = Types.Ref<T>

local function create<T>(className: string | Types.Component, props: Types.Props?): Types.Node
	if typeof(className) == "function" then
		return Node.createComponentNode(className, props)
	else
		return Node.createNode(className, props)
	end
end

local function mount(node: Types.Node, parent: Instance)
	Reconciler.mount(node, parent)
end

local function on(event: string): string
	return Node.createConnectionProp(event)
end

return {
	create = create,
	fragment = Node.createFragmentNode,
	on = on,
	mount = mount,

	state = Hooks.state,
	ref = Hooks.ref,
	effect = Hooks.effect,
}
