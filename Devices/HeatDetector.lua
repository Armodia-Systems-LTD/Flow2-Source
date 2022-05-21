local alarmstate = false
local candetect = true
local canpoll = false
local minidisc = script.Parent:FindFirstChild("MiniDisc")
local function LED(state)
	if state == 1 then -- Blink Green
		if canpoll then
			if minidisc then
				spawn(function()
					minidisc.LED.BrickColor = BrickColor.new("Really red")
					minidisc.LED.Material = Enum.Material.Neon
					minidisc.LED.Starburst.Enabled = true
					wait()
					minidisc.LED.BrickColor = BrickColor.new("Dark stone grey")
					minidisc.LED.Material = Enum.Material.Glass
					minidisc.LED.Starburst.Enabled = false
				end)
			end
			script.Parent.LED.BrickColor = BrickColor.new("Lime green")
			script.Parent.LED.Material = Enum.Material.Neon
			wait()
			script.Parent.LED.BrickColor = BrickColor.new("Dark stone grey")
			script.Parent.LED.Material = Enum.Material.Glass
			wait()
		end
	elseif state == 2 then -- Blink Red
		if not alarmstate then
			if minidisc then
				spawn(function()
					minidisc.LED.BrickColor = BrickColor.new("Really red")
					minidisc.LED.Material = Enum.Material.Neon
					minidisc.LED.Starburst.Enabled = true
					wait()
					minidisc.LED.BrickColor = BrickColor.new("Dark stone grey")
					minidisc.LED.Material = Enum.Material.Glass
					minidisc.LED.Starburst.Enabled = false
				end)
			end
			script.Parent.LED.BrickColor = BrickColor.new("Really red")
			script.Parent.LED.Material = Enum.Material.Neon
			wait()
			script.Parent.LED.BrickColor = BrickColor.new("Dark stone grey")
			script.Parent.LED.Material = Enum.Material.Glass
			wait()
		end
	elseif state == 3 then -- Solid Red
		script.Parent.LED.BrickColor = BrickColor.new("Really red")
		script.Parent.LED.Material = Enum.Material.Neon
		if minidisc then
			minidisc.LED.BrickColor = BrickColor.new("Really red")
			minidisc.LED.Material = Enum.Material.Neon
			minidisc.LED.Starburst.Enabled = true
		end
	elseif state == 4 then -- Off
		script.Parent.LED.BrickColor = BrickColor.new("Dark stone grey")
		script.Parent.LED.Material = Enum.Material.Glass
		if minidisc then
			minidisc.LED.BrickColor = BrickColor.new("Dark stone grey")
			minidisc.LED.Material = Enum.Material.Glass
			minidisc.LED.Starburst.Enabled = false
		end
	end
end
script.Parent.Parent.Event.Event:Connect(function(datain)
	if datain.AllCommand == "Reset" then
		alarmstate = false
		LED(4)
		candetect = true
		canpoll = false
	end
end)
if script.Parent.Parent.Event.IsInTest.Value == true then
	workspace.DescendantAdded:Connect(function(newdesc)
		if newdesc:IsA("Fire") then
			local parent = newdesc:FindFirstAncestorWhichIsA("BasePart")
			if parent then
				if (script.Parent.Chamber.Position - parent.Position).Magnitude < 80 and candetect then
					candetect = false
					canpoll = false
					for i = 1,3,1 do
						LED(2)
					end
					for i = 1,math.ceil(((script.Parent.Chamber.Position - parent.Position).Magnitude)/5),1 do
						LED(2)
						wait(5)
					end
					if newdesc then
						for i = 1,3,1 do
							LED(2)
						end
						script.Parent.Parent.Event:Fire({AllCommand = "TestFuncEvac"})
						alarmstate = true
						LED(3)
					end
				end
			end
		end
	end)
elseif script.Parent.Parent.Event.IsInTest.Value == false then
	workspace.DescendantAdded:Connect(function(newdesc)
		if newdesc:IsA("Fire") then
			local parent = newdesc:FindFirstAncestorWhichIsA("BasePart")
			if parent then
				if (script.Parent.Chamber.Position - parent.Position).Magnitude < 80 and candetect then
					candetect = false
					canpoll = false
					for i = 1,3,1 do
						LED(2)
					end
					for i = 1,math.ceil(((script.Parent.Chamber.Position - parent.Position).Magnitude)/5),1 do
						LED(2)
						wait(5)
					end
					if newdesc then
						for i = 1,3,1 do
							LED(2)
						end
						script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = script.Parent:GetAttribute("Device_Name") , AlarmType = script.Parent:GetAttribute("Alarm_Type")}})
						alarmstate = true
						LED(3)
					end
				end
			end
		end
	end)
end
