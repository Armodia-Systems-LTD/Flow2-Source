local sounder = script.Parent.Sounder
local SystemSettings = require(script.Parent.Parent.Settings)
local SoftStart = SystemSettings.SoftStart.SoftStartEnabled
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(
	SystemSettings.SoftStart.SoftStartTime,
	Enum.EasingStyle.Sine, -- EasingStyle
	Enum.EasingDirection.InOut, -- EasingDirection
	0,
	false,
	SystemSettings.SoftStart.SoftStartDelay
)
local intstate = "off"
local ClassChange = TweenService:Create(sounder.ClassChange, tweenInfo, {Volume = 5})
local Alert = TweenService:Create(sounder.Alert, tweenInfo, {Volume = 5})
local Evac = TweenService:Create(sounder.Evac, tweenInfo, {Volume = 5})
local soundermode = script.DoingVoice.Value
local VAD_Event;
local function pulseVAD()
	local VAD = script.Parent:FindFirstChild("VAD")
	if (not VAD) then return end;
	-- On
	VAD.PointLight.Enabled = true
	VAD.Material = Enum.Material.Neon
	VAD.BrickColor = BrickColor.new("Really red")
	wait(0.1)
	-- Off
	VAD.PointLight.Enabled = false
	VAD.Material = Enum.Material.SmoothPlastic
	VAD.BrickColor = BrickColor.new("Medium stone grey")
end
if script.Parent.Parent.Event.Disabled.Value == false then
	script.Parent.Parent.Event.Event:Connect(function(datain)
		--print(datain)
		if datain.SounderCommand == "Alert" then
			VAD_Event = sounder.Alert.DidLoop:Connect(pulseVAD)
			if SoftStart == true then
				sounder.Alert.Volume = 0
				wait(0.2)
				Alert:Play()
				sounder.Evac:Stop()
				sounder.Alert:Play()
				sounder.ClassChange:Stop()
				sounder.Evac.Volume = 0
			elseif SoftStart == false then
				sounder.Evac:Stop()
				sounder.Alert:Play()
				sounder.ClassChange:Stop()
				sounder.Alert.Volume = 0
			end
		elseif datain.SounderCommand == "Evac" then
			VAD_Event = sounder.Evac.DidLoop:Connect(pulseVAD)
			if SoftStart == true then
				sounder.Alert.Volume = 0
				wait(0.2)
				Evac:Play()
				intstate = "evc"
				sounder.Evac:Play()
				sounder.Alert:Play()
				sounder.ClassChange:Stop()
				sounder.Alert.Volume = 0
			elseif SoftStart == false then
				intstate = "evc"
				sounder.Evac:Play()
				sounder.Alert:Play()
				sounder.ClassChange:Stop()
				sounder.Alert.Volume = 0
			end
		elseif datain.SounderCommand == "ClassChange" then
			if SoftStart == true then
				sounder.Alert.Volume = 0
				wait(0.2)
				ClassChange:Play()
				intstate = "cc"
				sounder.Evac:Stop()
				sounder.Alert:Stop()
				sounder.ClassChange:Play()
				sounder.Evac.Volume = 0
				sounder.Alert.Volume = 0
			elseif SoftStart == false then
				intstate = "cc"
				sounder.Evac:Stop()
				sounder.Alert:Stop()
				sounder.ClassChange:Play()
				sounder.Evac.Volume = 0
				sounder.Alert.Volume = 0
			end
		elseif datain.SounderCommand == "Silence" then
			sounder.Evac.Volume = 0
			sounder.Alert.Volume = 0
			sounder.ClassChange.Volume = 0
		elseif datain.SounderCommand == "Stop" then
			intstate = "off"
			sounder.Evac:Stop()
			sounder.ClassChange:Stop()
			sounder.Alert:Stop()
			sounder.ClassChange.Volume = 3
			if (VAD_Event) then
				VAD_Event:Disconnect()
			end
		elseif datain.SounderCommand == "Voice" then
			soundermode = true
		elseif datain.SounderCommand == "Sync" then
			sounder.Alert.TimePosition = 0
			sounder.Evac.TimePosition = 0
		end
	end)
end
