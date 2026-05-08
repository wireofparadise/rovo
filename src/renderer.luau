local Node = require("./node")
local Types = require("./types")

local instanceConnections: Types.Map<Instance, Types.Map<string, RBXScriptConnection>> = {}

local function handleConnection(instance: any, event: string, handler: (...any) -> ())
	local connections = instanceConnections[instance]

	if not connections then
		instanceConnections[instance] = {
			[event] = instance[event]:Connect(handler)
		}
		return
	end

	local connection = connections[event]

	if connection then
		connection:Disconnect()
	end

	connections[event] = instance[event]:Connect(handler)
end

local function applyProps(instance: Instance, props: Types.Props)
	for key, value in pairs(props) do
		local instanceAny = instance :: any

		if Node.isReservedProp(key) then
			continue
		end

		local event = Node.getConnectionPropEvent(key)
		if event then
			handleConnection(instance, event, value)
			continue
		end

		if instanceAny[key] == value then
			continue
		end

		instanceAny[key] = value
	end
end

local function getRef(props: Types.Props): Types.Ref<unknown>?
	return props[Node.REF_PROP]
end

local function attachRef(ref: Types.Ref<unknown>, instance: Instance)
	ref.current = instance
end

local function detachRef(ref: Types.Ref<unknown>)
	ref.current = nil
end

local function render(node: Types.Node, parent: Instance): Instance
	local instance = Instance.new(node.className)
	applyProps(instance, node.props)
	instance.Parent = parent

	local ref = getRef(node.props)
	if ref then
		attachRef(ref, instance)
	end

	return instance
end

local function destroy(fiber: Types.Fiber)
	local ref = getRef(fiber.node.props)
	if ref then
		detachRef(ref)
	end

	if fiber.instance then
		fiber.instance:Destroy()
	end

	fiber.instance = nil
end

return {
	applyProps = applyProps,
	render = render,
	destroy = destroy,
}
