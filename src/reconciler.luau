local Node = require("./node")
local Renderer = require("./renderer")
local Scheduler = require("./scheduler")
local Types = require("./types")

local function createFiber(node: Types.Node, parent: Instance): Types.Fiber
	return {
		node = node,
		parent = parent,
		children = {},
		hooks = {},
		hookIndex = 0,
		isAlive = false,
		isUpdateScheduled = false,
	}
end

local Reconciler = {}

Reconciler.currentFiber = nil :: Types.Fiber?

function Reconciler.mount(node: Types.Node, parent: Instance): Types.Fiber
	local fiber = createFiber(node, parent)
	fiber.isAlive = true

	if node.className == Node.COMPONENT_CNAME then
		Reconciler.currentFiber = fiber
		local vnode: Types.Node = node.props.component(node.props.props)
		Reconciler.currentFiber = nil

		-- the component, rendered by the node should always be at index 1, see `reconcile` method for the reason
		table.insert(fiber.children, Reconciler.mount(vnode, parent))

		return fiber
	elseif node.className == Node.FRAGMENT_CNAME then
		for _, childNode in ipairs(node.children) do
			table.insert(fiber.children, Reconciler.mount(childNode, parent))
		end

		return fiber
	end

	local instance = Renderer.render(node, parent)
	fiber.instance = instance

	for _, childNode in ipairs(node.children) do
		table.insert(fiber.children, Reconciler.mount(childNode, instance))
	end

	return fiber
end

local function unmount(fiber: Types.Fiber)
	fiber.isAlive = false

	for _, hook in ipairs(fiber.hooks) do
		-- call `useEffect` hook cleanups
		if typeof(hook) == "table" and typeof(hook.cleanup) == "function" then
			hook.cleanup()
		end
	end

	for _, childFiber in ipairs(fiber.children) do
		unmount(childFiber)
	end

	Renderer.destroy(fiber)
end

local reconcile: (fiber: Types.Fiber, newNode: Types.Node) -> Types.Fiber

local function reconcileChildren(fiber: Types.Fiber, newNode: Types.Node, parent: Instance)
	local len = math.max(#fiber.children, #newNode.children)
	local newChildren: Types.Array<Types.Fiber> = {}

	for i = 1, len do
		local oldChildFiber = fiber.children[i]
		local newChildNode = newNode.children[i]

		if oldChildFiber and newChildNode then
			newChildren[i] = reconcile(oldChildFiber, newChildNode)
		elseif newChildNode then
			newChildren[i] = Reconciler.mount(newChildNode, parent)
		elseif oldChildFiber then
			unmount(oldChildFiber)
		end
	end

	fiber.children = newChildren
end

reconcile = function(fiber: Types.Fiber, newNode: Types.Node): Types.Fiber
	if fiber.node.className ~= newNode.className then
		unmount(fiber)
		Reconciler.mount(newNode, fiber.parent)
		fiber.node = newNode
		return fiber
	end

	if newNode.className == Node.COMPONENT_CNAME then
		-- reset hook index because we are rendering the node from scratch
		fiber.hookIndex = 0

		Reconciler.currentFiber = fiber
		local vnode = newNode.props.component(newNode.props.props)
		Reconciler.currentFiber = nil

		fiber.node = newNode

		-- the node is guaranteed to be at index 1 of a 'component fiber', see `mount` function
		fiber.children[1] = reconcile(fiber.children[1], vnode)

		return fiber
	elseif newNode.className == Node.FRAGMENT_CNAME then
		reconcileChildren(fiber, newNode, fiber.parent)
		return fiber
	end

	if fiber.instance then
		Renderer.applyProps(fiber.instance, newNode.props)
	end

	-- TODO: `fiber.parent` fallback is incorrect logically, but that's a bug that i'll deal with later
	reconcileChildren(fiber, newNode, fiber.instance or fiber.parent)

	fiber.node = newNode

	return fiber
end

function Reconciler.scheduleUpdate(fiber: Types.Fiber)
	if not fiber.isAlive or fiber.isUpdateScheduled then
		return
	end

	fiber.isUpdateScheduled = true

	Scheduler.scheduleTask(function()
		if not fiber.isAlive then
			return
		end

		fiber.isUpdateScheduled = false

		-- this might seem weird at first glance, why would we reconcile the fiber with it's own existing node?
		-- but the reason is simple, a component has a special node which contains the function that renders the actual node
		-- so the `reconcile` function is going to call the function stored in the properties to re-render the actual 'new node'
		-- hope this makes sense, i'm writing this at 2am and I got college in the morning
		reconcile(fiber, fiber.node)
	end)
end

return Reconciler
