local RunService = game:GetService("RunService")
local Types = require("./types")

local taskQueue: Types.Array<Types.Task> = {}
local isScheduled = false
local FRAME_BUDGET = 5 / 1000 -- aka: (time in seconds allocated per frame) / 1000

local function shouldYield(deadline: number): boolean
	return os.clock() >= deadline
end

local performWork: () -> ()

local function requestWork()
	if isScheduled then
		return
	end

	isScheduled = true

	RunService.Heartbeat:Once(performWork)
end

local headIndex = 1
performWork = function()
	isScheduled = false

	local deadline = os.clock() + FRAME_BUDGET

	while taskQueue[headIndex] do
		if shouldYield(deadline) then
			requestWork()
			return
		end

		local task = taskQueue[headIndex]
		taskQueue[headIndex] = nil
		headIndex += 1
		task()
	end

	headIndex = 1
end

local function scheduleTask(task: Types.Task)
	table.insert(taskQueue, task)
	requestWork()
end

return {
	scheduleTask = scheduleTask,
}
