local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(
	4,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.InOut,
	0,
	false,
	0 
)
local LEDOn = TweenService:Create(script.Parent.POWER, tweenInfo, {Color = Color3.fromRGB(0, 255, 0)})
local LEDOff = TweenService:Create(script.Parent.POWER, tweenInfo, {Color = Color3.fromRGB(163, 162, 165)})
script.Parent.Parent.Parent.Event.SysPower.Changed:Connect(function()
	if script.Parent.Parent.Parent.Event.SysPower.Value == false then
		wait(4)
		script.Parent.FAULT.Color = Color3.fromRGB(255, 157, 0)
		script.Parent.FAULT.Material = Enum.Material.Neon
		LEDOff:Play()
		wait(4)
		script.Parent.POWER.Color = Color3.fromRGB(163, 162, 165)
		script.Parent.POWER.Material = Enum.Material.Glass
	elseif script.Parent.Parent.Parent.Event.SysPower.Value == true then
		wait(3)
		script.Parent.FAULT.Color = Color3.fromRGB(163, 162, 165)
		script.Parent.FAULT.Material = Enum.Material.Glass
		LEDOn:Play()
		wait(2)
		script.Parent.POWER.Material = Enum.Material.Neon
	end
end)
