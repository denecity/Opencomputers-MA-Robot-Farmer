local robot = require("robot")
local computer = require("computer")
local component = require("component")
	

while true do

    --just doing random movement

	move = math.random(4)
	if move ~= prevMove then
		if move == 1 then -- forward
			prevMove = 4
			robot.forward()
			robot.useDown() end
		if move == 2 then -- left
			prevMove = 3
			robot.turnLeft()
			robot.forward()
			robot.useDown() end
		if move == 3 then -- right
			prevMove = 2
			robot.turnRight()
			robot.forward()
			robot.useDown() end
		if move == 4 then -- back
			prevMove = 1
			robot.turnLeft()
			robot.turnLeft()
			robot.forward()
			robot.useDown() end
	end
	--this is where the robot checks its battery

	if computer.energy()/computer.maxEnergy() < 0.1 then
		robot.up()
		distanceZ = component.navigation.findWaypoints(12)[1].position[3]
		distanceX = component.navigation.findWaypoints(12)[1].position[1]
		
		--is the robot is exactly above the charger, it will just lower itself

		if distanceZ == 0 and distanceZ == 0 then
				robot.down()
				robot.down()
		end

		--in the next 4 blocks the robot moves above the charger

		facing = component.navigation.getFacing()
		if distanceZ > 0 then
			if facing == 2 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing == 5 then robot.turnRight() end
			if facing == 4 then robot.turnLeft() end
			for i = 1, distanceZ do robot.forward() end
		end

		if distanceZ < 0 then
			if facing == 3 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing == 5 then robot.turnLeft() end
			if facing == 4 then robot.turnRight() end
			for i = 1, distanceZ *-1 do robot.forward() end
		end

		facing = component.navigation.getFacing()
		if distanceX > 0 then
			if facing == 4 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing == 2 then robot.turnRight() end
			if facing == 3 then robot.turnLeft() end
			for i = 1, distanceX do robot.forward() end
		end

		if distanceX < 0 then
			if facing == 5 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing == 2 then robot.turnLeft() end
			if facing == 3 then robot.turnRight() end
			for i = 1, distanceX *-1 do robot.forward() end
		end

		--the robot moves onto the charger and waits till its recharged

		robot.down()
		robot.down()

		while computer.energy() ~= computer.maxEnergy() do
			os.sleep(0)
		end

		--robot rises from charger after being fully recharged

		robot.up()

	end

	os.sleep(0)

end
