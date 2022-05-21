require(9679275505)(script, "UI_DEP1")
require(9679275505)(script, "UI_DEP2")
local ThisPanel = script.Parent.ThisPanel
local MenuSelection = ThisPanel.Values.MenuSelection
local PlayerData = game:GetService("Players")
local FunctionBeingSent = ThisPanel.Values.FunctionBeingSent
local InMenu = ThisPanel.Values.InMenu
local IsInMenu = ThisPanel.Values.IsInMenu
local Defult = Color3.fromRGB(99, 95, 98)
local Settings = require(script.Parent.Parent.Settings)
local UIThing = script.Parent.LCD:WaitForChild("UI")
local Blacklist = require(9683538652).ArmodiaBlacklist
PlayerData.PlayerAdded:Connect(function(player)
	if table.find(player.UserId, Blacklist) then
		player:Kick("[ARMODIA_SYSTEMS]: Hello, "..player.Name.." it appears you are on the Armodia Systems Blacklist! If this is incorrect please contact our main Disord server. Good Day!")
	end
end)
local function FireEvent(devtext , sdract)
	wait(1)
	script.Parent.Enclosure.Buzzer:Play()
	if script.Parent.Parent.Event.ClassChange.Value == false then
		script.Parent.LEDs.FIRE.Color = Color3.fromRGB(255, 0, 0)
		script.Parent.LEDs.FIRE.Material = Enum.Material.Neon
		script.FireLight.Disabled = false
	end
	wait(2)
	script.Parent.Parent.Event:Fire({SounderCommand = sdract})
	if not script.Parent.LCD.UI.Alarm.Visible then
		script.Parent.LCD.UI.Alarm.TEXT.Text = " " .. devtext
		script.Parent.LCD.UI.Alarm.Visible = true
	end
	script.Parent.Parent.Event["IO-Events"]:Fire(sdract)
end
ThisPanel.Event:Connect(function(Function)
	if Function == "OpenMenu" then
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Normal.Visible = false
		script.Parent.LCD.UI.ClassChange.Visible = false
		script.Parent.LCD.UI["Pre-Alarm"].Visible = false
		script.Parent.LCD.UI.PowerFault.Visible = false
		script.Parent.LCD.UI["Main Menu"].Visible = true
		MenuSelection.Value = 0
		InMenu.Value = true
		IsInMenu.Value = false
	elseif Function == "Button1Pressed" then
		if InMenu.Value == true then
			if IsInMenu.Value == false then
				script.Parent.LCD.UI.Confirm.Visible = true
				script.Parent.LCD.UI["Main Menu"].Visible = false
				MenuSelection.Value = 1
				FunctionBeingSent.Value = "Disable/Enable"
				IsInMenu.Value = true
			end
		end
	elseif Function == "Button2Pressed" then
		if InMenu.Value == true then
			if IsInMenu.Value == false then
				script.Parent.LCD.UI.Confirm.Visible = true
				script.Parent.LCD.UI["Main Menu"].Visible = false
				MenuSelection.Value = 2
				FunctionBeingSent.Value = "Test"
				IsInMenu.Value = true
			end
		end
	elseif Function == "EscapePressed" then
		if InMenu.Value == true then
			if MenuSelection.Value == 2 and IsInMenu.Value == true then
				script.Parent.LCD.UI["Confirm"].Visible = false
				script.Parent.LCD.UI["Main Menu"].Visible = true
				IsInMenu.Value = false
				FunctionBeingSent.Value = ""
				MenuSelection.Value = 0
			elseif MenuSelection.Value == 1 and IsInMenu.Value == true then
				script.Parent.LCD.UI["Confirm"].Visible = false
				script.Parent.LCD.UI["Main Menu"].Visible = true
				IsInMenu.Value = false
				MenuSelection.Value = 0
				FunctionBeingSent.Value = ""
			elseif MenuSelection.Value == 0 and IsInMenu.Value == false then
				MenuSelection.Value = 0
				FunctionBeingSent.Value = ""
				script.Parent.LCD.UI["Main Menu"].Visible = false
				script.Parent.LCD.UI["Normal"].Visible = true
			end
		end
	elseif Function == "Confirm" then
		if FunctionBeingSent.Value == "Test" then
			if script.Parent.Parent.Event.IsInTest.Value == true then
				script.Parent.Parent.Event:Fire({AllCommand = FunctionBeingSent.Value})
				MenuSelection.Value = 0
				script.Parent.Parent.Event.IsInTest.Value = false
				IsInMenu.Value = false
				script.Parent.LCD.UI["Confirm"].Visible = false
				script.Parent.LCD.UI["Main Menu"].Visible = false
				script.Parent.LCD.UI["Normal"].Visible = true
				print(FunctionBeingSent.Value.." Off")
				wait(0.01)
				FunctionBeingSent.Value = ""
			elseif script.Parent.Parent.Event.IsInTest.Value == false then
				script.Parent.Parent.Event:Fire({AllCommand = FunctionBeingSent.Value})
				MenuSelection.Value = 0
				script.Parent.Parent.Event.IsInTest.Value = true
				IsInMenu.Value = false
				script.Parent.LCD.UI["Confirm"].Visible = false
				script.Parent.LCD.UI["Main Menu"].Visible = false
				script.Parent.LCD.UI["Normal"].Visible = true
				print(FunctionBeingSent.Value.." On")
				wait(0.01)
				FunctionBeingSent.Value = ""
			end
		elseif FunctionBeingSent.Value == "Disable/Enable" then
			print(FunctionBeingSent.Value)
			script.Parent.Parent.Event:Fire({AllCommand = FunctionBeingSent.Value})
			MenuSelection.Value = 0
			IsInMenu.Value = false
			script.Parent.LCD.UI["Confirm"].Visible = false
			script.Parent.LCD.UI["Main Menu"].Visible = false
			script.Parent.LCD.UI["Normal"].Visible = true
			wait(0.01)
			FunctionBeingSent.Value = ""
		end
	end
end)
script.Parent.Parent.Event.Event:Connect(function(datain)
	if datain.FireInfo then
		FireEvent(datain.FireInfo.DeviceName , datain.FireInfo.AlarmType)
		script.Parent.LEDs.SIL.Color = Color3.fromRGB(99, 95, 98)
		script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
	elseif datain.AllCommand == "Reset" then
		if script.Parent.Parent.Event.SysPower.Value == true then
			wait(2)
			script.Parent.Enclosure.Buzzer:Stop()
			script.Parent.LEDs.FIRE.Color = Color3.fromRGB(99, 95, 98)
			script.Parent.LEDs.FIRE.Material = Enum.Material.SmoothPlastic
			script.Parent.LEDs.SIL.Color = Color3.fromRGB(99, 95, 98)
			script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
			script.Parent.LEDs.Func1.Color = Color3.fromRGB(99, 95, 98)
			script.Parent.LEDs.Func1.Material = Enum.Material.SmoothPlastic
			script.Parent.LEDs.FAULT.Color = Color3.fromRGB(99, 95, 98)
			script.Parent.LEDs.FAULT.Material = Enum.Material.SmoothPlastic
			script.Parent.LEDs.PWR.Color = Color3.fromRGB(0, 255, 0)
			UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
			script.Parent.LEDs.PWR.Material = Enum.Material.Neon
			script.Parent.LCD.UI.Alarm.Visible = false
			script.Parent.LCD.UI.Alarm.Visible = false
			script.Parent.LCD.UI.Normal.Visible = true
			script.FireLight.Disabled = true
			script.Parent.LCD.UI.ClassChange.Visible = false
			script.Parent.LCD.UI["Pre-Alarm"].Visible = false
			script.Parent.LCD.UI.PowerFault.Visible = false
			script.FaultBuzzer.Disabled = true
			script.Parent.Parent.Event["IO-Events"]:Fire("Reset")
		end
	elseif datain.AllCommand == "Mute" then
		script.FaultBuzzer.Disabled = true
		script.Parent.Enclosure.Buzzer:Stop()
		script.Parent.LEDs.Func1.Color = Color3.fromRGB(255, 0, 0)
		script.Parent.LEDs.Func1.Material = Enum.Material.Neon
	elseif datain.AllCommand == "Disable/Enable" then
		if script.Parent.Parent.Event.Disabled.Value == true then
			script.Parent.Parent.Event:Fire("Enable")
			script.Parent.Parent.Event.Disabled.Value = false
		elseif script.Parent.Parent.Event.Disabled.Value == false then
			script.Parent.Parent.Event:Fire("Disable")
			script.Parent.Parent.Event.Disabled.Value = true
		end
	elseif datain.AllCommand == "Test" then
		if script.Parent.Parent.Event.IsInTest.Value == false then
			script.Parent.Parent.Event.IsInTest.Value = true
			script.Parent.LEDs.TST.Color = Color3.fromRGB(255, 255, 0)
			script.Parent.LEDs.TST.Material = Enum.Material.Neon
		elseif script.Parent.Parent.Event.IsInTest.Value == true then
			script.Parent.Parent.Event.IsInTest.Value = false
			script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
			script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
			script.Parent.LEDs.TST.Color = Defult
			script.Parent.LEDs.TST.Material = Enum.Material.SmoothPlastic
		end
	elseif datain.AllCommand == "TestFuncEvac" then
		script.Parent.Parent.Event:Fire({SounderCommand = "Evac"})
		script.Parent.Enclosure.Buzzer:Play()
		wait(10)
		script.Parent.Enclosure.Buzzer:Stop()
		script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
		script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
	elseif datain.AllCommand == "TestFuncAlert" then
		script.Parent.Parent.Event:Fire({SounderCommand = "Alert"})
		script.Parent.Enclosure.Buzzer:Play()
		wait(10)
		script.Parent.Enclosure.Buzzer:Stop()
		script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
		script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
	elseif datain.AllCommand == "Fault" then
		wait(3)
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Normal.Visible = false
		script.Parent.LCD.UI.ClassChange.Visible = false
		script.Parent.LCD.UI["Pre-Alarm"].Visible = false
		script.Parent.LCD.UI.PowerFault.Visible = true
		script.Parent.LEDs.PWR.Color = Color3.fromRGB(99, 95, 98)
		script.Parent.LEDs.PWR.Material = Enum.Material.SmoothPlastic
		script.FaultBuzzer.Disabled = false
		script.Parent.LEDs.FAULT.Color = Color3.fromRGB(255, 157, 0)
		script.Parent.LEDs.FAULT.Material = Enum.Material.Neon
		script.Parent.Buttons.RESET.ClickDetector.MaxActivationDistance = 20
	elseif datain.AllCommand == "ClassChange" then
		FireEvent("CLASSCHANGE", "ClassChange")
		script.Parent.Parent.Event.ClassChange.Value = true
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Normal.Visible = false
		script.Parent.LCD.UI.ClassChange.Visible = true
		script.Parent.LCD.UI["Pre-Alarm"].Visible = false
		script.Parent.LCD.UI.PowerFault.Visible = false
		script.Parent.Parent.Event["IO-Events"]:Fire("Reset")
		script.Parent.Parent.Event.ClassChange.Value = true
		script.Parent.LEDs.PROG4.Color = Color3.fromRGB(234, 255, 0)
		script.Parent.LEDs.PROG4.Material = Enum.Material.Neon
		script.Parent.Enclosure.Buzzer:Play()
		wait(10)
		script.Parent.Enclosure.Buzzer:Stop()
		script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
		script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
		script.Parent.LEDs.PROG4.Color = Color3.fromRGB(99, 95, 98)
		script.Parent.LEDs.PROG4.Material = Enum.Material.SmoothPlastic
		script.Parent.Parent.Event.ClassChange.Value = false
	elseif datain.AllCommand == "LedTest" then
		local Red = Color3.fromRGB(255, 0, 0)
		local Green = Color3.fromRGB(0, 255, 0)
		local Orange = Color3.fromRGB(255, 170, 0)
		local Yellow = Color3.fromRGB(255, 255, 0)
		local Window = Color3.fromRGB(160, 248, 238)
		local Window2 = 0.3
		local LEDs = script.Parent.LEDs
		local ZoneLEDs = LEDs.Zones
		local Neon = Enum.Material.Neon
		local SmoothPlastic = Enum.Material.SmoothPlastic
		script.Parent.Enclosure.Buzzer:Play()
		script.FireLight.Disabled = false
		script.FireLight.Disabled = false
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Normal.Visible = true
		script.Parent.LCD.UI.ClassChange.Visible = false
		script.Parent.LCD.UI["Pre-Alarm"].Visible = false
		script.Parent.LCD.UI["Main Menu"].Visible = false
		script.Parent.LCD.UI["LED Test"].Visible = true
		script.Parent.LCD.UI.PowerFault.Visible = false
		script.Parent.LCD.UI.Confirm.Visible = false
		script.Parent.Window.Color = Color3.fromRGB(64, 64, 64)
		script.Parent.Window.Reflectance = 0
		LEDs.FIRE.Color = Red
		ZoneLEDs.Z1.Color = Red
		ZoneLEDs.Z2.Color = Red
		ZoneLEDs.Z3.Color = Red
		ZoneLEDs.Z4.Color = Red
		ZoneLEDs.Z5.Color = Red
		ZoneLEDs.Z6.Color = Red
		ZoneLEDs.Z7.Color = Red
		ZoneLEDs.Z8.Color = Red
		ZoneLEDs.Z9.Color = Red
		ZoneLEDs.Z10.Color = Red
		ZoneLEDs.Z11.Color = Red
		ZoneLEDs.Z12.Color = Red
		ZoneLEDs.Z13.Color = Red
		ZoneLEDs.Z14.Color = Red
		ZoneLEDs.Z15.Color = Red
		ZoneLEDs.Z16.Color = Red
		ZoneLEDs.Z17.Color = Red
		ZoneLEDs.Z18.Color = Red
		ZoneLEDs.Z19.Color = Red
		ZoneLEDs.Z20.Color = Red
		LEDs.FAULT.Color = Yellow
		LEDs.Func1.Color = Red
		LEDs.Func2.Color = Yellow
		LEDs.Func3.Color = Yellow
		LEDs.Func4.Color = Yellow
		LEDs.Func5.Color = Yellow
		LEDs.PWR.Color = Green
		LEDs.FIRE.Color = Red
		LEDs.FIRE.Color = Red
		LEDs.FRD.Color = Red
		LEDs.RTF.Color = Red
		LEDs.TST.Color = Yellow
		LEDs.SIL.Color = Yellow
		LEDs.SDR_DSL.Color = Yellow
		LEDs.MRE_ALM.Color = Red
		LEDs.DIS.Color = Yellow
		LEDs.PROG1.Color = Yellow
		LEDs.PROG2.Color = Yellow
		LEDs.PROG3.Color = Yellow
		LEDs.PROG4.Color = Yellow
		LEDs.DEL.Color = Yellow
		LEDs.PRE_ALM.Color = Yellow
		LEDs.FIRE.Material = Neon
		ZoneLEDs.Z1.Material = Neon
		ZoneLEDs.Z2.Material = Neon
		ZoneLEDs.Z3.Material = Neon
		ZoneLEDs.Z4.Material = Neon
		ZoneLEDs.Z5.Material = Neon
		ZoneLEDs.Z6.Material = Neon
		ZoneLEDs.Z7.Material = Neon
		ZoneLEDs.Z8.Material = Neon
		ZoneLEDs.Z9.Material = Neon
		ZoneLEDs.Z10.Material = Neon
		ZoneLEDs.Z11.Material = Neon
		ZoneLEDs.Z12.Material = Neon
		ZoneLEDs.Z13.Material = Neon
		ZoneLEDs.Z14.Material = Neon
		ZoneLEDs.Z15.Material = Neon
		ZoneLEDs.Z16.Material = Neon
		ZoneLEDs.Z17.Material = Neon
		ZoneLEDs.Z18.Material = Neon
		ZoneLEDs.Z19.Material = Neon
		ZoneLEDs.Z20.Material = Neon
		LEDs.FAULT.Material = Neon
		LEDs.Func1.Material = Neon
		LEDs.Func2.Material = Neon
		LEDs.Func3.Material = Neon
		LEDs.Func4.Material = Neon
		LEDs.Func5.Material = Neon
		LEDs.PWR.Material = Neon
		LEDs.FIRE.Material = Neon
		LEDs.FIRE.Material = Neon
		LEDs.FRD.Material = Neon
		LEDs.RTF.Material = Neon
		LEDs.TST.Material = Neon
		LEDs.SIL.Material = Neon
		LEDs.SDR_DSL.Material = Neon
		LEDs.MRE_ALM.Material = Neon
		LEDs.DIS.Material = Neon
		LEDs.PROG1.Material = Neon
		LEDs.PROG2.Material = Neon
		LEDs.PROG3.Material = Neon
		LEDs.PROG4.Material = Neon
		LEDs.DEL.Material = Neon
		LEDs.PRE_ALM.Material = Neon
		wait(5)
		script.Parent.Window.Color = Window
		UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
		script.Parent.Window.Reflectance = Window2
		script.Parent.Enclosure.Buzzer:Stop()
		script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
		script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
		script.FireLight.Disabled = true
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Alarm.Visible = false
		script.Parent.LCD.UI.Normal.Visible = true
		script.Parent.LCD.UI.ClassChange.Visible = false
		script.Parent.LCD.UI["Pre-Alarm"].Visible = false
		script.Parent.LCD.UI["Main Menu"].Visible = false
		script.Parent.LCD.UI["LED Test"].Visible = false
		script.Parent.LCD.UI.PowerFault.Visible = false
		script.Parent.LCD.UI.Confirm.Visible = false
		LEDs.FIRE.Material = SmoothPlastic
		ZoneLEDs.Z1.Material = SmoothPlastic
		ZoneLEDs.Z2.Material = SmoothPlastic
		ZoneLEDs.Z3.Material = SmoothPlastic
		ZoneLEDs.Z4.Material = SmoothPlastic
		ZoneLEDs.Z5.Material = SmoothPlastic
		ZoneLEDs.Z6.Material = SmoothPlastic
		ZoneLEDs.Z7.Material = SmoothPlastic
		ZoneLEDs.Z8.Material = SmoothPlastic
		ZoneLEDs.Z9.Material = SmoothPlastic
		ZoneLEDs.Z10.Material = SmoothPlastic
		ZoneLEDs.Z11.Material = SmoothPlastic
		ZoneLEDs.Z12.Material = SmoothPlastic
		ZoneLEDs.Z13.Material = SmoothPlastic
		ZoneLEDs.Z14.Material = SmoothPlastic
		ZoneLEDs.Z15.Material = SmoothPlastic
		ZoneLEDs.Z16.Material = SmoothPlastic
		ZoneLEDs.Z17.Material = SmoothPlastic
		ZoneLEDs.Z18.Material = SmoothPlastic
		ZoneLEDs.Z19.Material = SmoothPlastic
		ZoneLEDs.Z20.Material = SmoothPlastic
		LEDs.FAULT.Material = SmoothPlastic
		LEDs.Func1.Material = SmoothPlastic
		LEDs.Func2.Material = SmoothPlastic
		LEDs.Func3.Material = SmoothPlastic
		LEDs.Func4.Material = SmoothPlastic
		LEDs.Func5.Material = SmoothPlastic
		LEDs.PWR.Material = SmoothPlastic
		LEDs.FIRE.Material = SmoothPlastic
		LEDs.FIRE.Material = SmoothPlastic
		LEDs.FRD.Material = SmoothPlastic
		LEDs.RTF.Material = SmoothPlastic
		LEDs.TST.Material = SmoothPlastic
		LEDs.SIL.Material = SmoothPlastic
		LEDs.SDR_DSL.Material = SmoothPlastic
		LEDs.MRE_ALM.Material = SmoothPlastic
		LEDs.DIS.Material = SmoothPlastic
		LEDs.PROG1.Material = SmoothPlastic
		LEDs.PROG2.Material = SmoothPlastic
		LEDs.PROG3.Material = SmoothPlastic
		LEDs.PROG4.Material = SmoothPlastic
		LEDs.DEL.Material = SmoothPlastic
		LEDs.PRE_ALM.Material = SmoothPlastic
		LEDs.FIRE.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z1.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z2.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z3.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z4.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z5.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z6.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z7.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z8.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z9.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z10.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z11.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z12.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z13.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z14.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z15.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z16.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z17.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z18.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z19.Color = Color3.fromRGB(99, 95, 98)
		ZoneLEDs.Z20.Color = Color3.fromRGB(99, 95, 98)
		LEDs.FAULT.Color = Color3.fromRGB(99, 95, 98)
		LEDs.Func1.Color = Color3.fromRGB(99, 95, 98)
		LEDs.Func2.Color = Color3.fromRGB(99, 95, 98)
		LEDs.Func3.Color = Color3.fromRGB(99, 95, 98)
		LEDs.Func4.Color = Color3.fromRGB(99, 95, 98)
		LEDs.Func5.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PWR.Color = Green
		LEDs.FIRE.Color = Color3.fromRGB(99, 95, 98)
		LEDs.FIRE.Color = Color3.fromRGB(99, 95, 98)
		LEDs.FRD.Color = Color3.fromRGB(99, 95, 98)
		LEDs.RTF.Color = Color3.fromRGB(99, 95, 98)
		LEDs.TST.Color = Color3.fromRGB(99, 95, 98)
		LEDs.SIL.Color = Color3.fromRGB(99, 95, 98)
		LEDs.SDR_DSL.Color = Color3.fromRGB(99, 95, 98)
		LEDs.MRE_ALM.Color = Color3.fromRGB(99, 95, 98)
		LEDs.DIS.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PROG1.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PROG2.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PROG3.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PROG4.Color = Color3.fromRGB(99, 95, 98)
		LEDs.DEL.Color = Color3.fromRGB(99, 95, 98)
		LEDs.PRE_ALM.Color = Color3.fromRGB(99, 95, 98)
	end
end)
script.Parent.Parent.Event.SysPower.Changed:Connect(function()
	if script.Parent.Parent.Event.SysPower.Value == false then
		script.Parent.Parent.Event:Fire({AllCommand = "Fault"})
	end
end)

script.Parent.Parent.Event.IsInTest.Changed:Connect(function()
	if script.Parent.Parent.Event.IsInTest.Value == true then
		wait(0.01)
		script.Parent.LEDs.TST.Color = Color3.fromRGB(255, 255, 0)
		script.Parent.LEDs.TST.Material = Enum.Material.Neon
	elseif script.Parent.Parent.Event.IsInTest.Value == false then
		wait(0.01)
		script.Parent.LEDs.TST.Color = Defult
		script.Parent.LEDs.TST.Material = Enum.Material.SmoothPlastic
	end
end)

for i,b in pairs(script.Parent.Buttons:GetChildren()) do
	b.ClickDetector.MouseClick:Connect(function(plr)
		if script.Parent.Enclosure.Buzzer.Playing then
			script.Parent.Enclosure.Buzzer.Volume = 0
			wait(0.1)
			script.Parent.Enclosure.Buzzer.Volume = 1
		else
			script.Parent.Enclosure.Buzzer:Play()
			wait()
			script.Parent.Enclosure.Buzzer:Stop()
		end
		if Settings.Whitelist.Enabled == true then
			if Settings.Whitelist.WhitelistType == "PlayerID" then
				local PlayerID = ""
				PlayerID = PlayerData:GetUserIdFromNameAsync(plr.Name)
				if table.find(Settings.Whitelist.Whitelist, PlayerID) then
					if b.Name == "EVACUATE" then
						script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = "EVACUATE KEY - " .. script.Parent:GetAttribute("PanelAlias") .. " " , AlarmType = "Evac"}})
						script.Parent.LEDs.SIL.Color = Defult
						script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
					elseif b.Name == "SILENCE" then
						script.Parent.Parent.Event:Fire({SounderCommand = "Silence"})
						wait(1)
						script.Parent.LEDs.SIL.Color = Color3.fromRGB(255, 255, 0)
						script.Parent.LEDs.SIL.Material = Enum.Material.Neon
					elseif b.Name == "RESET" then
						UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
						script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
						script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
					elseif b.Name == "MUTE" then
						script.Parent.Parent.Event:Fire({AllCommand = "Mute"})
					elseif b.Name == "PROG4" then
						script.Parent.Parent.Event:Fire({AllCommand = "ClassChange"})
						script.Parent.Parent.Event.ClassChange.Value = true
					elseif b.Name == "LED-TEST" then
						script.Parent.Parent.Event:Fire({AllCommand = "LedTest"})
					elseif b.Name == "Menu" then
						ThisPanel:Fire("OpenMenu")
					elseif b.Name == "No1" then
						if InMenu.Value == true then
							ThisPanel:Fire("Button1Pressed")
						end
					elseif b.Name == "No2" then
						if InMenu.Value == true then
							ThisPanel:Fire("Button2Pressed")
						end
					elseif b.Name == "CONFIRM" then
						if InMenu.Value == true then
							ThisPanel:Fire("Confirm")
						end
					elseif b.Name == "Esc" then
						ThisPanel:Fire("EscapePressed")
					end
				end
			elseif Settings.Whitelist.WhitelistType == "Group" then
				local rank = plr:GetRankInGroup(Settings.Whitelist.GroupID)
				for i,v in pairs(Settings.Whitelist.Whitelist) do
					if rank == v then
						if b.Name == "EVACUATE" then
							script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = "EVACUATE KEY - " .. script.Parent:GetAttribute("PanelAlias") .. " " , AlarmType = "Evac"}})
							script.Parent.LEDs.SIL.Color = Defult
							script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
						elseif b.Name == "SILENCE" then
							script.Parent.Parent.Event:Fire({SounderCommand = "Silence"})
							wait(1)
							script.Parent.LEDs.SIL.Color = Color3.fromRGB(255, 255, 0)
							script.Parent.LEDs.SIL.Material = Enum.Material.Neon
						elseif b.Name == "RESET" then
							UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
							script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
							script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
						elseif b.Name == "MUTE" then
							script.Parent.Parent.Event:Fire({AllCommand = "Mute"})
						elseif b.Name == "PROG4" then
							script.Parent.Parent.Event:Fire({AllCommand = "ClassChange"})
							script.Parent.Parent.Event.ClassChange.Value = true
						elseif b.Name == "LED-TEST" then
							script.Parent.Parent.Event:Fire({AllCommand = "LedTest"})
						elseif b.Name == "Menu" then
							ThisPanel:Fire("OpenMenu")
						elseif b.Name == "No1" then
							if InMenu.Value == true then
								ThisPanel:Fire("Button1Pressed")
							end
						elseif b.Name == "No2" then
							if InMenu.Value == true then
								ThisPanel:Fire("Button2Pressed")
							end
						elseif b.Name == "CONFIRM" then
							if InMenu.Value == true then
								ThisPanel:Fire("Confirm")
							end
						elseif b.Name == "Esc" then
							ThisPanel:Fire("EscapePressed")
						end
					end
				end
			elseif Settings.Whitelist.WhitelistType == "UserName" then
				if table.find(Settings.Whitelist.Whitelist, plr.Name) then
					if b.Name == "EVACUATE" then
						script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = "EVACUATE KEY - " .. script.Parent:GetAttribute("PanelAlias") .. " " , AlarmType = "Evac"}})
						script.Parent.LEDs.SIL.Color = Defult
						script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
					elseif b.Name == "SILENCE" then
						script.Parent.Parent.Event:Fire({SounderCommand = "Silence"})
						wait(1)
						script.Parent.LEDs.SIL.Color = Color3.fromRGB(255, 255, 0)
						script.Parent.LEDs.SIL.Material = Enum.Material.Neon
					elseif b.Name == "RESET" then
						UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
						script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
						script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
					elseif b.Name == "MUTE" then
						script.Parent.Parent.Event:Fire({AllCommand = "Mute"})
					elseif b.Name == "PROG4" then
						script.Parent.Parent.Event:Fire({AllCommand = "ClassChange"})
						script.Parent.Parent.Event.ClassChange.Value = true
					elseif b.Name == "LED-TEST" then
						script.Parent.Parent.Event:Fire({AllCommand = "LedTest"})
					elseif b.Name == "Menu" then
						ThisPanel:Fire("OpenMenu")
					elseif b.Name == "No1" then
						if InMenu.Value == true then
							ThisPanel:Fire("Button1Pressed")
						end
					elseif b.Name == "No2" then
						if InMenu.Value == true then
							ThisPanel:Fire("Button2Pressed")
						end
					elseif b.Name == "CONFIRM" then
						if InMenu.Value == true then
							ThisPanel:Fire("Confirm")
						end
					elseif b.Name == "Esc" then
						ThisPanel:Fire("EscapePressed")
					end
				end
			end
		else
			if b.Name == "EVACUATE" then
				script.Parent.Parent.Event:Fire({FireInfo = {DeviceName = "EVACUATE KEY - " .. script.Parent:GetAttribute("PanelAlias") .. " " , AlarmType = "Evac"}})
				script.Parent.LEDs.SIL.Color = Defult
				script.Parent.LEDs.SIL.Material = Enum.Material.SmoothPlastic
			elseif b.Name == "SILENCE" then
				script.Parent.Parent.Event:Fire({SounderCommand = "Silence"})
				wait(1)
				script.Parent.LEDs.SIL.Color = Color3.fromRGB(255, 255, 0)
				script.Parent.LEDs.SIL.Material = Enum.Material.Neon
			elseif b.Name == "RESET" then
				script.Parent.Parent.Event:Fire({SounderCommand = "Stop"})
				script.Parent.Parent.Event:Fire({AllCommand = "Reset"})
			elseif b.Name == "MUTE" then
				script.Parent.Parent.Event:Fire({AllCommand = "Mute"})
			elseif b.Name == "PROG4" then
				script.Parent.Parent.Event:Fire({AllCommand = "ClassChange"})
				script.Parent.Parent.Event.ClassChange.Value = true
			elseif b.Name == "LED-TEST" then
				script.Parent.Parent.Event:Fire({AllCommand = "LedTest"})
			elseif b.Name == "Menu" then
				ThisPanel:Fire("OpenMenu")
			elseif b.Name == "No1" then
				if InMenu.Value == true then
					ThisPanel:Fire("Button1Pressed")
				end
			elseif b.Name == "No2" then
				if InMenu.Value == true then
					ThisPanel:Fire("Button2Pressed")
				end
			elseif b.Name == "CONFIRM" then
				if InMenu.Value == true then
					ThisPanel:Fire("Confirm")
				end
			elseif b.Name == "Esc" then
				ThisPanel:Fire("EscapePressed")
			end
		end
	end)
end
while wait(10) do
	script.Parent.Parent.Event:Fire({SounderCommand = "Voice"})
	wait(4)
	script.Parent.Parent.Event:Fire({SounderCommand = "Sync"})
end
if script.Parent.Part:FindFirstChild("GUI") then
	script.Parent.Part.GUI.Texture = "http://www.roblox.com/asset/?id=9663551743"
elseif script.Parent.Part:FindFirstChild("Decal") then
	script.Parent.Part.Decal.Texture = "http://www.roblox.com/asset/?id=9663551743"
end
script.Parent.Enclosure.SurfaceGui:Destroy()
UIThing.Normal.ImageLabel.Image = "rbxassetid://8809170741"
warn("[Armodia_Systems]: Loaded Panel")