local alarmstate = false
local canpoll = true
local Settings = require(script.Parent.Parent.Settings)
local PlayerData = game:GetService("Players")
local function LED(state)
	if state == 1 then -- Blink Green
		if canpoll then
			script.Parent.LED.BrickColor = BrickColor.new("Lime green")
			script.Parent.LED.Material = Enum.Material.Neon
			wait()
			script.Parent.LED.BrickColor = BrickColor.new("Dark stone grey")
			script.Parent.LED.Material = Enum.Material.Glass
			wait()
		end
	elseif state == 2 then -- Solid Red
		script.Parent.LED.BrickColor = BrickColor.new("Really red")
		script.Parent.LED.Material = Enum.Material.Neon
	elseif state == 3 then -- Off
		script.Parent.LED.BrickColor = BrickColor.new("Dark stone grey")
		script.Parent.LED.Material = Enum.Material.Glass
	end
end
local function ElementFunc()
	if script.Parent.Parent.Event.IsInTest.Value == true then
		if script.Parent:GetAttribute("Alarm_Type") == "Alert" then
			script.Parent.Parent.Event:Fire({AllCommand = "TestFuncAlert"})
			alarmstate = true
			script.Parent.Graphic.click:Play()
			script.Parent.Flag.Transparency = 0
			wait(0.2)
			for i = 1,5,1 do
				LED(1)
			end
			canpoll = false
			LED(2)
		elseif script.Parent:GetAttribute("Alarm_Type") == "Evac" then
			script.Parent.Parent.Event:Fire({AllCommand = "TestFuncEvac"})
			alarmstate = true
			script.Parent.Graphic.click:Play()
			script.Parent.Flag.Transparency = 0
			wait(0.2)
			for i = 1,5,1 do
				LED(1)
			end
			canpoll = false
			LED(2)
		end
	elseif script.Parent.Parent.Event.IsInTest.Value == false then
		alarmstate = true
		script.Parent.Graphic.click:Play()
		script.Parent.Flag.Transparency = 0
		wait(0.2)
		for i = 1,5,1 do
			LED(1)
		end
		canpoll = false
		LED(2)
		script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = script.Parent:GetAttribute("Device_Name") , AlarmType = script.Parent:GetAttribute("Alarm_Type")}})
	end
end
script.Parent.Element.ClickDetector.MouseClick:Connect(function(plr)
	if Settings.Whitelist.Enabled == true and not alarmstate then
		if Settings.Whitelist.WhitelistType == "PlayerID" then
			local PlayerID = ""
			PlayerID = PlayerData:GetUserIdFromNameAsync(plr.Name)
			if table.find(Settings.Whitelist.Whitelist, PlayerID) then
				spawn(ElementFunc)
			end
		elseif Settings.Whitelist.WhitelistType == "Group" then
			local rank = plr:GetRankInGroup(Settings.Whitelist.GroupID)
			for i,v in pairs(Settings.Whitelist.Whitelist) do
				if rank == v then
					spawn(ElementFunc)
				end
			end
		elseif Settings.Whitelist.WhitelistType == "UserName" then
			if table.find(Settings.Whitelist.Whitelist, plr.Name) then
				spawn(ElementFunc)
			end
		end
	else
		spawn(ElementFunc)
	end
end)
script.Parent.Parent.Event.Event:Connect(function(datain)
	if datain.AllCommand == "Reset" then
		alarmstate = false
		canpoll = true
		script.Parent.Flag.Transparency = 1
		LED(3)
	end
end)
while wait(5) do
	LED(1)
end