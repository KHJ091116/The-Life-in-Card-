local Service = game:GetService("ReplicatedStorage").EventFolder.LocalService
local LocalServicing = game:GetService("ReplicatedStorage").EventFolder.LocalServicing
local modify = require(game:GetService("ReplicatedStorage").Modify)
local OutroFolder = game:GetService("ReplicatedStorage").UiFolder.Outro
local UserCell = OutroFolder.PlayerIcon
local Base_Get_Point,X_Point = 100,7
local DelayWait = 0.4
local function Math(ui : Instance, Point : {}, Win : boolean) : ()
	print(Point)
	local ResultScroll = ui.ResultMainFrame.result_Frame.ResultScroll
	modify.Open(ui.Title,"More",true,0.1,false)
	modify.Open(ui.ResultMainFrame,"More",true,0.1,false)
	local CB =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	task.wait(0.1)
	LocalServicing:Fire({"Sound","Result"})
	task.wait()
	CB.Text = "Play : "..tostring(Base_Get_Point)
	CB.Parent = ResultScroll
	task.wait(0.7)
	local Times = 1
	local ResultCoint = 0
	local CointTimes = 0
		for i,v in pairs(Point[1]) do
			print(v)
			if v ~= 0 then
				if i ~= "Rating" then
					ResultCoint += v
					CointTimes += 1
				end
				task.spawn(function()
					LocalServicing:Fire({"Sound","Result"})
					local CR =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
					CR.Text = string.format("%s(%s) : %s",i,v,i ~= "Rating" and v*X_Point or v)
				CR.Parent = ResultScroll
				ResultScroll.CanvasPosition = Vector2.new(0,1000)
				end)
			end
			local Waiting = (DelayWait)/Times
			print(Waiting)
			task.wait(Waiting)
			Times += 0.5
		end
	local CutLay =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	CutLay.Text = "--------------"
	CutLay.Parent = ResultScroll
	ResultScroll.CanvasPosition = Vector2.new(0,1000)
	local CRCB =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	task.wait(0.1)
	LocalServicing:Fire({"Sound","LastResult"})
	task.wait()
	CRCB.Text = string.format("%s(%s) : (%s X 7) + %s", "ResultCoint", tostring(CointTimes), tostring(ResultCoint*X_Point),Base_Get_Point)
	CRCB.Parent = ResultScroll
	ResultScroll.CanvasPosition = Vector2.new(0,1000)
	local CRCRB =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	task.wait(0.1)
	LocalServicing:Fire({"Sound","LastResult"})
	task.wait()
	CRCRB.Text = string.format("= %s!", tostring((ResultCoint*X_Point)+Base_Get_Point))
	CRCRB.Parent = ResultScroll
	ResultScroll.CanvasPosition = Vector2.new(0,1000)
	local CRRB =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	task.wait(0.1)
	LocalServicing:Fire({"Sound","LastResult"})
	task.wait()
	CRRB.Text = string.format("%s(%s) : %s", "Rating", "1", tostring(Point[1]["Rating"]))
	CRRB.Parent = ResultScroll
	ResultScroll.CanvasPosition = Vector2.new(0,1000)
	local CRB =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	task.wait(0.1)
	LocalServicing:Fire({"Sound","LastResult"})
	task.wait()
	CRB.Text = Win and "You Win!" or "You Died!"
	CRB.Parent = ResultScroll
	local Space =  game:GetService("ReplicatedStorage").UiFolder.Outro.result_Layout:Clone()
	Space.Text = ""
	Space.Parent = ResultScroll
	ResultScroll.CanvasPosition = Vector2.new(0,1000)
	modify.Open(ui.ResultMainFrame.Text_Frame,"More",true,0.1,false)
	modify.Open(ui.ResultMainFrame.Out,"More",true,0.1,false)
end
local _Up_Size_, _Simple_Size_, _BlackOut_Size_ = UDim2.new(1,0,1.3,0), UDim2.new(1,0,1,0), UDim2.new(1,0,0.8,0)
local _Up_Color_, _Simple_Color_, _BlackOut_Color_ = Color3.new(1, 0.458824, 0.631373), Color3.new(1,1,1), Color3.new(0.211765, 0.211765, 0.211765)
local _BlackOut_Image_Color_ = Color3.new(0.0980392, 0.0980392, 0.0980392)
local _Set_Up_Color_ = Color3.new(0.396078, 1, 0.415686)
local _Up_Delay_ = 0.1
--local _Test_Icon_Id_ = 3388653901 -- OnlyTest
local PlayerList = script.Parent.PlayerFrame.Players

local function FindUserIcon(Id : number) : (Instance | boolean)
	print("Find Start")
	for i, v in pairs(PlayerList:GetChildren()) do
		if not v:FindFirstChild("UserId") or v:FindFirstChild("UserId").Value ~= Id or v:FindFirstChild("UserId").Value == 0 then continue end
		print("Find!")
		print(v)
		return v
	end
	print("Not Found")
	return false
end
local function UpIcon(Id : number) : ()
	print("Up Start")
	--local UserIcon = FindUserIcon(Id)
	local UserIcon = FindUserIcon(Id)-- == -1 and 3388653901 or 4317131993)
	if Id ~= 0 then
	if not UserIcon then print("nillIcon") return end
	print("LoadUp")
	modify.Tween(UserIcon,"ImageColor3",_Up_Color_,_Up_Delay_,true)
	modify.Tween(UserIcon,"Size",_Up_Size_,_Up_Delay_)
	end
	-- reset
	for i, v in pairs(PlayerList:GetChildren()) do
		if v.ClassName == "ImageLabel" and v ~= UserIcon and v:FindFirstChild("UserId").Value ~= 0 then
			modify.Tween(v,"ImageColor3",_Simple_Color_,_Up_Delay_,true)
			modify.Tween(v,"Size",_Simple_Size_,_Up_Delay_,true)
		end
	end
end
local function PlrThumnailImage(Image : Instance, userId : number) : ()
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)

	Image.Image = content
end
local function ResetUserIcon(IdArray : {number}, AllDel : boolean) : ()
	-- LastClosing
	--[[IdArray = {3388653901,
		4317131993}]]
	for i, v in pairs(PlayerList:GetChildren()) do
		if v.ClassName == "ImageLabel" then
			spawn(function()
			modify.Tween(v,"ImageColor3",_Simple_Color_,_Up_Delay_,true)
			modify.Tween(v,"Size",_Simple_Size_,_Up_Delay_,true)
			wait(_Up_Delay_)
			v:Destroy()
			end)
		end
	end
	--
	-- Delete_reset
	--
	if AllDel then return end
	for i, v in pairs(IdArray) do
		local Clone_UserIcon = UserCell:Clone()
		local UserId = Clone_UserIcon.UserId
		local Icon = Clone_UserIcon.Icon
		
		PlrThumnailImage(Icon, v)
		Clone_UserIcon.Parent = PlayerList
		UserId.Value = v
		spawn(function()
			print("d")
			modify.Tween(Clone_UserIcon,"Size",_Up_Size_,_Up_Delay_,true)
			modify.Tween(Clone_UserIcon,"ImageColor3",_Set_Up_Color_,_Up_Delay_,true)
			task.wait(_Up_Delay_)
			modify.Tween(Clone_UserIcon,"Size",_Simple_Size_,_Up_Delay_,true)
			modify.Tween(Clone_UserIcon,"ImageColor3",_Simple_Color_,_Up_Delay_,true)
		end)
		
		task.wait(_Up_Delay_+0.2)
	end
end
local function BlackOut(Id : number)
	local UserIcon = FindUserIcon(Id) --== -1 and 3388653901 or 4317131993)
	if not UserIcon then return end
	UserIcon.UserId.Value = 0
	modify.Tween(UserIcon,"ImageColor3",_BlackOut_Color_,_Up_Delay_,true)
	modify.Tween(UserIcon.Icon,"ImageColor3",_BlackOut_Image_Color_,_Up_Delay_,true)
	modify.Tween(UserIcon,"Size",_BlackOut_Size_,_Up_Delay_)
end
-- Testing Button
script.Parent.TextButton.MouseButton1Up:Connect(function()
	local Id = script.Parent.TextButton.TextBox.Text
	print( Id)
	UpIcon(tonumber(Id))
end)
script.Parent.RestingArray.MouseButton1Up:Connect(function()
	local resetarray = string.split(script.Parent.RestingArray.TextBox.Text,",")
	print(resetarray)
	ResetUserIcon(resetarray)
end)
--
local function GetIdfromPlr(PlrArray : {Instance}) : {number}
	local result = {}
	for i, v in pairs(PlrArray) do
		if v then
			local Id = v.UserId	
			table.insert(result, Id)
		end
	end
	return result
end
local Match = script.Parent.Parent:WaitForChild("intoro"):WaitForChild("Match_Frame")
Service.OnClientEvent:Connect(function(Type,INF)
	if Type == "Winner" then
		modify.Tween(game:GetService("Lighting").Blur,"Size",56)
		local win =  OutroFolder.Win:Clone()
		win.Parent = script.Parent
        Math(win, INF, true)
		local Out_Button = win.ResultMainFrame.Out
		Out_Button.MouseEnter:Connect(function()
			Out_Button.Image = "rbxassetid://135490739710398"
		end)
		Out_Button.MouseLeave:Connect(function()
			Out_Button.Image = "rbxassetid://90584000029136"
		end)
		Out_Button.MouseButton1Down:Connect(function()
			modify.Open(win,"More",true,0.1,false)
			task.wait(.1)
			win:Destroy()
			task.wait(.5)
			modify.load(Match,true)
			print("Out!")
			task.wait(.5)
			modify.Tween(game:GetService("Lighting").Blur,"Size",0,0.2)
			ResetUserIcon({1},true)
		end)
	elseif Type == "Loser" then
		modify.Tween(game:GetService("Lighting").Blur,"Size",56)
		modify.Tween(script.Parent.BlackOutFrame,"BackgroundTransparency",0.5)
		
		local lose =  OutroFolder.Lose:Clone()
		lose.Parent = script.Parent
		LocalServicing:Fire({"Text","Die"})
		Math(lose, INF, false)
		local Out_Button = lose.ResultMainFrame.Out
		Out_Button.MouseEnter:Connect(function()
			Out_Button.Image = "rbxassetid://135490739710398"
		end)
		Out_Button.MouseLeave:Connect(function()
			Out_Button.Image = "rbxassetid://90584000029136"
		end)
		Out_Button.MouseButton1Down:Connect(function()
			modify.Open(lose,"More",true,0.1,false)
			task.wait(.1)
			lose:Destroy()
			task.wait(.5)
			modify.load(Match,true)
			print("Out!")
			task.wait(.5)
			modify.Tween(game:GetService("Lighting").Blur,"Size",0,0.2)
			script.Parent.BlackOutFrame.BackgroundTransparency = 1
			ResetUserIcon({1},true)
		end)
	elseif Type == "Set_Player" then
		print("Setting")
		ResetUserIcon(GetIdfromPlr(INF))
	elseif Type == "Up_Player" then
		print("Up")
		UpIcon(INF)
	elseif Type == "Reset_Player" then
		print("Reset")
		ResetUserIcon({1},true)
	elseif Type == "BlackOut" then
		print("Blackout")
		BlackOut(INF)
	elseif Type == "Guide" then
		local Guide_Clone = OutroFolder.GuideFrame:Clone()
		Guide_Clone.Parent = script.Parent
		Guide_Clone.Position = UDim2.new(0,0,1,0)
		modify.Tween(Guide_Clone,"Position",UDim2.new(0,0,1-Guide_Clone.Size.Y.Scale,0),0.2)
		modify.UiMove(Guide_Clone.Key,"Rotation",3,-3,1)
		task.wait(0.2)
		for i, v in pairs(Guide_Clone.PlayerList:GetChildren()) do
			if v.ClassName ~= "UIListLayout" and v.LayoutOrder <= #INF then
				v.name.Text = INF[v.LayoutOrder].Name
				modify.Open(v,"More",true,0.2,false)
				LocalServicing:Fire({"Sound","Result"})
				task.wait(0.2)
			end
		end
		task.wait(3)
		modify.Tween(Guide_Clone,"Position",UDim2.new(0,0,1,0),0.2)
	end
end)