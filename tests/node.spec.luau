local Node = require("../src/Node")
local Types = require("../src/types")
local test = require("./test")

test.describe("Node", function()
	test.describe("createNode", function()
		test.it("creates node with props", function()
			local node = Node.createNode("TextLabel", {
				Text = "Hello, world!",
			})

			test.assertEqual(node.className, "TextLabel")
			test.assertEqual(typeof(node.props), "table")
			test.assertEqual(node.props.Text, "Hello, world!")
			test.assertEqual(typeof(node.children), "table")
			test.assertEqual(#node.children, 0)
		end)

		test.it("creates node with children", function()
			local childNode = Node.createNode("Frame")

			local node = Node.createNode("TextLabel", {
				Text = "Hello, world!",
				[Node.CHILDREN_PROP] = {
					childNode,
				},
			})

			test.assertEqual(node.props[Node.CHILDREN_PROP], nil)
			test.assertEqual(typeof(node.children), "table")
			test.assertEqual(#node.children, 1)
			test.assertEqual(node.children[1], childNode)
		end)
	end)

	test.describe("createComponentNode", function()
		test.it("creates component node with props", function()
			local component = function(props: Types.Props?): Types.Node
				return Node.createNode("TextLabel", {
					Text = props and props.Text,
				})
			end

			local node = Node.createComponentNode(component, {
				Text = "Hello, world!",
			})

			test.assertEqual(node.className, Node.COMPONENT_CNAME)
			test.assertEqual(node.props.component, component)
			test.assertEqual(typeof(node.props.props), "table")
			test.assertEqual(node.props.props.Text, "Hello, world!")
		end)

		test.it("creates component node with children", function()
			local component = function(props: Types.Props?): Types.Node
				return Node.createNode("TextLabel", {
					Text = props and props.Text,
				})
			end

			local childNode = Node.createNode("Frame")

			local node = Node.createComponentNode(component, {
				Text = "Hello, world!",
				[Node.CHILDREN_PROP] = {
					childNode,
				},
			})

			test.assertEqual(node.props[Node.CHILDREN_PROP], nil)
			test.assertEqual(typeof(node.children), "table")
			test.assertEqual(#node.children, 1)
			test.assertEqual(node.children[1], childNode)
		end)
	end)

	test.describe("isReservedProp", function()
		test.it("returns true for CHILDREN_PROP", function()
			test.assertEqual(Node.isReservedProp(Node.CHILDREN_PROP), true)
		end)

		test.it("returns true for REF_PROP", function()
			test.assertEqual(Node.isReservedProp(Node.REF_PROP), true)
		end)

		test.it("returns false for non-reserved props", function()
			test.assertEqual(Node.isReservedProp("Text"), false)
			test.assertEqual(Node.isReservedProp("BackgroundColor3"), false)
			test.assertEqual(Node.isReservedProp("Size"), false)
			test.assertEqual(Node.isReservedProp(""), false)
		end)
	end)

	test.describe("getConnectionPropEvent", function()
		test.it("returns the event name for valid events", function()
			test.assertEqual(
				Node.getConnectionPropEvent(Node.CONNECTION_PROP_PREFIX .. "MouseButton1Down"),
				"MouseButton1Down"
			)

			test.assertEqual(Node.getConnectionPropEvent(Node.CONNECTION_PROP_PREFIX .. "test"), "test")
		end)

		test.it("returns nil for invalid events", function()
			test.assertEqual(Node.getConnectionPropEvent("MouseButton1Down"), nil)
			test.assertEqual(Node.getConnectionPropEvent("testevent"), nil)
			test.assertEqual(Node.getConnectionPropEvent("123"), nil)
		end)
	end)
end)
