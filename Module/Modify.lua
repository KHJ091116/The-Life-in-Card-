local Runservice = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local debri = game:GetService("Debris")
local localService = game:GetService("ReplicatedStorage"):WaitForChild("EventFolder"):WaitForChild("LocalServicing")
local Turn_Ui = script:WaitForChild("Turn_up")

local MoveTaskArray = {}
local PosTaskArray = {}
local Tiping = {}
local TipingText = ""
local Something = {}

function Something.Tween(Object,Type,Value,Time,coroutined, MoveType) : ()
	if not coroutined then
	local Tweeninfo = TweenInfo.new(
		Time or 1,
		MoveType and Enum.EasingStyle[MoveType] or Enum.EasingStyle.Quad,
		Enum.EasingDirection.InOut,
		0,
		false,
		0
	)
	local pose = {[Type] = Value }
	local Tween = TweenService:Create(Object,Tweeninfo,pose)
	Tween:Play()
	else
		local Tweening = coroutine.create(function()
			local Tweeninfo = TweenInfo.new(
				Time or 1,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.InOut,
				0,
				false,
				0
			)
			local pose = {[Type] = Value }
			local Tween = TweenService:Create(Object,Tweeninfo,pose)
			Tween:Play()
		end)
		coroutine.resume(Tweening)
	end
end
function Something.load(Object,Visibled : boolean)
if Runservice:IsClient() then
	local plr = game:GetService("Players").LocalPlayer
	local mouse = plr:GetMouse()
		localService:Fire({"Sound","Shoot"})
		local ui = Instance.new("ScreenGui",plr.PlayerGui)
		local loadFrame = Instance.new("Frame",ui)
		local corner = Instance.new("UICorner",loadFrame)
		corner.CornerRadius = UDim.new(0,0)
		loadFrame.BorderSizePixel = 0
		loadFrame.Size = UDim2.new(0,0,0,0)
		loadFrame.Position = UDim2.new(0,mouse.X,0,mouse.Y)
		loadFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		Something.Tween(loadFrame,"Position",loadFrame.Position - UDim2.new(1.5,0,1.5,0),0.4)
		Something.Tween(loadFrame,"Size",UDim2.new(3,0,3,0),0.4)
		
		wait(0.4)
		Object.Visible = Visibled
		Something.Tween(loadFrame,"Position",loadFrame.Position + UDim2.new(1.5,0,1.5,0),0.4)
		Something.Tween(loadFrame,"Size",UDim2.new(0,0,0,0),0.4)
		debri:AddItem(loadFrame,0.4)
		debri:AddItem(ui,0.4)
end
end
function Find_Property(object,prop)
	for i,v in pairs(script.Parent:GetDescendants()) do
		local success = pcall(function() local t = object[prop]  end)
    	return success
	end
end
local playing = Instance.new("BindableEvent")
function Something.Tiping(Object,Text,TipingSpeed,Gradient,Coroutined,Unreset,Unsound) : ()
	local Tweening
	local function TimeTween(del,Bool)
			local uiGradient = Object:WaitForChild("UIGradient")
			local keypoints = uiGradient.Color.Keypoints
			local numberValue = Instance.new('NumberValue')

			if Bool then
				numberValue.Value = 0
				Something.Tween(numberValue,"Value",0.4,del or .1)
			else
				numberValue.Value = 0.4
				Something.Tween(numberValue,"Value",0,del or .1)
			end
			Tweening = numberValue.Changed:Connect(function(val)
				uiGradient.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,Color3.new(0, 0, 0));
					ColorSequenceKeypoint.new(val,Color3.new(1, 1, 1));
					ColorSequenceKeypoint.new(1-val,Color3.new(1, 1, 1));
					ColorSequenceKeypoint.new(1,Color3.new(0, 0, 0));
				})
			end)
			wait(del or .1)
			Tweening:Disconnect()
			if not Bool then
				Object.BackgroundTransparency = 1
			end
	end
	local MainEngine
	local Tiped = coroutine.create(function() 
		MainEngine() 
	end)
	local CoroutineFunc = Coroutined and MainEngine or function() coroutine.resume(Tiped) end
	MainEngine = function()
		print("Work")
		local StartTime = tick()
		if Find_Property(Object,"Text") then
			local Tipined = true
			Object.Visible = true
			Object.Text = "" -- 택스트 상태 초기화
			Something.Tween(Object,"TextTransparency",0,0)
			Something.Tween(Object:WaitForChild("UIStroke"),"Transparency",0,0)
			table.insert(Tiping,StartTime)
			local function Stop()
				if Unreset then return end
				table.remove(Tiping,StartTime)-- 바뀌었다면 이전 작성하던거 중지.
				Object.Text = ""-- 초기화
				if Gradient then TimeTween(0,false) end-- 그라데이션 매게 true 라면 그라데이션 트윈 중지.
			end
			playing:Fire()
			if Gradient then TimeTween(nil,true) end
			TipingText = Text
			playing.Event:Connect(function()
				Stop()
				return
			end)
			for i = 1, string.len(Text)  do
				if string.sub(Object.Text,1,i-1) ~= string.sub(Text,1,i-1) then -- 텍스트 내용이 바뀐건지 여부 검사.
					Stop()
					return -- 즉시 중지
				else
				if table.find(Tiping, StartTime) then -- 지금 즉시 중단 상태인지 검사.
					local TipingText = string.sub(Text,i,i) -- 현제 출력 되어야 하는 한글자
					Object.Text = Object.Text..TipingText -- 차례대로 뒤에 입력
					if not Unsound then localService:Fire({"Sound","Tiping"}) end -- 타이핑 소리 출력
					if TipingSpeed ~= 0 then task.wait(TipingSpeed) end -- 글자 출력 속도
				end
			    end
			end
			task.wait(0.5)
			if table.find(Tiping, StartTime)and Object.Text == Text and not Unreset then -- 출력이 잘되었는지 검사
				Something.Tween(Object,"TextTransparency",1,0.2)
				Something.Tween(Object:WaitForChild("UIStroke"),"Transparency",1,0.2)
				wait(.3)
				Object.Text = ""
				Object:WaitForChild("UIStroke").Transparency = 0
				Object.TextTransparency = 0
				if Gradient then TimeTween(nil,false) end
			end
			table.remove(Tiping,StartTime)
		else
			print("[ Text 속성을 가지고 있지않는 오브젝트 입니다. ]")
			return
		end
	end
	CoroutineFunc()
end
function Something.Open(Object,OpenType: string,Visibled : boolean,Delays: number,ChildrenSmooth: boolean,BlacklistObject: {any},BasePS : {any}) : ()
	local WasPose,WasSize = Object.Position,Object.Size
	if OpenType == "Slap" or OpenType == "Child" then
		if ChildrenSmooth == nil or ChildrenSmooth then
		for i , v in pairs(Object:GetChildren()) do
				if not Find_Property(v,"Visible") or (BlacklistObject and table.find(BlacklistObject,v)) or Visibled == v.Visible and not v.Visible then
				if Find_Property(v,"Visible") then v.Visible = false end 
				continue
			end
			local VisibleFunc = coroutine.create(function()
				v.Visible = not Visibled
				if Visibled then wait(0.5+Delays) end
				if v.Name ~= "BookFrame" then
				Something.Open(v,"More",Visibled,0.1)
				else
				Something.Open(v,"DrawUp",Visibled,0.1,false)
				end
			end)
			coroutine.resume(VisibleFunc)
			end
		end
		if Visibled and OpenType ~= "Child" then
		Object.Size = UDim2.new(0,3,0,0)
		Object.Visible = true
		Something.Tween(Object,"Size",UDim2.new(0,3,WasSize.Y.Scale,0),0.5,false)
		wait(0.5)
		Something.Tween(Object,"Size",WasSize,Delays,false)
		wait(Delays)
		Object.Size = WasSize
		elseif OpenType ~= "Child" then
		Object.Visible = true
		wait(0.1)
		Something.Tween(Object,"Size",UDim2.new(0,3,WasSize.Y.Scale,0),Delays,false)
		wait(Delays)
		Something.Tween(Object,"Size",UDim2.new(0,0,0,0),0.5,false)
		wait(0.5)
		wait()
		Object.Visible = false
		Object.Size = WasSize
		end
	elseif OpenType == "More" then
		print("Work")
		if ChildrenSmooth == nil or ChildrenSmooth then
		for i , v in pairs(Object:GetChildren()) do
			if not Find_Property(v,"Visible") or (BlacklistObject and table.find(BlacklistObject,v)) then
				continue
			end
			local VisibleFunc = coroutine.create(function()
				v.Visible = false
				wait(Delays)
				v.Visible = true
			end)
			coroutine.resume(VisibleFunc)
		end
		end
		if  Visibled then
		Object.Size = WasSize - UDim2.new(0,15,0,15)
		Object.Position = WasPose + UDim2.new(0,5,0,5)
		Object.Visible = true
		Something.Tween(Object,"Size",WasSize,Delays,true)
		Something.Tween(Object,"Position",WasPose,Delays,true)
		else
			Object.Visible = true
			Something.Tween(Object,"Size",WasSize - UDim2.new(0,15,0,15),Delays,true)
			Something.Tween(Object,"Position",WasPose + UDim2.new(0,5,0,5),Delays,true)
			wait(Delays)
			Object.Visible = false
			Object.Position = WasPose
			Object.Size = WasSize
		end
	elseif OpenType == "DrawUp" then
		if ChildrenSmooth == nil or ChildrenSmooth then
		for i , v in pairs(Object:GetChildren()) do
			if not Find_Property(v,"Visible") then
				continue
			end
			local VisibleFunc = coroutine.create(function()
				v.Visible = false
				wait(Delays)
				v.Visible = true
			end)
			coroutine.resume(VisibleFunc)
		end
		end
		if  Visibled then
			Object.Size = UDim2.new(WasSize.X.Scale,0,0,0)
			Object.Position = WasPose + UDim2.new(0,0,WasSize.Y.Scale,0) 
			Object.Visible = true
			Something.Tween(Object,"Size",WasSize,Delays,true)
			Something.Tween(Object,"Position",WasPose,Delays,true)
		else
			Object.Visible = true
			Something.Tween(Object,"Size",UDim2.new(WasSize.X.Scale,0,0,0),Delays,true)
			Something.Tween(Object,"Position",WasPose + UDim2.new(0,0,WasSize.Y.Scale,0),Delays,true)
			wait(Delays)
			wait()
			Object.Visible = false
			Object.Position = WasPose
			Object.Size = WasSize
		end
	end
end
local Waiting_List = {}
function Something.Slide(Frame,Del,par)
	if not Frame or Frame.ClassName~="Frame" or table.find(Waiting_List,par or Frame.Parent)then return"notFunc"end 
	local Parent = par or  Frame.Parent
	local Delay_ = Del or 1
	table.insert(Waiting_List,Parent)
	Frame.Parent = Parent
	Frame.Position = UDim2.new(1,0,0,0)
	Frame.Size = UDim2.new(1,0,1,0)
	Frame.Visible = true
	Something.Tween(Frame,"Position",UDim2.new(0,0,0,0),Delay_)
	for i , v in pairs(Parent:GetChildren()) do
		if v.ClassName == "Frame" then
			if v.Position.X.Scale < 0 or v == Frame then continue end
			local Movement = coroutine.create(function()
				Something.Tween(v,"Position",UDim2.new(-v.Size.X.Scale,0,0,0),Delay_)
				wait(Delay_)
				if v.Position.X.Scale < 0 then
					v.Visible = false
				end
			end)
			coroutine.resume(Movement)
			
		end
	end
	wait(Delay_)
	table.remove(Waiting_List,table.find(Waiting_List,Parent))
end
function Something.TurnUp(Plr)
	local UiClone = Turn_Ui:Clone()
	local Full_Frame,Bar_Frame,Stick,CardB,CardW = UiClone:WaitForChild("Main"),UiClone:WaitForChild("Main"):WaitForChild("Main_Frame"),UiClone:WaitForChild("Main"):WaitForChild("Main_Frame"):WaitForChild("Movement"),UiClone:WaitForChild("Main"):WaitForChild("Main_Frame"):WaitForChild("Move_CardB"),UiClone:WaitForChild("Main"):WaitForChild("Main_Frame"):WaitForChild("Move_CardW")
	UiClone.Parent = Plr.PlayerGui
	--Start_Engine
	Full_Frame.BackgroundTransparency = 1
	Bar_Frame.Size = UDim2.new(1,0,0,0)
	Bar_Frame.Position = UDim2.new(0,0,0.25,0)
	Stick.Size = UDim2.new(0,0,0.025,0)
	Stick.Position = UDim2.new(0.5,0,0.537,0)
	Stick.Visible = false
	CardB:WaitForChild("CardBar").Position = UDim2.new(-CardB:WaitForChild("CardBar").Size.X.Scale,0,0,0)
	CardW:WaitForChild("CardBar").Position = UDim2.new(1,0,0,0)
	Stick:WaitForChild("Command_Visible"):WaitForChild("Command").Position = UDim2.new(0,0,1,0)
	Stick:WaitForChild("Decommand_Visible"):WaitForChild("Decommand").Position = UDim2.new(0,0,-Stick:WaitForChild("Decommand_Visible"):WaitForChild("Decommand").Size.Y.Scale,0)
	--Finished
	localService:Fire({"Sound","Turn"})
	Something.Tween(Full_Frame,"BackgroundTransparency",0.85,.1)
	Something.Tween(Bar_Frame,"Size",UDim2.new(1,0,0.15,0),0.2)
	Something.Tween(Bar_Frame,"Position",UDim2.new(0,0,0.175,0),.2)
	wait(0.2)
	Stick.Visible = true
	Something.Tween(Stick,"Size",UDim2.new(0.202, 0,0.025, 0),.1)
	Something.Tween(Stick,"Position",UDim2.new(0.399,0,0.525,0),.1)
	wait(0.1)
	Something.Tween(Stick:WaitForChild("Command_Visible"):WaitForChild("Command"),"Position",UDim2.new(0,0,1-Stick:WaitForChild("Command_Visible"):WaitForChild("Command").Size.Y.Scale,0),.2)
	Something.Tween(Stick:WaitForChild("Decommand_Visible"):WaitForChild("Decommand"),"Position",UDim2.new(0,0,0,0),.2)
	Something.Tween(CardB:WaitForChild("CardBar"),"Position",UDim2.new(0,10,0,0),.2)
	Something.Tween(CardW:WaitForChild("CardBar"),"Position",UDim2.new(1-CardW:WaitForChild("CardBar").Size.X.Scale,-10,0,0),.2)
	wait(1)
	Something.Tween(Stick:WaitForChild("Command_Visible"):WaitForChild("Command"),"Position",UDim2.new(0,0,1,0),.2)--
	Something.Tween(Stick:WaitForChild("Decommand_Visible"):WaitForChild("Decommand"),"Position",UDim2.new(0,0,-Stick:WaitForChild("Decommand_Visible"):WaitForChild("Decommand").Size.Y.Scale,0),.2)
	Something.Tween(CardB:WaitForChild("CardBar"),"Position",UDim2.new(-CardB:WaitForChild("CardBar").Size.X.Scale,0,0,0),.2)
	Something.Tween(CardW:WaitForChild("CardBar"),"Position",UDim2.new(1,0,0,0),.2)
	wait(0.2)
	Something.Tween(Stick,"Size",UDim2.new(0,0,0.025,0),.1)--
	Something.Tween(Stick,"Position",UDim2.new(0.5,0,0.537,0),.1)
	wait(0.05)
	Something.Tween(Bar_Frame,"Size",UDim2.new(1,0,0,0),0.1)--
	Something.Tween(Bar_Frame,"Position",UDim2.new(0,0,0.25,0),.1)--
	Something.Tween(Full_Frame,"BackgroundTransparency",1,.1)
	wait(0.1)
	UiClone:Destroy()
end--
--type TaskArray = {proparty:string, direction:number, maxpoint:number, lowpoint:number}
function Something.UiMove(Ui : Instance?,Proparty : string,MaxPoint : number,LowPoint : number, SpeedVal : number, MoveType : string) : ()
	if Proparty == "Position" then
		PosTaskArray[Ui] = {proparty = Proparty, movetype = MoveType, IsMove = false, direction = 1, maxpoint = MaxPoint, lowpoint = LowPoint, speed = SpeedVal}
	elseif Proparty ~= "StopIt" then
		MoveTaskArray[Ui] = {originvalue = Ui[Proparty], proparty = Proparty, direction = 1, maxpoint = MaxPoint, lowpoint = LowPoint, speed = SpeedVal}
	else
		-- StopSystem
		PosTaskArray[Ui] = nil
		MoveTaskArray[Ui] = nil
		print(PosTaskArray)
		print(MoveTaskArray)
	end
end
Run = Runservice.Heartbeat:Connect(function(del)	
	for Ui, INF in pairs(MoveTaskArray) do
		if not Ui then table.remove(MoveTaskArray,Ui) end
			
		if INF.direction == 1 then
			Ui[INF.proparty] += INF.maxpoint * INF.speed * del
		else-- 0
			Ui[INF.proparty] += INF.lowpoint * INF.speed * del
		end
		if Ui[INF.proparty] >= (INF.originvalue + INF.maxpoint) then
			INF.direction = 0
		elseif Ui[INF.proparty] <= (INF.originvalue + INF.lowpoint) then
			INF.direction = 1
		end
	end
	for Ui, INF in pairs(PosTaskArray) do
		if not Ui then table.remove(MoveTaskArray,Ui) end

		if INF.IsMove then continue end
		print("position")
		INF.IsMove = true
		local MovePosition = coroutine.create(function()
			Something.Tween(Ui, INF.proparty, INF.maxpoint, INF.speed, INF.movetype)
			task.wait(INF.speed)
			Something.Tween(Ui, INF.proparty, INF.lowpoint, INF.speed, INF.movetype)
			task.wait(INF.speed)
			INF.IsMove = false
		end)
		coroutine.resume(MovePosition)
	end
end)
return Something 
