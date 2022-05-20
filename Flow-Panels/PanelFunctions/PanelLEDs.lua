repeat
	wait(0.5)
	script.Parent.Parent.LEDs.FIRE.Color = Color3.fromRGB(255, 0, 0)
	script.Parent.Parent.LEDs.FIRE.Material = Enum.Material.Neon
	wait(0.5)
	script.Parent.Parent.LEDs.FIRE.Color = Color3.fromRGB(99, 95, 98)
	script.Parent.Parent.LEDs.FIRE.Material = Enum.Material.SmoothPlastic
until false