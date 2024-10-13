local Service_Event = game:GetService("ReplicatedStorage"):WaitForChild("EventFolder"):FindFirstChild("LocalService")
local modify = require(game:GetService("ReplicatedStorage"):WaitForChild("Modify"))
local ModelFolders = script:FindFirstChild("RoomModels")
local allCardNumber = 26
local Smooth = 10
local PlayTimes = 0
local WinRating = 15
local BaseGetCoint = 100
local TweenService = game:GetService("TweenService")
function Tween(ob : Instance,pse : CFrame,Time : number)
		local Tweeninfo = TweenInfo.new(
			Time,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.InOut,
			0,
			false,
			0
		)
		local pose = {CFrame = pse}
		local TweenMove = TweenService:Create(ob,Tweeninfo,pose)
		TweenMove:Play()
		TweenMove.Completed:Wait()
		return true
end
local function cloneValue(v)
local C
C = v
return C
end
local OriginPosition = CFrame.new(Vector3.new(0,20,0))
local function RoomPositioning(PlayerAmount : number) : Instance
	local Room = ModelFolders:FindFirstChild(PlayerAmount.."Players"):FindFirstChild("RoomModel"):Clone()
	Room.Parent = workspace
	if not Room then print("Can't Loading Table") return end
	
	Room:PivotTo(OriginPosition * CFrame.new(0,OriginPosition.Y * PlayTimes,0))
	return Room:FindFirstChild("Rovinch_Table")
end
function GiveCard(mainFolder,plr,times,Num,Card,Table)
	local CardFolder = mainFolder:FindFirstChild("Cards")
	local PlrFolder = mainFolder:FindFirstChild(plr.Name)
	local Own_Cards = {}
	local giveTime = 0.05
	local _give_Save_Time_ = 0.1
	for i=1,times do
		local RCard = CardFolder:GetChildren()[math.random(1,#CardFolder:GetChildren())]
		local Xpse = 0
		local Down,Up = nil,nil
		Service_Event:FireClient(plr,{"CardNum",RCard:FindFirstChild("Text"):FindFirstChild("SF"):FindFirstChild("Number"),Card[RCard.Name]})
		RCard.Parent = workspace

		local CardBW = RCard:GetAttribute("CardColor")
		for i,v in pairs(PlrFolder:GetChildren()) do
			local vLevel = Card[v.Name]
			if Card[RCard.Name] == "ㅡ"then
				local RC = PlrFolder:GetChildren()[math.random(1,#PlrFolder:GetChildren())]
				local RCLevel = Card[RC.Name]
				if math.random(1,2) == 1 then
					local RN
					repeat
						RN = math.random(0,11)
					until not table.find(Card,RN)
					Card[RCard.Name] = RN+0.5
				else
					local RN
					repeat
						RN = math.random(0,11)
					until not table.find(Card,RN)
					Card[RCard.Name] = RN-0.5
				end
			end
			local Cardlevel = Card[RCard.Name]
			if vLevel>=Cardlevel then
				if vLevel==Cardlevel and CardBW == true then
					local TweemSpawn = coroutine.create(Tween)
					coroutine.resume(TweemSpawn,v,v.CFrame * CFrame.new(0,0,-(v.Size.Z/2)),giveTime)
					if Up == nil then
						Up = v
						continue
					end
					if Card[Up.Name] <= vLevel then
						Up = v
					end
					continue
				end
				local TweemSpawn = coroutine.create(function()
					v:SetAttribute("IsMove",true)
					Tween(v,v.CFrame * CFrame.new(0,0,v.Size.Z/2),giveTime)
					v:SetAttribute("IsMove",false)
				end)
				coroutine.resume(TweemSpawn)
				if Down == nil then
					Down = v
					continue
				end
				if Card[Down.Name] >= vLevel then
					if Card[Down.Name] == vLevel then
						if v:GetAttribute("CardColor") == false then
							Down = v
						else
							continue
						end
					end
					Down = v
				end
			elseif vLevel<=Cardlevel then
				if vLevel==Cardlevel and CardBW == false then
					local TweemSpawn = coroutine.create(function()
						v:SetAttribute("IsMove",true)
						Tween(v,v.CFrame * CFrame.new(0,0,v.Size.Z/2),giveTime)
						v:SetAttribute("IsMove",false)
					end)
					coroutine.resume(TweemSpawn)
					if Down == nil then
						Down = v
						continue
					end
					if Card[Down.Name] >= vLevel then
						Down = v
					end
					continue
				end
				local TweemSpawn = coroutine.create(function()
					v:SetAttribute("IsMove",true)
					Tween(v,v.CFrame * CFrame.new(0,0,-(v.Size.Z/2)),giveTime)
					v:SetAttribute("IsMove",false)
				end)
				coroutine.resume(TweemSpawn)
				if Up == nil then
					Up = v
					continue
				end
				if Card[Up.Name] <= vLevel then
					if Card[Up.Name] == vLevel then
						if v:GetAttribute("CardColor") == true then
							Up = v
						else
							continue
						end
					end
					Up = v
				end
			end
		end
		local Offset
		if Down then
			repeat
				task.wait()
			until not Down:GetAttribute("IsMove")
			Xpse =  -Down.Size.Z
			Offset = Down
		elseif Up then
			repeat
				task.wait()
			until not Up:GetAttribute("IsMove")
			Xpse = Up.Size.Z
			Offset = Up
		end
		RCard.Parent = PlrFolder
		if Down or Up then
			local basePose = Table:FindFirstChild("Pade"..Num)
			local BPose = cloneValue(Table:FindFirstChild("Pade"..Num).CFrame)
			local Rotate = BPose - BPose.p
			local See = 0
			local fixPose = CFrame.new(Vector3.new(Offset.CFrame.X,BPose.Y+RCard.Size.Y/2,Offset.CFrame.Z)) * Rotate * CFrame.Angles(math.rad(180),0,math.rad(180))
			if Offset.Text.SF.Number.Text ~= "14" then
				See = -(Offset.Size.Y/2-Offset.Size.X)
			end
			table.insert(Own_Cards,RCard)
			Service_Event:FireClient(plr,{"Sound","GivingCard"})
			Tween(RCard,fixPose * CFrame.new(See,0,Xpse),0.2)
		else
			if Card[RCard.Name] == "ㅡ" then
				Card[RCard.Name] = math.random(0,11)+0.5
			end
			table.insert(Own_Cards,RCard)
			Service_Event:FireClient(plr,{"Sound","GivingCard"})
			Tween(RCard,Table:FindFirstChild("Pade"..Num).CFrame*CFrame.new(0,RCard.Size.Y/2,Xpse) * CFrame.Angles(math.rad(180),0,math.rad(180)),0.2)
		end
		Service_Event:FireClient(plr,{"Effectering_Card",RCard})
		Up = nil
		Down = nil
		Offset = nil
		wait(giveTime)
	end
	return Own_Cards
end
function Leave()
	
end
function clonetable(t)
	local c = {}
	for i, v in pairs(t)do
		if type(v) == "table" then
			c[i] = clonetable(v)
		else
			c[i] = v
		end
	end
	return c
end
function settingCard(W,B,Table,plrs)
	local num = 0
	local Card = {}
	local mainFolder = Instance.new("Folder",workspace)
	mainFolder.Name = "mainfolder"
	for i,v in pairs(plrs) do
		local plrFolder = Instance.new("Folder",mainFolder)
		plrFolder.Name = v.Name
	end
	local CardFolder = Instance.new("Folder",mainFolder)
	CardFolder.Name = "Cards"
		for m=1,allCardNumber do
			if m < 1+allCardNumber/2 and #W ~= 0 then
				local R = math.random(1,#W)
				local CloneCard = game:GetService("ServerScriptService"):FindFirstChild("WCard"):Clone()
				CloneCard.Name = CloneCard.Name .. m
				CloneCard.Parent = CardFolder
				Card[CloneCard.Name] = W[R]
				table.remove(W,R)
				if m < 7 then 
				CloneCard.CFrame = Table:FindFirstChild("Table"):FindFirstChild("PlatePose").WorldCFrame * CFrame.new(0,-(CloneCard.Size.Y*2.5)+CloneCard.Size.Y*(math.ceil((m)/6)),-(CloneCard.Size.Z*2.5)+((CloneCard.Size.Z* m-CloneCard.Size.Z)))
				elseif m > 6 then
				CloneCard.CFrame = Table:FindFirstChild("Table"):FindFirstChild("PlatePose").WorldCFrame * CFrame.new(0,-(CloneCard.Size.Y*2.5)+CloneCard.Size.Y*(math.ceil((m)/6)),-(CloneCard.Size.Z*2.5)+(CloneCard.Size.Z* ((m-1)%6)))
				end
				--CloneCard.Position += Vector3.new(0,-(CloneCard.Size.Y+CloneCard.Size.Y/2),-(CloneCard.Size.Z*2+CloneCard041.Size.Z/2))
				num += 1
			elseif m > allCardNumber/2 and #B ~= 0 then
			    local R = math.random(1,#B)
				local CloneCard = game:GetService("ServerScriptService"):FindFirstChild("BCard"):Clone()
			    CloneCard.Name = CloneCard.Name .. m
				CloneCard.Parent = CardFolder
				CloneCard.Parent = CardFolder
				Card[CloneCard.Name] = B[R]
			    table.remove(B,R)
				CloneCard.CFrame = Table:FindFirstChild("Table"):FindFirstChild("PlatePose").WorldCFrame * CFrame.new(0,-(CloneCard.Size.Y*2.5)+CloneCard.Size.Y*(math.ceil((m)/6)),-(CloneCard.Size.Z*2.5)+(CloneCard.Size.Z* ((m-1)%6)))
				num += 1
			end
		end
		return Card,mainFolder
end
local function TurnImage(Table : instance)
end
function turn(plr,Card,pick,MF)
	print("DAAA")
   if not pick then
		local M = {}
		for i=0, 12 do
			if i == 12 then
				table.insert(M,"ㅡ")
				continue
			end
			table.insert(M,tostring(i))
		end
		MF = M
		TurnImage()
   end
   print("계산된 카드")
   print(MF)
   Service_Event:FireClient(plr,{"Turn",MF},Card,pick)
end

game:GetService("ServerScriptService"):WaitForChild("Booting"):FindFirstChild("Starting").Event:Connect(function(Plrs)
	local Something
	local GuessEventInfo
	local GuessNum
	local Selecting
	local user_Points = {}
	local Loser = {}
	local Winner
	local LeaveEvent
	--Checking
	PlayTimes += 1
	local GameTable = RoomPositioning(#Plrs)
	local WCardNumber = {0,1,2,3,4,5,6,7,8,9,10,11,"ㅡ"}
	local BCardNumber = {0,1,2,3,4,5,6,7,8,9,10,11,"ㅡ"}
	local Card,mainfolder = settingCard(clonetable(WCardNumber),clonetable(BCardNumber),GameTable,Plrs)
	print(Card)
	local function PlrArrayToFire(PlrArray : {Instance}|Instance, INF : {any}) : ()
		if typeof(PlrArray) == "table" then
		for i, v in pairs(PlrArray) do
			if v then
				Service_Event:FireClient(v,unpack(INF))
			end
		end
		elseif typeof(PlrArray) == "Instance" then
			Service_Event:FireClient(PlrArray,unpack(INF))
		else
			print("NotFire..")
			print("Type Error : "..typeof(PlrArray))
		end
	end
	local function getPoint(plr,Type,Point)
		if plr then
			if Type == "Correct" then
				user_Points[plr.Name]["Correct"] += Point or 1
			elseif Type == "Fail" then
				user_Points[plr.Name]["Fail"] += Point or 1
			elseif Type == "Eat" then
				user_Points[plr.Name]["Eat"] += Point or 1
			elseif Type == "Again" then
				user_Points[plr.Name]["Again"] += Point or 1
			elseif Type == "Pass" then
				user_Points[plr.Name]["Pass"] += Point or 1
			elseif Type == "ReBuilding" then
				user_Points[plr.Name] = {["Correct"] = 0;
				                   		 ["Fail"] = 0;
										 ["Eat"] = 0;
										 ["Again"] = 0;
										 ["Pass"] = 0;
										 ["Bonus!"] = 2;
										 ["Rating"] = -10}
			end
		end
		print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
		print(user_Points)
	end
	local function gameOver(Type,plr)
		local Coint = plr.Stats.Coint
		local Rating = plr.Stats.Rating
		if Type == "AllLeave" then
			Service_Event:FireClient(plr,{"Cam",Vector3.new(0,0,0)})
			LeaveEvent:Disconnect()
			LeaveEvent = nil
		elseif Type == "Loser" then
			table.insert(Loser,plr.Name)
			Service_Event:FireClient(plr,"End")
			Service_Event:FireClient(plr,{"Cam",plr.CameraCFrame.Value})
			plr:WaitForChild("CameraCFrame"):Destroy()
			plr:WaitForChild("Table"):Destroy()
			PlrArrayToFire(Plrs,{"BlackOut",plr.UserId})
			Service_Event:FireClient(plr,"Loser",{user_Points[plr.Name]})
			for i, v in pairs(user_Points[plr.Name]) do
				 Coint.Value += v*7
				 print(v)
			end
			print(Coint.Value)
			Coint.Value += BaseGetCoint
			Rating.Value += user_Points[plr.Name]["Rating"]
		elseif Type == "Winner" then
			print(Loser,#Plrs)
			Winner = plr
			Service_Event:FireClient(plr,"End")
			user_Points[plr.Name]["Rating"] = WinRating
			Service_Event:FireClient(plr,"Winner",{user_Points[plr.Name]})
			for i, v in pairs(user_Points[plr.Name]) do
				Coint.Value += v*7
				print(v)
			end
			print(Coint.Value)
			Coint.Value += BaseGetCoint
			Rating.Value += user_Points[plr.Name]["Rating"]
			Service_Event:FireClient(plr,{"Cam",plr.CameraCFrame.Value})
			plr:WaitForChild("CameraCFrame"):Destroy()
			plr:WaitForChild("Table"):Destroy()
			Service_Event:FireClient(plr,"End")
			LeaveEvent:Disconnect()
			LeaveEvent = nil
		end
	end
	local function Lost(plr)
		local SaveCard = {}
		for i,v in pairs(mainfolder:FindFirstChild(plr.Name):GetChildren()) do
			if v:GetAttribute("See") == false then
				table.insert(SaveCard,v)
				print("SAVE")
			end
		end
		print(#SaveCard)
		if #SaveCard == 0 then
		gameOver("Loser",plr)
		print("LOSE : "..plr.Name)
		end
		print(#Plrs , #Loser)
		if #Plrs-1 == #Loser then
			local winner
			for i, v in pairs(Plrs) do
				if not v then
					continue
				end
				if not table.find(Loser,v.Name) then
					winner = v
				end
			end
			print("WIN : "..winner.Name)
			gameOver("Winner",winner)
		end 
	end
	local function SeeCard(plr,Object,CardNum,F_P)
		Service_Event:FireClient(plr,{"Sound","FailSound"})
		if tonumber(CardNum) ~= nil then
			if CardNum - math.floor(CardNum) == 0.5 then
				CardNum = "ㅡ"
			end
		end
		Object:SetAttribute("See",true)
		Object:FindFirstChild("Text"):FindFirstChild("SF"):FindFirstChild("Number").Text = CardNum
		Tween(Object,Object.CFrame * CFrame.new(Object.Size.Y/2-Object.Size.X,-(Object.Size.Y/2-Object.Size.X/2),0) * CFrame.Angles(0,0,math.rad(-92)),0.2)
		print(plr,F_P)
		if F_P ~= nil then
			if plr and F_P then
			getPoint(plr,"Correct")
			end
			Lost(F_P)
		end
		if F_P == nil then
			getPoint(plr,"Fail")
			Lost(plr)
		end

	end
	
	local function again(plr,Own)
	Selecting = plr
	Something = plr
	
	print("AAAAAAAAAAAAAAAAAAAAAA")
	local M = {}
	for i=0, 12 do
		if i == 12 then
			table.insert(M,"ㅡ")
			continue
		end
		table.insert(M,tostring(i))
	end
	Service_Event:FireClient(plr,{"Again",M},Card,false)
	--print("again Sel : ")
	--print(Something)
	repeat
         task.wait()
	until Something ~= plr
	--print("Select : ")
	--print(Something)
		if Something == "Again" then
			getPoint(plr,"Again")
			turn(plr,Card,false,mainfolder:FindFirstChild(plr.Name))
			Selecting = plr
			Something = plr
			repeat 
				wait()
			until Selecting ~= plr
			if Selecting ~= nil then
		   -- print("Again")
			local LosePlr = game:GetService("Players"):FindFirstChild(Selecting.Parent.Name)
			SeeCard(plr,Selecting,tostring(Card[Selecting.Name]),LosePlr)
			if Winner then
				Service_Event:FireClient(plr,{"Text","Youwon"})
				return
			end
			PlrArrayToFire(Plrs,{{"Guess",{plr.UserId,game:GetService("Players"):FindFirstChild(Selecting.Parent.Name).UserId},Card[Selecting.Name] % 1 == 0.5 and "Joker" or tostring(Card[Selecting.Name]),true}})
			if not table.find(Loser,LosePlr.Name) then
				Service_Event:FireClient(LosePlr,{"Text","Oops"})
			end
			Service_Event:FireClient(plr,{"Text",math.random(1,2) == 1 and "WoW" or "Solve"})
			Selecting = plr
			Something = plr
			task.wait(1.2)
			again(plr,Own)
			elseif Own then
				--print("Own See")
				
				print(Own)
				print(Own[1]:GetAttribute("See"))
				Selecting = plr
				Something = plr
				Service_Event:FireClient(plr,{"Text","Oops"})
				if Own[1]:GetAttribute("See") == false then
					SeeCard(plr,Own[1],tostring(Card[Own[1].Name]),game:GetService("Players"):FindFirstChild(Selecting.Parent.Name))
				else
					local Behind = {}
					for i, v in pairs(mainfolder:FindFirstChild(plr.Name):GetChildren())  do
						if v:GetAttribute("See") == false then
							table.insert(Behind,v)
						end
					end
					if #Behind > 1 then
						Selecting = plr
						Something = plr
						turn(plr,Card,true,mainfolder:FindFirstChild(plr.Name))
						repeat 
							wait(2)
						until Selecting ~= plr 
						SeeCard(plr,Selecting,tostring(Card[Selecting.Name]),nil)
					else
						SeeCard(plr,Behind[1],tostring(Card[Behind[1].Name]),nil)
					end
				end
				PlrArrayToFire(Plrs,{{"Guess",{plr.UserId,game:GetService("Players"):FindFirstChild(GuessEventInfo.Parent.Name).UserId},tonumber(GuessNum)  % 1 == 0.5 and "Joker" or GuessNum,false}})
			else 
				Service_Event:FireClient(plr,{"Text","Oops"})
				local Behind = {}
				for i, v in pairs(mainfolder:FindFirstChild(plr.Name):GetChildren())  do
					if v:GetAttribute("See") == false then
						table.insert(Behind,v)
					end
				end
				if #Behind > 1 then
					Selecting = plr
					Something = plr
					turn(plr,Card,true,mainfolder:FindFirstChild(plr.Name))
					repeat 
						wait()
					until Selecting ~= plr 
					SeeCard(plr,Selecting,tostring(Card[Selecting.Name]),nil)
				else
					SeeCard(plr,Behind[1],tostring(Card[Behind[1].Name]),nil)
				end
				PlrArrayToFire(Plrs,{{"Guess",{plr.UserId,game:GetService("Players"):FindFirstChild(GuessEventInfo.Parent.Name).UserId},tonumber(GuessNum) % 1 == 0.5 and "Joker" or GuessNum,false}})
			end
print(Own)
		end
		getPoint(plr,"Pass")
		--print("PASS")
	end
	-- 나갔을때 카드 보여지게 정리 그리고 나갔을때 플레이어가 혼자라면 승리 되게 하는 시스탬
	spawn(function()
		task.wait(1)
		PlrArrayToFire(Plrs,{"Guide",Plrs})
	end)
	
	LeaveEvent = game:GetService("Players").PlayerRemoving:Connect(function(plr)
		if table.find(Plrs,plr) and not Winner then -- 게임 참여자 인지 검토
		if Selecting == plr then -- 지금 나간 플레이어 순서인지 검토
		Selecting = nil -- 나간 플레이어 순서 무시 시키기
		end
		Plrs[table.find(Plrs,plr)] = nil
		table.insert(Loser,plr.Name)
		print("상황 검토 {")
		print(#Plrs)
		print(#Loser)
		print((#Plrs - #Loser))
		print("}")
		if (#Plrs - #Loser) <= 1 then -- 플레이어가 나갔을 때 혼자 라면
			for i,v in pairs(Plrs) do if v ~= nil then PlrArrayToFire(v,{"BlackOut",plr.UserId}) gameOver("Winner",v)end end -- 남은 플레이어 승자
		end
		for i,v in pairs(Plrs) do
			Service_Event:FireClient(v,{"Leave",plr,#Plrs})
		end
		for i, v in pairs(mainfolder:FindFirstChild(plr.Name):GetChildren()) do
			if v:GetAttribute("See") == false then
				local Text = Card[v.Name]
				if tonumber(Card[v.Name]) ~= nil then
					if Card[v.Name] - math.floor(Card[v.Name]) == 0.5 then
						Text = "ㅡ"
					end
				end
				v:SetAttribute("See",true)
				v:FindFirstChild("Text"):FindFirstChild("SF"):FindFirstChild("Number").Text = Text
				Tween(v,v.CFrame * CFrame.new(v.Size.Y/2-v.Size.X,-(v.Size.Y/2-v.Size.X/2),0) * CFrame.Angles(0,0,math.rad(-92)),0.2)	
			end
		end
		end
	end)
	-- 카드 코루틴으로 주는 부분 ㅎㅎ
	local Times = 0
	for i, Pade in pairs(GameTable:GetChildren()) do -- 플레이어 아바타 움직임
		if string.sub(Pade.Name,1,4) ==  "Pade" then
			Times += 1
			if #Plrs  >= tonumber(string.sub(Pade.Name,-1,-1)) then
				Pade:FindFirstChild("PlayerEmotion").Decal.Transparency = 0
				Pade:FindFirstChild("PlayerEmotion").Arm1.Decal.Transparency = 0
				Pade:FindFirstChild("PlayerEmotion").Arm2.Decal.Transparency = 0
			end
			local Origin = Pade:FindFirstChild("PlayerEmotion").Position
			local A1_Origin = Pade:FindFirstChild("PlayerEmotion"):FindFirstChild("Arm1").Position
			local A2_Origin = Pade:FindFirstChild("PlayerEmotion"):FindFirstChild("Arm2").Position
			local move = coroutine.create(function()
				for count=1, math.huge do
					if not Pade then 
						return
					end
				Pade:FindFirstChild("PlayerEmotion").Position = Origin + Vector3.new(0,count%2 == 1 and -0.2 or 0.2,0)
				Pade:FindFirstChild("PlayerEmotion"):FindFirstChild("Arm1").Position = A1_Origin + Vector3.new(0,count%2 == 1 and -0.2 or 0.2,0)
				Pade:FindFirstChild("PlayerEmotion"):FindFirstChild("Arm2").Position = A2_Origin + Vector3.new(0,count%2 == 1 and -0.2 or 0.2,0)
				wait(.7)
			end
			end)
			coroutine.resume(move)
		end
	end
	for i, v in pairs(Plrs) do
		if v then
			getPoint(v,"ReBuilding")
			if not v:FindFirstChild("CameraCFrame") then
				local CF_V = Instance.new("CFrameValue",v)
				CF_V.Name = "CameraCFrame"
				CF_V.Value = GameTable:FindFirstChild("Origin_Positions"):FindFirstChild("Pose"..i).WorldCFrame
				local OB_V = Instance.new("ObjectValue",v)
				OB_V.Name = "Table"
				OB_V.Value = GameTable
			end
			Service_Event:FireClient(v,{"Cam",GameTable:FindFirstChild("Origin_Positions"):FindFirstChild("Pose"..i).WorldCFrame})
			Service_Event:FireClient(v,"Start")
		else
			Leave(Plrs)
		end
	end
	wait(2)
	PlrArrayToFire(Plrs,{"Set_Player",Plrs})
	wait(1)
	for i,v in pairs(Plrs) do
		if v then
			local TweemSpawn = coroutine.create(GiveCard)
			wait(1)
			coroutine.resume(TweemSpawn,mainfolder,v,4,i,Card,GameTable) -- 시간 단축을 위해 코루틴 사용
		else -- 플레이어가 존재 하지 않을 때
			--print(v)
			Leave(Plrs)
		end
	end
	wait(1.5)--giving Time / 주는 시간
	---------------------------------------------------------------------Game System--------------------------------------------------------------------------
	-- 게임 시작 부분
	repeat
	for i,v in pairs(Plrs) do
		-- 탈락된 사람인지 아닌지 구분
		if table.find(Loser,v.Name) or v == nil then
			continue
		elseif Winner then
			PlrArrayToFire(Plrs,{"Reset_Player"})
				Plrs = nil
				Loser = nil
				Winner = nil
				user_Points = nil
        GuessEventInfo = nil
        GuessNum = nil
			return
		end
		PlrArrayToFire(Plrs,{"Up_Player",v.UserId})
		if v and #mainfolder:FindFirstChild(v.Name):GetChildren() > 0 then
		local Own_Card -- 방금 받은 카드(틀리면 이카드 보여 지게 하기 위해 변수 저장)
		if #mainfolder:FindFirstChild("Cards"):GetChildren() > 0 then -- 줄 카드 있는지 확인
		Own_Card = GiveCard(mainfolder,v,1,i,Card,GameTable) -- 줌(준 카드 반환)
		end
		-- 초기화 변수
		Selecting = v
		Something = v
		
		turn(v,Card,false,mainfolder:FindFirstChild(v.Name)) -- 
		local TurnUi = coroutine.create(function()
			modify.TurnUp(v) -- 이거 자기턴 Ui 뜨게
		end)
		coroutine.resume(TurnUi)-- 시작 Ui 불러옴
		Service_Event.OnServerEvent:Connect(function(plr,Object,CardNum,pick) -- 이벤트 받고 turn에서 선택한 카드 정보 대입 하고 맞는지 검사하는 과정
			if plr == Something and Object == "Again" then
				Something = "Again"
				task.wait()
				Something = plr
				return
			elseif plr == Something and Object == "Pass" then
				Something = "Pass"
				task.wait()
				Something = plr
				return
			end
			if not pick then 
			if plr == Selecting then
				if tostring(Card[Object.Name]) == CardNum then
					Selecting = Object
				elseif Something ~= "Again" and Something ~= "Pass" then 
					Selecting = nil
					GuessEventInfo = Object
					GuessNum = CardNum
				end
			end
			else
				Selecting = Object
			end
		end)
		repeat 
			wait() -- 기다림
		until Selecting ~= v -- 이거 처음에 플레이어가 넣어둔거 위에 이벤트에서 값 얻을때 까지 대기
		print("ING")
		if Selecting == "Leave" then -- 나갔는지 확인
			Leave(Plrs) -- 나가는 함수
		end
		if Selecting ~= nil then -- 맞췄을 때
			local LosePlr = game:GetService("Players"):FindFirstChild(Selecting.Parent.Name)
			SeeCard(v,Selecting,tostring(Card[Selecting.Name]),LosePlr)
			if Winner then -- 맞췄는대 이겼을 때
				Service_Event:FireClient(v,{"Text","Youwon"})
				return -- 빠져나가기 / 게임 종료
			end
			if not table.find(Loser,LosePlr.Name) then
			Service_Event:FireClient(LosePlr,{"Text","Oops"})
			end
			Service_Event:FireClient(v,{"Text",math.random(1,2) == 1 and "WoW" or "Solve"})
			task.wait(1.2)
			print(GuessNum)
			PlrArrayToFire(Plrs,{{"Guess",{v.UserId,game:GetService("Players"):FindFirstChild(Selecting.Parent.Name).UserId},Card[Selecting.Name] % 1 == 0.5 and "Joker" or tostring(Card[Selecting.Name]),true}})
			again(v,Own_Card) -- 맞춰서 다시하기 함수
		elseif Own_Card  then -- 틀려서 받은 카드 보여줌
			Service_Event:FireClient(v,{"Text","Oops"})
			SeeCard(v,Own_Card[1],tostring(Card[Own_Card[1].Name]),nil) -- 보여주는 함수
			print(GuessNum)
			PlrArrayToFire(Plrs,{{"Guess",{v.UserId,game:GetService("Players"):FindFirstChild(GuessEventInfo.Parent.Name).UserId},tonumber(GuessNum) % 1 == 0.5 and "Joker" or GuessNum,false}})
		else -- 받을 카드가 더이상 없어서 자신이 가지고있는 카드중 골라서 보여줌
			Service_Event:FireClient(v,{"Text","Oops"})
			local Behind = {} -- 숨겨진 카드 배열
			for i, v in pairs(mainfolder:FindFirstChild(v.Name):GetChildren())  do -- 카드 찾기
				if v:GetAttribute("See") == false then
					table.insert(Behind,v) -- 추가
				end
			end
			if #Behind > 1 then -- 카드 선택지가 1개 이상일때
			Selecting = v
			turn(v,Card,true,mainfolder:FindFirstChild(v.Name))
			repeat 
			    wait() -- 기다림
			until Selecting ~= v -- 선택한 카드 값을 얻었을때
			SeeCard(v,Selecting,tostring(Card[Selecting.Name]),nil) -- 보여줌
			else -- 카드가 하나라 선택지가 없을 때
				SeeCard(v,Behind[1],tostring(Card[Behind[1].Name]),nil) -- 남은 카드 보여줌
				-- 플레이어 뒤짐 / 게임 오버
			end
			PlrArrayToFire(Plrs,{{"Guess",{v.UserId,game:GetService("Players"):FindFirstChild(GuessEventInfo.Parent.Name).UserId},tonumber(GuessNum) % 1 == 0.5 and "Joker" or GuessNum,false}})
		end
		end
	end
	until Winner -- 승자가 나올때 까지 반복
	Plrs = nil
	Loser = nil
	Winner = nil
	user_Points = nil
  GuessEventInfo = nil
  GuessNum = nil
	return
end)