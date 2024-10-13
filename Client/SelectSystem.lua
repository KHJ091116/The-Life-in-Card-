local Card_Frame = script.Parent:GetChildren()
local plr = game:GetService("Players").LocalPlayer
local modify = require(game:GetService("ReplicatedStorage").Modify)
local TweenService = game:GetService("TweenService")
local UiFolder = game:GetService("ReplicatedStorage").UiFolder
local Uis = game:GetService("UserInputService")
local debris = game:GetService("Debris")
local LocalService = game:GetService("ReplicatedStorage").EventFolder.LocalService
local LocalServicing = game:GetService("ReplicatedStorage").EventFolder.LocalServicing
local RoomService = game:GetService("ReplicatedStorage").EventFolder.RoomService
local _P_A_TextFrame_ = script.Parent.TextFrame
local Cancel = script.Parent.Cancel
local Select_Icon = "rbxassetid://90395613153821"
local mouse = plr:GetMouse()
local inputs = {"Touch","MouseButton1"}
local locked_Cancel = false
local Select_Wait = false
local pickup
local Turn_Lock
local Card
local Select_Card_Object
local offset
local Card_UpOffset = Uis.TouchEnabled and -5 or -15
--local Was_Pos
local anchored_Y ,anchored_X = 0,0
local Selecting = nil
local Drag
local X = nil
local TweenService = game:GetService("TweenService")
local plr = game:GetService("Players").LocalPlayer
local Uis = game:GetService("UserInputService")
local SFX = script.SFX
print(math.random())
local function Tween(object : Instance, pse, waiting : number) : ()
	local Tweeninfo = TweenInfo.new(
		waiting or 1,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)
	local pose = {CFrame = pse}
	TweenService:Create(object,Tweeninfo,pose):Play()
end
local Selist = {}
local ImageArray = {
	Again = {"rbxassetid://117806989336902",SFX.TextUp},
	Pass = {"rbxassetid://99859143240088",SFX.TextUp},
	WoW = {"rbxassetid://106723535247540",SFX.TextUp},
	Solve = {"rbxassetid://95921855326827",SFX.TextUp},
	Youwon = {"rbxassetid://92656579918129",SFX.TextUp},
	Oops = {"rbxassetid://72641204960491",SFX.TextUp},
	Die = {"rbxassetid://100431442550893",SFX.Die}
}
function P_A_Text(Text : string) : ()
	local TextId = ImageArray[Text][1]
	ImageArray[Text][2]:Play()
	local ImageLabel = _P_A_TextFrame_.LogoImage
	ImageLabel.Image = TextId
	_P_A_TextFrame_.Visible = true
	_P_A_TextFrame_.Size = UDim2.new(0.379, 0,0.058, 0)
	modify.Tween(_P_A_TextFrame_,"Size",UDim2.new(0.575, 0,0.09, 0),.2)
	modify.UiMove(_P_A_TextFrame_,"Rotation",3,-3,15)
	--if Text ~= "Die" then
	task.wait(1)
	modify.Tween(_P_A_TextFrame_,"Size",UDim2.new(0.379, 0,0.058, 0),.2)
	wait(0.2)
	modify.UiMove(_P_A_TextFrame_,"StopIt")
	_P_A_TextFrame_.Visible = false
	_P_A_TextFrame_.Rotation = 0
	--end
end
local function PlrThumnailImage(Image : Instance, userId) : ()
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)

	Image.Image = content
end
local GuessFrame = game:GetService("ReplicatedStorage").UiFolder.Outro.PlayGuess
function main(array)
	if array[1] == "Cam" then
		print("Cam",array[1],array[2])
		local CCam = workspace.Camera
		CCam.CameraType = Enum.CameraType.Scriptable
		Tween(CCam,array[2])
		wait(1)
	elseif array[1] == "CardNum" then
		array[2].Text = array[3]
	elseif array[1] == "Effectering_Card" then
		array[2].Reflectance = 0
	elseif array[1] == "Sound" then
		wait(0.1)
		--print(SFX:WaitForChild(array[2]))
		local sound = SFX:WaitForChild(array[2])
		sound:Play()
	elseif array[1] == "WatchCam" then
		local CCam = workspace.Camera
		CCam.CameraType = Enum.CameraType.Scriptable
		CCam.CameraSubject = array[2]
	elseif array[1] == "Text" then
		P_A_Text(array[2])
	elseif array[1] == "Guess" then
		local CG = GuessFrame:Clone()
		CG.Parent = script.Parent
		CG.Visible = false
		modify.Open(CG,"More",true,0.1,true,{CG.DrownPlr,CG.GuessPlr,CG.Guess})
		task.wait(0.2)
		modify.Open(CG.GuessPlr,"More",true,0.2,false)
		main("Sound","Guess")
		PlrThumnailImage(CG.GuessPlr.PlayerImage,array[2][1])
		task.wait(0.2)
		modify.Open(CG.Guess,"More",true,0.2,false)
		main("Sound","Guess")
		CG.Guess.GuessText.Text = array[3]
		task.wait(0.2)
		modify.Open(CG.DrownPlr,"More",true,0.2,false)
		main("Sound","Guess")
		PlrThumnailImage(CG.DrownPlr.PlayerImage,array[2][2])
		task.wait(0.5)
		modify.Open(CG.Guess.DrownMassage,"More",true,0.2,false)
		modify.Tiping(CG.Guess.DrownMassage,array[4] and "Yea.." or "Nop!",0.05,false,false,true)
		wait(0.7)
		CG:Destroy()
	end 
end
script.Parent.GuessButton.MouseButton1Up:Connect(function()
	main({"Guess",{100000,100001},script.Parent.GuessNum.Text,false})
end)
script.Parent.Reset.MouseButton1Up:Connect(function()
	for i, v in pairs(script.Parent:GetChildren()) do
		if v.Name == "PlayGuess" then
			v:Destroy()
		end
	end
end)
game:GetService("ReplicatedStorage").EventFolder.LocalService.OnClientEvent:Connect(main)
game:GetService("ReplicatedStorage").EventFolder.LocalServicing.Event:Connect(main)
function Select_Icons(types,Object)-- 선택 아이콘
	if types then -- 개체값 위에 선택 아이콘 추가
	local Sel_Part = Instance.new("Part",Object)
	Sel_Part.Name = "Icons"
	Sel_Part.Transparency = 1
	Sel_Part.Anchored = true
	Sel_Part.CanCollide = false
	Sel_Part.CanQuery = false
	Sel_Part.CanTouch = false
	Sel_Part.Size = Vector3.new(1.2,1.2,0.2)
	Sel_Part.CFrame = Object.CFrame * CFrame.new(0,(Object.Size.Y/2)+Sel_Part.Size.Y/2,0) * CFrame.Angles(0,math.rad(-90),0)
	local surface = Instance.new("SurfaceGui",Sel_Part)
	surface.AlwaysOnTop = true
	local Sel_Image = Instance.new("ImageLabel",surface)
	Sel_Image.Image = Select_Icon
	Sel_Image.Size = UDim2.new(1,0,1,0)
	Sel_Image.BackgroundTransparency = 1
	table.insert(Selist,Sel_Part)
	main({"Sound","Enter"})
		
	else -- 타입이 false라면 선택 아이콘 초기화
		for i , v in pairs(Selist) do
			v:Destroy()
		end
	end
end
local function mathLO(v)
	local CN = Card[v.Name] -- 카드 숫자 검색
	local result -- 결과
	if v:GetAttribute("CardColor") then -- 검색 개체가 흰색 카드 라면
		if CN == 0 then -- 검색 결과 0이라면
			result = 1 -- 흰색 우선순위
			return result -- 반환
		end
		result = CN * 2 + 1 -- 2곱의 이유는 우선순위 +1 할때 검정과 숫자 곂침을 방지하기 위해 공간마련
	else -- 검색 카드가 검정 카드 라면
		if CN == 0 then -- 검색 결과 0이라면
			result = 0 -- 검정 뒤처짐
			return result -- 반환
		end
		result = CN * 2 -- 우선순위 때문에 2곱
	end
	return result
end
local function setoffset(v)
	local MousePos = Vector2.new(mouse.X, mouse.Y) -- 커서 위치 벡터에 집어 넣은 값
	local GuiPos = v.AbsolutePosition -- 가짜 Ui Offset위치 값 변서에 설정
	offset =  Vector2.new((GuiPos - MousePos).X,(anchored_Y - MousePos.Y))
end
local function Finish(cancel)
	print(pickup)
	if not pickup and Select_Card_Object and Select_Card_Object:FindFirstChild("cover") then 
		print(Select_Card_Object)
		print(Select_Card_Object:FindFirstChild("cover"))
	Select_Card_Object:FindFirstChild("cover"):Destroy()
	end
	Select_Card_Object = nil
	Cancel.Visible = false
	if script.Parent:FindFirstChild("Select_Frame") then
	script.Parent:FindFirstChild("Select_Frame"):ClearAllChildren()
	debris:AddItem(script.Parent:FindFirstChild("Select_Frame"),0)
	end
	script.Parent.Sel:ClearAllChildren()
	Drag = nil
	Select_Wait = false
	Selecting = nil
end
local function Drag_EnabledCard(Bar,Visibled)
	local XP = 0
	if Visibled == false then XP = -2.3 end
	Bar.Card.Position = Vector3.new(XP,0,-2.3)
	Bar.Line.Visible = Visibled
	Bar.Select.Visible = Visibled
	Bar.CardNum.Visible = Visibled
end

--Frame.Visible = false
local Selcon
local SelsLock = false
-----
local real 
local fake,OnPlaced
local Locker = false
local function Del_Up()
	--local fakeDel = coroutine.create(function()
		if real ~= nil then
			print("Hold")
			real.Visible = true
			OnPlaced:Destroy()
			fake:Destroy()
			real = nil
			fake = nil	
		end
	--end)
	--coroutine.resume(fakeDel)
end
local LeftClick,RightClick,CancelClick,Began
local function turn(array,card,Pickup)
if array[1] == "Turn" then
if CancelClick then CancelClick:Disconnect() CancelClick = nil end
print("Start")
print(array[2])
Select_Wait = false
Selecting = nil
pickup = Pickup	
		Selcon = mouse.Move:Connect(function()
			local tar = mouse.Target
			if Select_Card_Object == nil and not pickup then -- 선택한 카드가 없고 선택해서 보여주는 작동 타입이 아니라면
				Del_Up() -- 올라가게된 카드 초기화
				if tar == nil or tar.Parent.Name == plr.Name or tar.Parent.Name == "Cards" or tar:GetAttribute("See") then --지금 타겟이 Nil값이거나 지금 커서 올려둔 개체는 내 카드거나 플레이팅 된 카드거나 이미 수가 드러난 카드 라면 
					Select_Icons(false) -- 선택 Ui 삭제
					return
				end
				if string.find(tar.Name,"Card") and not tar:FindFirstChild("Icons") and Select_Card_Object == nil and tar:GetAttribute("See") == false then -- 카드 이고 아이콘이 이미 있지 않고 카드 선택 되지 않았고 수가 드러난 카드가 아니라면
					Select_Icons(false) -- 선택 Ui 삭제
					Select_Icons(true,tar) -- 선택 Ui 작동
				end
				return
			elseif (Select_Card_Object ~= nil or pickup) and X then -- 지금 카드 선택을 완료 한 상태이고 캔슬 한 상태도 아니라면

				local SelFolder = script.Parent.Sel -- 사본 저장 폴더
				local MousePos = game:GetService("UserInputService"):GetMouseLocation() - game:GetService("GuiService"):GetGuiInset() -- 마우스 커서 위치
				local getGUI = plr.PlayerGui:GetGuiObjectsAtPosition(MousePos.X,MousePos.Y) -- 카우스 커서에 들어온 Ui 값을 배열로 반환
				if Locker then return end -- for문 잠금 장치
				for i , v in pairs(getGUI) do -- 배열 For문으로 검사 시작
					if v.Name == "CardBar" then -- 마우스 커서에 들어온 Ui 중 선택 카드 ui 값이 있다면
						if (real ~= v) then -- 지금 작동된 Ui 와 커서에 들어온 Ui 값이 다르다면
							--print("HOLDDDDDDDDDDDDDDDDDDDD")
							Locker = true -- 잠금
							Del_Up()
							local Pse,Size = UDim2.new(0,v.AbsolutePosition.X,0,0.73*script.Parent.AbsoluteSize.Y+Card_UpOffset) ,UDim2.new(0,v.AbsoluteSize.X,0,v.AbsoluteSize.Y) -- 포지션, 크기 값대로 내가 커서올릴때 설정값
							local Fake = v:Clone()
							local OnPlace = Instance.new("Frame",v.Parent) -- 자리 차지해줄 투명한 공간
							OnPlace.BackgroundTransparency = 1 -- 투명하게
							OnPlace.BorderSizePixel = 0 -- 테두리 없엠
							OnPlace.LayoutOrder = v.LayoutOrder -- 진짜 Ui 위치로 이동
							OnPlaced = OnPlace -- 자리차지 공간 값 전역 변수에 저장
							--local test = Instance.new("Frame",script.Parent)
							--test.Size = UDim2.new(0,3,0,3)
							--test.Position = Pse
							--test.BackgroundColor3 = Color3.new(1, 0, 0)
							--test.ZIndex = 100
							print(v.Position)
							print(v.AbsolutePosition)
							print(v)
							--print(mouse.ViewSizeY)
							--print(mouse.ViewSizeY-v.AbsoluteSize.Y)
							Fake.Parent = SelFolder -- 사본 폴더에 이동
							Fake.Position = Pse -- 포지션값 적용
							Fake.Size = Size -- 사이즈 값 적용
							Fake.Name = "Fake" -- 이름 으로 구분
							Fake.ZIndex = 10 -- 우선순위 맨 윗쪽으로
							v.Visible = false -- 원래 Ui 비활성화
							real = v -- 진짜 ui값 전역 변수에 저장
							fake = Fake -- 가짜 ui값 전역 변수에 저장
							
							if Began then -- 작동되는 이벤트가 있다면
								Began:Disconnect() -- 중지
							end
							Began = Fake.Select.InputBegan:Connect(function(Input)
								if  SelsLock then return end -- 잠금 장치
								local inputType = Input.UserInputType.Name -- 누른 방식 이름
								if table.find(inputs,inputType) then -- 내가 설정한 누른 방식에 포함된 방식인지 검색
									SelsLock = true -- 잠금
									anchored_Y = 0.73*script.Parent.AbsoluteSize.Y+Card_UpOffset -- 원래 Y 위치값 전역 변수 저장
									anchored_X = Fake.AbsolutePosition.X -- 원래 X 위치값 전역 변수 저장
									setoffset(Fake)
									Drag = Fake -- 드래그 되는 값에 가짜 ui저장
								end
							end)
							Locker = false -- 잠금 풀음
						elseif (real == v) then
							--print("qqqqq")
							return
						end
					end	
				end
				
			end
		end)
if not Pickup then
Turn_Lock = true 
Card = card


LeftClick = mouse.Button1Down:Connect(function()
	local MouseTarget = mouse.Target
	print("Target : ",MouseTarget)
	if Select_Card_Object == nil and Turn_Lock == true then
	if MouseTarget == nil or MouseTarget.Parent.Name == plr.Name or MouseTarget.Parent.Name == "Cards" or MouseTarget:GetAttribute("See") then
    return
	end
	if string.find(mouse.Target.Name,"Card")then
		print("Coverinstants")
		main({"Sound","Hind"})
		Select_Card_Object = MouseTarget
		local cover = Instance.new("Highlight",Select_Card_Object)
		cover.FillColor = Color3.new(0, 0, 0)
	    cover.FillTransparency = 0.5
		cover.Name = "cover"
		if string.find(Select_Card_Object.Name,"B") then
		cover.OutlineColor = Color3.new(1, 1, 1)
		elseif string.find(Select_Card_Object.Name,"W") then
		cover.OutlineColor = Color3.new(0, 0, 0)
		end
		LeftClick:Disconnect()
	end	
	end
end)

repeat
	wait()
until Select_Card_Object ~= nil
--
RightClick = mouse.Button2Down:Connect(function()
	if X == true then
	Select_Icons(false)
    if Selcon then
		Selcon:Disconnect()
	end
	Selcon = nil
	SelsLock = false
	Finish()	
	Del_Up()
	if Began then
		Began:Disconnect()
	end
	X = nil
	turn({"Turn",array[2]},card,pickup,"BBB")
	LeftClick:Disconnect()
	RightClick:Disconnect()
	end
end)
CancelClick = Cancel.MouseButton1Up:Connect(function()
	if not locked_Cancel then
		locked_Cancel = true
		Select_Icons(false)
		if Selcon then
			Selcon:Disconnect()
		end
		Selcon = nil
		SelsLock = false
		Finish(true)
		Del_Up()
		if Began then
			Began:Disconnect()
		end
		script.Parent.Sel:ClearAllChildren()
		locked_Cancel = false
		CancelClick:Disconnect()
		CancelClick = nil
		turn({"Turn",{0,1,2,3,4,5,6,7,8,9,10,11,"ㅡ"}},Card,false)
	end
end)
Cancel.Visible = (Uis.TouchEnabled == true and not Pickup)
end

local CS = UiFolder.PlayUi.Select_Frame:Clone()
	CS.Parent = script.Parent
	CS.Visible = true
	local arring
	arring = array[2]
	if Pickup then
		arring = array[2]:GetChildren()
	end
for i, v in pairs(arring) do
	local Bar = UiFolder.PlayUi.CardBar:Clone()
	local BW
	if Pickup then -- 틀려서 있는 카드중에 로딩
		if v:GetAttribute("See") then
			continue
		end
		Bar.CardNum.Text = v.Text.SF.Number.Text
		if v ~= "ㅡ" then
			Bar.LayoutOrder = mathLO(v) 
		elseif v == "ㅡ" then
			if v:GetAttribute("CardColor") then
			Bar.LayoutOrder = 101
			else
			Bar.LayoutOrder = 100
			end
		end
		Bar.Object.Value = v
		BW = not v:GetAttribute("CardColor")
	else -- 카드 로딩
		Bar.CardNum.Text = v
		if v ~= "ㅡ" then
			Bar.LayoutOrder = v
		elseif v == "ㅡ" then
			Bar.LayoutOrder = 24
		end
		BW = not Select_Card_Object:GetAttribute("CardColor")
	end
	Bar.Parent = CS
	local b = Bar.Select
	print(v)
	print(pickup and v:GetAttribute("CardColor") or "not")
	
	
	Bar:FindFirstChild("Card").Color = BW and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
	Bar:FindFirstChild("CardNum"):FindFirstChild("UIStroke").Color = BW and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
	Bar:FindFirstChild("CardNum").TextColor3 = BW and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
	Bar:FindFirstChild("Line").BackgroundColor3 = BW and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
			--local test = Instance.new("Frame",script.Parent)
			--test.Size = UDim2.new(0,3,0,3)
			--test.Position = UDim2.new(0,CS.AbsolutePosition.X,0,CS.AbsolutePosition.Y) 
			--test.BackgroundColor3 = Color3.new(0.8, 0, 1)
			--test.ZIndex = 100
		
end
	for i, Bar in pairs(CS:GetChildren()) do
		if Bar.ClassName == "UIGridLayout" then continue end
		local test = Instance.new("Frame",script.Parent)
		--test.Size = UDim2.new(0,Bar.AbsoluteSize.X,0,5) --UDim2.new(0,3,0,3)
		--test.Position = UDim2.new(0,Bar.AbsolutePosition.X,0,Bar.AbsolutePosition.Y) 
		--test.BackgroundColor3 = Color3.new(0, 1, 0.317647)
		--test.ZIndex = 100
		--print(Bar)
	end
	X = true
end	
end
-- OnlyTesting While
--while task.wait(4) do
--	print("Upit!")
--	P_A_Text(math.random(1,2) == 1 and (math.random(1,2) == 1 and (math.random(1,2) == 1 and "Again" or "Pass") or (math.random(1,2) == 1 and "WoW" or "Solve")) or math.random(1,2) == 1 and "Youwon" or math.random(1,2) == 1 and "Oops" or "Die")
--end
function Pass_Again(array,card,Pickup)
	if array[1] == "Again" then
	local PA = UiFolder.PlayUi.P_A:Clone()
	local BQ,BE = PA.BQ,PA.BE
	local binding,unbinding = Color3.new(0.141176, 0.141176, 0.141176),Color3.new(0.0509804, 0.0509804, 0.0509804)
	PA.Parent = script.Parent
	local pose,size = PA.Position,PA.Size
	PA.Position += UDim2.new(0,0,size.Y.Scale/2,0)
	PA.Size = UDim2.new(size.X.Scale,0,0.01,0)
	PA.Visible = true
		PA:TweenSizeAndPosition(size,pose,"In",Enum.EasingStyle.Cubic,0.2)
	--UI Start Part
	local inputing = nil
	local lock = false
	local function P_A(input)
		if  input == inputing and inputing ~= nil and lock == false then
			lock = true
			print(inputing)
			local Text
			if inputing == Enum.KeyCode.E or inputing == "E" then
				LocalService:FireServer("Again")
				Text = "Again"
			elseif inputing == Enum.KeyCode.Q or inputing == "Q" then
					LocalService:FireServer("Pass")
					print("Fine")
					Select_Icons(false)
					if Selcon then
						Selcon:Disconnect()
					end
					Selcon = nil
					Text = "Pass"
			end
			BQ.BackgroundColor3 = unbinding
			BE.BackgroundColor3 = unbinding
			
			PA:TweenSizeAndPosition(UDim2.new(PA.Size.X.Scale,0,0.01,0),PA.Position + UDim2.new(0,0,size.Y.Scale/2,0),"In",Enum.EasingStyle.Cubic,0.1)
			task.wait(0.1)
			PA:Destroy()
			task.wait(0.1)
			P_A_Text(Text)
		end
		return nil
	end
	local function ButtonSystem()
			if inputing then
				P_A(inputing)
			end
	end
	Uis.InputBegan:Connect(function(input,bool)
		if bool then return end
		if input.KeyCode == Enum.KeyCode.Q then
			inputing = Enum.KeyCode.Q
			BQ.BackgroundColor3 = binding
			ButtonSystem()
		elseif input.KeyCode == Enum.KeyCode.E then
			inputing = Enum.KeyCode.E
			BE.BackgroundColor3 = binding
			ButtonSystem()
		end
	end)
	BQ.MouseButton1Down:Connect(function()
			inputing = "Q"
			ButtonSystem()
	end)
	BE.MouseButton1Down:Connect(function()
			inputing = "E"
			ButtonSystem()
	end)
	
		Uis.InputEnded:Connect(function(input,bool)
			print(inputing)
			
		end)
	end
	return
end
LocalService.OnClientEvent:Connect(turn)
LocalService.OnClientEvent:Connect(Pass_Again)
mouse.Move:Connect(function()
	if not Drag then return end
	local MousePos = game:GetService("UserInputService"):GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
	local getGUI = plr.PlayerGui:GetGuiObjectsAtPosition(MousePos.X,MousePos.Y)
	if not (table.find(getGUI,Drag) or (mouse.X > Drag.AbsolutePosition.X-20 and mouse.X < Drag.AbsolutePosition.X+Drag.AbsoluteSize.X+20)) then--and not (mouse.X > Drag.AbsolutePosition.X and mouse.X < Drag.AbsolutePosition.X+Drag.AbsoluteSize.X)  then -- 올려진 커서에 Drag중인 카드가 검색되지 않았고 지금 Drag 카드가 있고 드래그 중인 카드 x범위 안에 커서가 없다면.
		Drag = nil -- 현재 할당되 드래그 값 초기화
		Select_Wait = false -- 확신적으로 선택된 것을 나타내는 불값을 초기화
		anchored_Y = nil -- 원래 Y값 초기화
		anchored_X = nil -- 원래 X값 초기화
		offset = nil -- 드래그 Offset값 초기화
		Selecting = false -- 선택 되지 않음으로 값 초기화
		SelsLock = false
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGBBBBBBB")
		Del_Up()
		return
	end
	local size = script.Parent.AbsoluteSize
	if Drag and not Selecting then -- 드래그 카드 가있고 선택 되지 않았다면
		local Mpose = Vector2.new(mouse.X,mouse.Y)
		local NewPose = Mpose + offset
		print((script.Parent.AbsoluteSize.Y/20))
		if NewPose.Y <= anchored_Y-(Uis.TouchEnabled and 15-Card_UpOffset or 45-Card_UpOffset) then
			print("DD")
			Select_Wait = true
			Drag.Position = UDim2.new(0,anchored_X,0,anchored_Y-(Uis.TouchEnabled and 20-Card_UpOffset or 50-Card_UpOffset))
			return
		end
		Selecting = nil
		Select_Wait = false
		NewPose = UDim2.new(0,anchored_X,0,NewPose.Y)
		--print(anchored_Y)
		print("FAAAAAAAAAAALSE")
		
		if anchored_Y  <= NewPose.Y.Offset then
			Drag.Position = UDim2.new(0,anchored_X,0,anchored_Y+Card_UpOffset) -- 20 더하는 이유는 들어 올려진걸 의미 하기 위해
			return
		end
		Drag.Position = NewPose
	end
end)
Uis.InputEnded:Connect(function(object)
	if (object.UserInputType == Enum.UserInputType.MouseButton1 or object.UserInputType == Enum.UserInputType.Touch) and Drag and Selecting == nil then
		if Select_Wait == true then
			Selecting = true
			Turn_Lock = false
			X = nil
			print("Fine")
				Select_Icons(false)
				if Selcon then
				Selcon:Disconnect()
				end
				Selcon = nil
				SelsLock = false
			if not pickup then
			if real.CardNum.Text ~= "ㅡ" then
			    LocalService:FireServer(Select_Card_Object,real:FindFirstChild("CardNum").Text,pickup)
			elseif  real.CardNum.Text == "ㅡ" then
				local Result = 1.5 if tonumber(Card[Select_Card_Object.Name]) - math.floor(tonumber(Card[Select_Card_Object.Name])) == 0.5 then Result = tostring(Card[Select_Card_Object.Name]) end
				LocalService:FireServer(Select_Card_Object,Result,pickup)	
			end
				script.Parent.Sel:ClearAllChildren()
			else
				LocalService:FireServer(real.Object.Value,nil,pickup)
			end
			Finish()
			LocalServicing:Fire({"Sound","Tick"})
			return
		end
		Del_Up()
		Drag = nil
		Select_Wait = false
		anchored_Y = nil
		offset = nil
		Selecting = false
		SelsLock = false
		return
	end
end)
-------------

local inputing = nil
local Ui = nil
local Mobile_Frame = script.Parent.Parent.Mobile.Mobile_MoveButton
function move(Move_Type)
	if not plr:FindFirstChild("CameraCFrame") then
			return
	end
	local CCam = workspace.Camera
	local V_Cf = plr.CameraCFrame
	local Table = plr.Table.Value.Table
	local Height = 3
	local X_CF
	if Move_Type == "Front" then
	    X_CF = CFrame.new(0,1,-3)*CFrame.Angles(math.rad(-30),0,0)
	elseif Move_Type == "Left" then
		X_CF = CFrame.new(-3,1,0)*CFrame.Angles(0,math.rad(90),0)*CFrame.Angles(math.rad(-30),0,0)
    elseif Move_Type == "Right" then
		X_CF = CFrame.new(3,1,0)*CFrame.Angles(0,math.rad(-90),0)*CFrame.Angles(math.rad(-30),0,0)
	end
	Tween(CCam,CFrame.new(Table.Position.X,Table.Position.Y+Table.Size.X/2+Height,Table.Position.Z)*(V_Cf.Value-V_Cf.Value.p)*X_CF)
end
local GameMusic = script.Music.GamePlayMusic
game:GetService("ReplicatedStorage").EventFolder.LocalService.OnClientEvent:Connect(function(Type)
	if Type == "Start" then
		GameMusic:Play()
	if Uis.TouchEnabled == true then wait(2) Mobile_Frame.Visible = true return end
	elseif Type == "End" then
		GameMusic:Stop()
		script.Parent.Parent.intoro.IntroSystem.introMusic:Play()
	if Uis.TouchEnabled == true then Mobile_Frame.Visible = false return end
	end
end)
if Uis.TouchEnabled == true then
	function Falsing(ui,input)
		if inputing == input then
			inputing = nil
			local CCam = workspace.Camera                                                                 
			local V_Cf = plr.CameraCFrame
			Ui.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
			Ui.TextColor3 = Color3.new(1, 1, 1)
			Ui.UIStroke.Color = Color3.new(1, 1, 1)
			Ui = nil
			inputing =nil
			Tween(CCam,V_Cf.Value)
			return true
		end
		ui.BackgroundColor3 = Color3.new(0.741176, 0.741176, 0.741176)
		ui.TextColor3 = Color3.new(0, 0, 0)
		ui.UIStroke.Color = Color3.new(0, 0, 0)
		if Ui then
			Ui.BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471)
			Ui.TextColor3 = Color3.new(1, 1, 1)
			Ui.UIStroke.Color = Color3.new(1, 1, 1)
		end
		return false
	end
	
	Mobile_Frame.Front_Button.MouseButton1Down:Connect(function()
		if Falsing(Mobile_Frame.Front_Button,Enum.KeyCode.W) then
			return
		end
		Ui = Mobile_Frame.Front_Button
		inputing = Enum.KeyCode.W
		move("Front")
	end)
	Mobile_Frame.Left_Button.MouseButton1Down:Connect(function()
		if Falsing(Mobile_Frame.Left_Button,Enum.KeyCode.A) then
			return
		end
		Ui = Mobile_Frame.Left_Button
		inputing = Enum.KeyCode.A
		move("Left")
	end)
	Mobile_Frame.Right_Button.MouseButton1Down:Connect(function()
		if Falsing(Mobile_Frame.Right_Button,Enum.KeyCode.D) then
			return
		end
		Ui = Mobile_Frame.Right_Button
		inputing = Enum.KeyCode.D
		move("Right")
	end)
else
	Uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.W then
			inputing = Enum.KeyCode.W
			move("Front")
		end
	end)
	Uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.A then
			inputing = Enum.KeyCode.A
			move("Left")
		end
	end)
	Uis.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.D then
			inputing = Enum.KeyCode.D
			move("Right")
		end
	end)
end
Uis.InputEnded:Connect(function(input,bool)
	if bool or not plr:FindFirstChild("CameraCFrame") or Uis.TouchEnabled then 
		return end
	local In
	if  input.KeyCode == inputing then
		inputing = nil
		local CCam = workspace.Camera                                                                 
		local V_Cf = plr.CameraCFrame
		Tween(CCam,V_Cf.Value)
	end	
end)
local function leaving(array)
	if array[1] == "Leave" then
		local Type,LeavePlr,PlrNumder = unpack(array)
		if (Select_Card_Object and Select_Card_Object.Parent.Name == LeavePlr.Name) and (not pickup and PlrNumder >= 2 ) then
			if X == true then
				Select_Icons(false)
				if Selcon then
					Selcon:Disconnect()
				end
				Selcon = nil
				SelsLock = false
				
				Finish()	
				
				Del_Up()	
				print("-------------------------------------------------")
				if Began then
					Began:Disconnect()
				end
				X = nil
				turn({"Turn",{0,1,2,3,4,5,6,7,8,9,10,11,"ㅡ"}},Card,pickup) 
				LeftClick:Disconnect()
				RightClick:Disconnect()
				CancelClick:Disconnect()
			end
		end
	end
end

game:GetService("ReplicatedStorage").EventFolder.LocalService.OnClientEvent:Connect(leaving)
