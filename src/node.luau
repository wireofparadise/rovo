local Types = require("./types")

local COMPONENT_CNAME = "__rovo_component"
local FRAGMENT_CNAME = "__rovo_fragment"
local CHILDREN_PROP = "__rovo_children"
local REF_PROP = "__rovo_ref"
local CONNECTION_PROP_PREFIX = "__rovo_connection_"

local function createNode(className: string, props: Types.Props?): Types.Node
	local implicitProps = props or {}
	local children = implicitProps[CHILDREN_PROP] or {}
	implicitProps[CHILDREN_PROP] = nil

	return {
		className = className,
		props = implicitProps,
		children = children,
	}
end

local function createComponentNode(component: Types.Component, props: Types.Props?): Types.Node
	local implicitProps = props or {}
	local children = implicitProps[CHILDREN_PROP] or {}
	implicitProps[CHILDREN_PROP] = nil

	return {
		className = COMPONENT_CNAME,
		props = { component = component, props = implicitProps },
		children = children,
	}
end

local function createFragmentNode(children: Types.Array<Types.Node>): Types.Node
	return {
		className = COMPONENT_CNAME,
		props = {},
		children = children,
	}
end

local function isReservedProp(propName: string): boolean
	return propName == CHILDREN_PROP or propName == REF_PROP
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
	CHILDREN_PROP = CHILDREN_PROP,
	REF_PROP = REF_PROP,
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
