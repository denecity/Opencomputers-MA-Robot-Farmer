local robot = require("robot")
local computer = require("computer")
local component = require("component")

--config for farm parameters (will later be done with a real config)
borderPosZ = 4
borderNegZ = -4
borderPosX = 6
borderNegX = -6	

--just setting some functions for easyer management

function robot.action()
	return robot.useDown()
end

function facing()
	return component.navigation.getFacing() end

function distanceZ()
	return component.navigation.findWaypoints(30)[1].position[3] end

function distanceX()
	return component.navigation.findWaypoints(30)[1].position[1] end

prevMove = nil

--start of main loop
while true do

	--this is where the robot checks its battery
	if computer.energy()/computer.maxEnergy() < 0.1 then
		robot.up()
		
		--is the robot is exactly above the charger, it will just lower itself
		if distanceZ() == 0 and distanceZ() == 0 then
				robot.down()
				robot.down()
		end

		--in the next 4 blocks the robot moves above the charger
		if distanceZ() > 0 then
			if facing() == 2 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing() == 5 then robot.turnRight() end
			if facing() == 4 then robot.turnLeft() end
			for i = 1, distanceZ() do robot.forward() end
		end

		if distanceZ() < 0 then
			if facing() == 3 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing() == 5 then robot.turnLeft() end
			if facing() == 4 then robot.turnRight() end
			for i = 1, distanceZ() *-1 do robot.forward() end
		end

		if distanceX() > 0 then
			if facing() == 4 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing() == 2 then robot.turnRight() end
			if facing() == 3 then robot.turnLeft() end
			for i = 1, distanceX() do robot.forward() end
		end

		if distanceX() < 0 then
			if facing() == 5 then
				robot.turnLeft()
				robot.turnLeft() end
			if facing() == 2 then robot.turnLeft() end
			if facing() == 3 then robot.turnRight() end
			for i = 1, distanceX() *-1 do robot.forward() end
		end

		--the robot moves onto the charger and waits till its recharged and then rises
		robot.down()
		robot.down()
		while computer.energy() ~= computer.maxEnergy() do
			os.sleep(0) end
		robot.up()

	end

    --just doing random number generation
    moveNum = math.random(1, 4)
    --1 = forward
    --2 = Backward (wont be used)
    --3 = Left
    --4 = Right

    --every move is valid until proven otherwise!
    isMoveValid = true

    --setting ther moves to the corresponding coordinate numbers
    moveTable = {{0, 2, 3, 4, 5}, 
    			 {0, 3, 2, 5, 4}, 
    			 {0, 4, 5, 3, 2}, 
    			 {0, 5, 4, 2, 3}}

    moveDirection = moveTable[moveNum][facing()]

    print(moveDirection, " X: ", distanceX(), " Z: ", distanceZ())

    --checking if the next move would lead the robot across the border
    if moveDirection == 2 and distanceZ() <= borderNegZ then
    	isMoveValid = false end

    if moveDirection == 3 and distanceZ() >= borderPosZ then
    	isMoveValid = false end

    if moveDirection == 4 and distanceX() <= borderNegX then
    	isMoveValid = false end

    if moveDirection == 5 and distanceX() >= borderPosX then
    	isMoveValid = false end

    --finally, the robot moves (or doesnt, this is honestly a mess...)
    if isMoveValid == true then
    	if moveNum == 1 then
    		robot.forward()
    		robot.action() end
    	if moveNum == 3 then
    		robot.turnLeft()
    		robot.forward()
    		robot.action() end
    	if moveNum == 4 then
    		robot.turnRight()
    		robot.forward()
    		robot.action() end
   	end
	
	os.sleep(0)

end