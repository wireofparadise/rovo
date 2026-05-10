local Types = require("./types")

local COMPONENT_CNAME = "__rovo_component"
local FRAGMENT_CNAME = "__rovo_fragment"
local CONNECTION_PROP_PREFIX = "__rovo_connection_"

local function createNode(className: string, props: Types.Props?): Types.Node
	return {
		className = className,
		props = props or {},
	}
end

local function createComponentNode<T>(component: Types.Component, props: Types.Props?): Types.Node
	return {
		className = COMPONENT_CNAME,
		props = { component = component, props = props },
	}
end

local function createFragmentNode(children: Types.Array<Types.Node>): Types.Node
	return {
		className = FRAGMENT_CNAME,
		props = { Children = children },
	}
end

local function isReservedProp(propName: string): boolean
	return propName == "Children" or propName == "Ref"
end

local function isNode(value: any): boolean
	if typeof(value) ~= "table" then
		return false
	end

	local hasClassName = false
	local hasProps = false
	local hasChildren = false

	for key, val in pairs(value) do
		if typeof(key) ~= "string" then
			return false
		end

		if key == "className" then
			if typeof(val) ~= "string" then
				return false
			end
			hasClassName = true
		elseif key == "props" then
			if typeof(val) ~= "table" then
				return false
			end
			hasProps = true
		elseif key == "children" then
			if typeof(val) ~= "table" then
				return false
			end
			hasChildren = true
		else
			return false
		end
	end

	return hasClassName and hasProps and hasChildren
end

local function isNodeArray(value: any): boolean
	if typeof(value) ~= "table" then
		return false
	end

	for i, key in ipairs(value) do
		if typeof(i) ~= "number" then
			return false
		end

		if not isNode(key) then
			return false
		end
	end

	return true
end

local function getConnectionPropEvent(propName: string): string?
	if propName:sub(1, #CONNECTION_PROP_PREFIX) == CONNECTION_PROP_PREFIX then
		return propName:sub(#CONNECTION_PROP_PREFIX + 1)
	end

	return nil
end

local function createConnectionProp(event: string): string
	return CONNECTION_PROP_PREFIX .. event
end

return {
	COMPONENT_CNAME = COMPONENT_CNAME,
	FRAGMENT_CNAME = FRAGMENT_CNAME,
	CONNECTION_PROP_PREFIX = CONNECTION_PROP_PREFIX,

	createNode = createNode,
	createComponentNode = createComponentNode,
	createFragmentNode = createFragmentNode,
	isReservedProp = isReservedProp,
	isNode = isNode,
	isNodeArray = isNodeArray,
	getConnectionPropEvent = getConnectionPropEvent,
	createConnectionProp = createConnectionProp,
}
