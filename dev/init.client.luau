local Players = game:GetService("Players")
local Rovo = require("@game/ReplicatedStorage/Packages/Rovo")

local function Counter(): Rovo.Node
	local count, setCount = Rovo.state(0)

	Rovo.useRef(0)

	Rovo.effect(function()
		print("Count has changed!")

		return function()
			print("Unmounting")
		end
	end, { count })

	return Rovo.create("Frame", {
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,

		[Rovo.children] = {
			Rovo.create("UIListLayout"),

			Rovo.create("TextButton", {
				Text = tostring(count),
				Size = UDim2.fromOffset(200, 50),

				[Rovo.on("MouseButton1Down")] = function()
					setCount(count + 1)
				end,
			}),
		},
	})
end

Rovo.mount(
	Rovo.create("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,

		[Rovo.children] = {
			Rovo.create(Counter),
		},
	}),

	Players.LocalPlayer.PlayerGui
)
