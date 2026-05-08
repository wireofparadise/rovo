local RunService = require("./run_service")

local game = {}

function game:GetService(service: string)
	if service == "RunService" then
		return RunService
	end

	error("Unknown service: " .. service)
end

return game
