local Frame = script.Parent
local amplitudeX = 3
local amplitudeY = 5
local amplitudeRotation = 3
local frequency =0.5
local modify = require(game:GetService("ReplicatedStorage").Modify) 
local StartFrame = script.Parent.Parent
local startTime = tick()
local TweenService = game:GetService("TweenService")
local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
local Uis = game:GetService("UserInputService")
if Uis.TouchEnabled then
	plr.PlayerGui.TouchGui:Destroy()
end
local KoreaGames,Warning = script.Parent.Parent.Load.KoreaBoardGames,script.Parent.Parent.Load.Warning
local modify = require(game:GetService("ReplicatedStorage").Modify)
local load = coroutine.create(function()
	modify.UiMove(StartFrame.Cards,"Rotation",5,-5,1)
	modify.UiMove(StartFrame.Cards,"Position", UDim2.new(0.507, 0,0.734, 0), UDim2.new(0.507, 0,0.744, 0), 2,"Bounce")
	modify.UiMove(StartFrame.LogoImage,"Position", UDim2.new(0.095, 0,0.197, 0), UDim2.new(0.095, 0,0.207, 0), 2,"Bounce")
	modify.UiMove(StartFrame.Foot_Bar,"Rotation",.5,-.5,.5)
	modify.UiMove(StartFrame.Top_Bar,"Rotation",.5,-.5,.5)
	modify.UiMove(StartFrame.LogoImage,"Rotation",3,-3,1)
	script.Parent.Parent.Load.SkipButton.MouseButton1Up:Connect(function()
		print("AAAA")
		modify.Tween(KoreaGames,"ImageTransparency",1,.2)
		modify.Tween(KoreaGames.txt,"TextTransparency",1,.2)
		modify.Tween(Warning.Warning_Icon,"ImageTransparency",1,.2)
		modify.Tween(Warning,"TextTransparency",1,.2)
		modify.Tween(script.Parent.Parent.Load.SkipButton,"BackgroundTransparency",1,.2)
		modify.Tween(script.Parent.Parent.Load.SkipButton,"TextTransparency",1,.2)
		modify.Tween(script.Parent.Parent.Load.SkipButton.UIStroke,"Transparency",1,.2)
		wait(1)
		script.Parent.Parent.Load.Visible = false
	end)
	script.Parent.Parent.Load.Visible = true
	wait(1)
	modify.Tween(KoreaGames,"ImageTransparency",0,.7)
	modify.Tween(KoreaGames.txt,"TextTransparency",0,.7)
	wait(.7)
	modify.Tween(KoreaGames,"ImageTransparency",1,.5)
	modify.Tween(KoreaGames.txt,"TextTransparency",1,.5)
	wait(.5)
	modify.Tween(Warning.Warning_Icon,"ImageTransparency",0,.7)
	modify.Tween(Warning,"TextTransparency",0,.7)
	wait(2)
	modify.Tween(Warning.Warning_Icon,"ImageTransparency",1,.5)
	modify.Tween(Warning,"TextTransparency",1,.5)
	modify.Tween(script.Parent.Parent.Load.SkipButton,"BackgroundTransparency",1,.2)
	modify.Tween(script.Parent.Parent.Load.SkipButton,"TextTransparency",1,.2)
	modify.Tween(script.Parent.Parent.Load.SkipButton.UIStroke,"Transparency",1,.2)
	wait(.2)
	modify.Tween(script.Parent.Parent.Load,"Transparency",1,.3)
	wait(1)
	script.Parent.Parent.Load.Visible = false
end)
coroutine.resume(load)
-- StartSystem
print("AAAAAAAAAAAAAA")
local CCam = workspace.Camera
CCam.CameraType = Enum.CameraType.Scriptable
modify.Tween(CCam,"CFrame",CFrame.new(workspace:WaitForChild("Void"):WaitForChild("First_Camera").Position)*CFrame.Angles(0,math.rad(180) ,0),0.1)
script.Parent.Parent.Visible = true
game:GetService("RunService").Heartbeat:Connect(function()
	if script.Parent.Parent.Parent.Match_Frame.Visible then return end
	local currentTime = tick() - startTime
	if Frame.Visible then

		local angle = 2 * math.pi * frequency * currentTime

		local xPosition = amplitudeX * math.sin(angle)

		local yPosition = amplitudeY * math.cos(angle)

		local rotationAngle = amplitudeRotation * math.sin(angle)

		Frame.Position = UDim2.new(Frame.Position.X.Scale, xPosition, Frame.Position.Y.Scale, yPosition)
		Frame.Rotation = rotationAngle
		--
		local Fram = script.Parent.Parent.Logo
		local angle1 = 2 * math.pi * 0.3 * currentTime-5

		local xPosition1 = 3 * math.sin(angle1)

		local yPosition1 = 8 * math.cos(angle1)
		local rotationAngle1 = amplitudeRotation * math.sin(angle1)

		Fram.Position = UDim2.new(Fram.Position.X.Scale, xPosition1, Fram.Position.Y.Scale, yPosition)
		Fram.Rotation = rotationAngle1
	end
end)