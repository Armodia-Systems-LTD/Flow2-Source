local TweenService = game:GetService("TweenService")
local Debounce = false
local Keyswitch = script.Parent.Main.Keyswitch
local SysFolder = script.Parent.Parent.Parent
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut, 0, false, 0)
local KeyswitchOff = TweenService:Create(Keyswitch, tweenInfo, {CFrame = Keyswitch.Parent.KeyswitchOff.CFrame})
local KeyswitchOn = TweenService:Create(Keyswitch, tweenInfo, {CFrame = Keyswitch.Parent.KeyswitchOn.CFrame})
script.Parent.Sensor.Touched:Connect(function(Tool)
	if Debounce == false then
		local RealTool = Tool.Parent
		if RealTool.ClassName == "Tool" and RealTool:FindFirstChild("ArmodiaKey") and RealTool:FindFirstChild("Function").Value == "FIRESWITCH" then
			if SysFolder.Event.SysPower.Value == true then
				SysFolder.Event.SysPower.Value = false
				KeyswitchOff:Play()
				Debounce = true
				wait(4)
				Debounce = false
			elseif SysFolder.Event.SysPower.Value == false then
				SysFolder.Event.SysPower.Value = true
				KeyswitchOn:Play()
				Debounce = true
				wait(4)
				Debounce = false
			end
		end
	end
end)
SysFolder.Event.SysPower.Changed:Connect(function()
	if SysFolder.Event.SysPower.Value == true then
		KeyswitchOn:Play()
	elseif SysFolder.Event.SysPower.Value == false then
		KeyswitchOff:Play()
	end
end)
