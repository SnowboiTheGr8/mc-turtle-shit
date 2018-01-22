local t = turtle

local function dprint(...)
	print(...)
end

function t.digLine(length)
	--dprint("Dig: "..length)
	for i = 1, length do
		while t.detect() do
			t.dig()
		end
		while not t.forward() do
			t.attack()
		end
	end
end

function t.digBox(x, z, y, side, direction)-- side: true = left / direction: true = up
	term.clear()
	dprint("Depth: "..y)
	dprint("Rows: "..z)
	dprint("Length: "..x)
	dprint("\nTotal Blocks: "..(x*z)*y)

	local turnDir = side
	t.turn = function()
		if turnDir then
			t.turnRight()
			t.digLine(1)
			t.turnRight()
		else 
			t.turnLeft()
			t.digLine(1)
			t.turnLeft()
		end 
		turnDir = not turnDir
	end

	for i = 1, y do
		for i2 = 1, z do
			t.digLine(x-1)
			if i2 < z then
				t.turn()
			end
		end

		if i < y then
			if direction then
				while t.detectUp() do
					t.digUp()
				end
				while not t.up() do
					t.attackUp()
				end
			else
				if t.detectDown() then
					t.digDown()
				end
				while not t.down() do
					t.attackDown()
				end
			end
		end
		
		t.turnLeft()
		t.turnLeft()
	end
end

--t.digBox(2, 2, 5, true, true)
local room = {}
local function setup(stage)
	if stage <= 1 then
		if stage == 0 then
			term.clear()
		end

		print("The turtle is on block 1")
		print("\nHow many blocks forward do you want the room?")
		room.forward = tonumber(io.read())

		if not room.forward then print("\n  ERR: Invalid Number!\n") setup(1) return end
		stage = 2
	end

	if stage == 2 then
		print("\nHow many blocks to the side do you want the room?")
		room.side = tonumber(io.read())

		if not room.side then print("\n  ERR: Invalid Number!\n") setup(2) return end
		stage = 3
	end

	if stage == 3 then
		print("\nHow many layers do you want me to dig up/down?")
		room.depth = tonumber(io.read())

		if not room.depth then print("\n  ERR: Invalid Number!\n") setup(3) return end
		stage = 4
	end

	if stage == 4 then
		print("\nDo you want me to dig up or down? (u/D)")
		room.whichdir = io.read():lower()

		if room.whichdir == "d" or "" then
			room.whichdir = false
		elseif room.whichdir == "u" then
			room.whichdir = true
		else
			print("\n  ERR: Must be \"U\" or \"D\"!\n") setup(4) return
		end

		stage = 5
	end

	if stage == 5 then
		print("\nDo you want me to mine left or right? (l/R)")
		room.whichside = io.read():lower() or "r"

		if room.whichside == "l" then
			room.whichside = false
		elseif room.whichside == "r" or "" then
			room.whichside = true
		else
			print("\n  ERR: Must be \"L\" or \"R\"!\n") setup(5) return
		end
	end

	t.digBox(room.forward, room.side, room.depth, room.whichside, room.whichdir)
end
setup(0)