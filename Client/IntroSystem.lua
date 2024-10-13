local Match,Start = script.Parent.Match_Frame,script.Parent.Start_Frame
local Debri = game:GetService("Debris")
local localService = game:GetService("ReplicatedStorage").EventFolder.LocalServicing
local ServerService = game:GetService("ReplicatedStorage").EventFolder.LocalService
local RoomService = game:GetService("ReplicatedStorage").EventFolder.RoomService
local BindableServer = game:GetService("ReplicatedStorage").EventFolder.ServerInvoke
local play = false
local plr = game:GetService("Players").LocalPlayer
local MSG,CreateFrame = Match.MSG,Match.Create_Frame
local modify = require(game:GetService("ReplicatedStorage").Modify) 
local intro_music = script.introMusic
local Creating = CreateFrame.Creating
local TopBar_in,LeftBar,ModeBar,ResultBar,Roomlist,RoomFrame,RoomRC_Frame = Creating.TopBar_Frame.PlaySpeed_Frame,Creating.LeftSetting_Frame,Creating.Mode_Frame,Creating.Result_Frame,Match.RoomList_Frame,game:GetService("ReplicatedStorage").UiFolder.IntroUi.Room_Frame,game:GetService("ReplicatedStorage").UiFolder.IntroUi.RoomRC_Frame
local CreateCloseButton = Match.CreateCloseButton
local TweenService = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

local distanxe = 135
local Game_Start = false
local M_P = Match.Position
local WS = intro_music.Volume
local Mode,MaxPlr,JokerMode,Number_of_cards = "",2,false,24
repeat
	wait(0.1)
until Start.Load.BackgroundTransparency < 10.
-- 노래 초기화
intro_music.Volume = 0
script.introMusic:Play()
modify.Tween(intro_music,"Volume",WS,13)
modify.UiMove(Match.Deco2,"Rotation",-180,180,2)
modify.UiMove(Match.Deco,"Rotation",-180,180,0.7)
-- 값 세팅
local Coint = plr:WaitForChild("Stats"):WaitForChild("Coint")
local Rating = plr:WaitForChild("Stats"):WaitForChild("Rating")
local Coint_Text = Match.Blank1.UpBar.Coint
local Rating_Text = Match.Blank1.UpBar.Rating
Coint_Text.Value.Text = Coint.Value
Rating_Text.Value.Text = Rating.Value
Coint:GetPropertyChangedSignal("Value"):Connect(function()
	Coint_Text.Value.Text = Coint.Value
end)
Rating:GetPropertyChangedSignal("Value"):Connect(function()
	Rating_Text.Value.Text = Rating.Value
end)
-- 노래 소리 트윈 완료
ServerService.OnClientEvent:Connect(function(TaskArray)
	if TaskArray[1] == "Clock" then
		if Game_Start then return end
		modify.Tween(lighting,"ClockTime",lighting.ClockTime == 6 and 7 or 6)
	end
end)
function ResetRoom() : () -- 방 만들기 설정 초기화
	MaxPlr = 2
	LeftBar.MaxPlr_Frame.PLAYER.Text = tostring(MaxPlr)
	JokerMode = false
	LeftBar.Joker_Mode.ON_OFF.Text = "Off"
	Number_of_cards = 24
	TopBar_in.Speed.Text = "Middle"
end
modify.UiMove(CreateFrame.Creating.Title,"Rotation",5,-5,4)
modify.UiMove(Roomlist.Room.Title,"Rotation",5,-5,4)

local function Card_Move(Select : Instance,Visibled : boolean) : () -- 카드 접히고 서있는 함수
	print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"..tostring(Visibled))
	if Visibled == false then
		for i , v in pairs(Select:GetChildren()) do
			if v.ClassName == "ViewportFrame" then
				spawn(function()
					for a ,b in pairs(v:GetChildren()) do
						if b.ClassName ~= "MeshPart" and b.ClassName ~= "UIAspectRatioConstraint" then
							b.Visible = Visibled
						end
					end
				end)
				modify.Tween(v.Card,"CFrame",CFrame.new(v.Card.Position.X,0-v.Card.Size.Y+v.Card.Size.Y/2,v.Card.Position.Z)* CFrame.Angles(math.rad(v.Card.Orientation.X),math.rad(v.Card.Orientation.Y),math.rad(90)),0.5)
			end
		end
	else
		for i , v in pairs(Select:GetChildren()) do
			if v.ClassName == "ViewportFrame" then
				modify.Tween(v.Card,"CFrame",CFrame.new(v.Card.Position.X,0,v.Card.Position.Z)* CFrame.Angles(math.rad(v.Card.Orientation.X),math.rad(v.Card.Orientation.Y),0),0.5)
				spawn(function()
					for a ,b in pairs(v:GetChildren()) do
						if b.ClassName ~= "MeshPart" and b.ClassName ~= "UIAspectRatioConstraint" then
							b.Visible = Visibled
						end
					end
				end)
			end
		end

	end
end
Card_Move(Match,false)
Match:GetPropertyChangedSignal("Visible"):Connect(function() -- 매치 창이 켜졌을때
	if Match.Visible then
	Start.Visible = false
	modify.Tween(intro_music.EqualizerSoundEffect,"MidGain",-10,0.5)
	modify.Tween(intro_music.EqualizerSoundEffect,"HighGain",0,0.5)
	Match.Blank1.Position -= UDim2.new(0,0,0,distanxe)
	Match.Blank2.Position += UDim2.new(0,0,0,distanxe)
	wait(.4)
    modify.Tween(Match.Blank1,"Position",UDim2.new(0,0,0,0),0.1,Enum.EasingStyle.Cubic)
	modify.Tween(Match.Blank2,"Position",UDim2.new(-0.001, 0,0.862, 0),0.1,Enum.EasingStyle.Cubic)
	Card_Move(Match,true)
	play = true
	end
end)
Start:GetPropertyChangedSignal("Visible"):Connect(function() -- 시작 프래임이 켜졌는대 노래가 안나올때 나오게
	if Start.Visible and not intro_music.IsPlaying then
		intro_music:Play()
	end
end)
local lock = false
local function CloseMatch() : () -- 계속 사용 하는 패턴이라 함수로 묶음 match Frame 닫히는 함수
	lock = true
	Card_Move(Match,false)
	wait(0.5)
	modify.Tween(intro_music.EqualizerSoundEffect,"MidGain",10,0.5)
	modify.Tween(intro_music.EqualizerSoundEffect,"HighGain",10,0.5)
	modify.Tween(Match.Blank1,"Position",Match.Blank1.Position - UDim2.new(0,0,0,distanxe),0.1,Enum.EasingStyle.Cubic)
	modify.Tween(Match.Blank2,"Position",Match.Blank2.Position + UDim2.new(0,0,0,distanxe),0.1,Enum.EasingStyle.Cubic)
	modify.load(Start,true)
	wait(.1)
	play = false
	Match.Visible = false
	Start.Visible = true
	lock = false
end
Match.Blank2.DownBar.Leave_Menu.MouseButton1Up:Connect(function() -- 나가는 이벤트
	if not lock then
		CloseMatch()
	end
end)
-- 
local selects = false
local function Background_Vibe(Bool : boolean) : () -- 배경 색 바뀌는 거 
	if Bool then
	modify.Tween(Match,"BackgroundColor3",Color3.new(0, 0, 0),.5,true)
	else
	modify.Tween(Match,"BackgroundColor3",Color3.new(0.882353, 0.901961, 1),.5,true)
	end
end
local _RoomList_Close_Pos_, _Search_Close_Pos_, _Create_Close_Pos_ = UDim2.new(0.451, 0,0.749, 0), UDim2.new(0.451, 0,0.645, 0), UDim2.new(0.451, 0,0.815, 0)
for i , v in pairs(Match:GetChildren()) do -- for문으로 카드 탐색 병렬로 이벤트
	if v.ClassName == "ViewportFrame" then -- 뷰포트 카드 라면
		local CFrame_Card,Line_Pose = v.Card.CFrame,v.Line.Position -- 초기 카드 위치값, 라인 값 변수 저장
		
		local CardNum = v.CardNum.Text -- 초기 문자 변수 저장
		local even,close -- 이벤트 변수
		v.MouseEnter:Connect(function()-- 카드 올려질때
			if not selects and play and not CreateFrame.Visible then -- 선택 하지 않았고
			localService:Fire({"Sound","Tick"})
			modify.Tween(v.Card,"CFrame",CFrame.new(0,0,-2.15)* (CFrame_Card - CFrame_Card.p) * CFrame.Angles(math.rad(5),math.rad(0),math.rad(179)),0.2)
			modify.Tween(v.CardNum,"Rotation",5,0.2,true)
			modify.Tween(v.Line,"Rotation",5,0.2,true)
			v.CardNum.Text = "Click?"
			v.Line.Position = Line_Pose-UDim2.new(0,4,0,3)
			even = v.Select.MouseButton1Up:Connect(function()
				selects = true
				
				modify.Tween(v.Card,"CFrame",CFrame_Card,0.2,true)
				modify.Tween(v.Card,"Position",Vector3.new(0,0,-2),0.2,true)
				modify.Tween(v.CardNum,"Rotation",0,0.2,true)
				modify.Tween(v.Line,"Rotation",0,0.2,true)
				v.CardNum.Text = v:GetAttribute("This_Object")
				v.Line.Position = Line_Pose
				even:Disconnect()
				wait(0.2)
				local function Changed(Type)
					if Type == "Next" then
					Card_Move(Match,false)
					wait(0.5)
					Match.Create.CardNum.Text = "Server"
					Match.Search.CardNum.Text = "Global"
					Card_Move(Match,true)
						modify.Open(CreateCloseButton,"More",true,0.2)
					elseif Type == "Back" then
					Card_Move(Match,false)
					wait(0.5)
					Match.Create.CardNum.Text = "Create"
					Match.Search.CardNum.Text = "Search"
					Card_Move(Match,true)
					end
				end
				if v:GetAttribute("This_Object") == "Search" then
				if Match.Blank2.DownBar.Leave_Menu.Visible then
					modify.Open(Match.Blank2.DownBar.Leave_Menu,"More",false,0.2)
				end
				localService:Fire({"Sound","FailSound"})
				CreateCloseButton.Position = _Search_Close_Pos_
				Changed("Next")
					selects = false
					-------------------------------------------------------------------------
				Match.Create:SetAttribute("This_Object","Server")
				Match.Search:SetAttribute("This_Object","Global")
				local Backing
				Backing = CreateCloseButton.MouseButton1Up:Connect(function()
					if Roomlist.Visible then
						modify.Open(Roomlist,"More",false,0.2,true,{Roomlist.Nothing})
						selects = false
						modify.Tween(CreateCloseButton,"Position",_Search_Close_Pos_,0.2)
					else
						Backing:Disconnect()
						modify.Open(CreateCloseButton,"More",false,0.2)
						localService:Fire({"Sound","FailSound"})
						Changed("Back")
						wait(0.2)
						Match.Create:SetAttribute("This_Object","Create")
						Match.Search:SetAttribute("This_Object","Search")
						selects = false
						if not Match.Blank2.DownBar.Leave_Menu.Visible then
							modify.Open(Match.Blank2.DownBar.Leave_Menu,"More",true,0.2)
						end
					end
				end)
				elseif v:GetAttribute("This_Object") == "Server" then
					modify.Open(Roomlist,"More",true,0.2,true,{Roomlist.Nothing})
					modify.Tween(CreateCloseButton,"Position",_RoomList_Close_Pos_,0.2)
				elseif v:GetAttribute("This_Object") == "Create" then
					Background_Vibe(true)
					modify.Open(Match.Blank2.DownBar.Leave_Menu,"More",false,0.2)
					localService:Fire({"Sound","FailSound"})
					Card_Move(Match,false)
					CreateCloseButton.Position = _Create_Close_Pos_
					modify.Open(Match.Create_Frame,"Slap",true,0.2,true,{CreateFrame.Creating})
					modify.Open(Match.Create_Frame,"More",true,0.2,false)
					modify.Open(CreateCloseButton,"More",true,0.2)
					local ticks = tick()
					local eventing = {}
					local clicking = false
					local outing = false
					local Backing
					local EnabledFrame
					local sop,sop2 = false,false
					local outro
						local backs = false
						sop = true
						local function Backs() : ()
							if backs and sop2 then
								return
							end
							backs = true
							if Mode == "" or not CreateFrame.Creating.Visible then
								sop2 = true
								clicking = false
								if #CreateFrame.Sel:GetChildren() ~= 0 then
									Mode = ""
									if CreateFrame.Next.Visible then
										modify.Open(CreateFrame.Next,"More",false,0.2,false)
									end
									wait(0.2)
								end
								Mode = ""
								for int, ent in pairs(eventing) do
									ent:Disconnect()
								end
								eventing = {}
								spawn(function()
									modify.Tiping(MSG,"Back",0.02,true,false)
									MSG.Text = ""
								end)
								CreateCloseButton.Visible = false
								modify.Open(Match.Create_Frame,"Slap",false,0.2)
								Card_Move(Match,true)
								Background_Vibe(false)
								wait(0.6)
								selects = false
								modify.Open(Match.Blank2.DownBar.Leave_Menu,"More",true,0.2)
								wait(0.2)
								sop2 = false
							else
								sop2 = true
								Mode = ""
								if EnabledFrame then
								EnabledFrame:Disconnect()
								end
								Background_Vibe(true)
								ResetRoom()
								modify.Slide(CreateFrame.BookFrame,0.7)
								wait(0.7)
								modify.Tiping(MSG,"Choose the book of the mode you want",0.02,true,true)
								sop2 = false
							end
							backs = false
						end
					for i,o in pairs(CreateFrame.BookFrame.BookScroll:GetChildren()) do
						if o.ClassName == "TextButton" then
							local leave , click, BackClick ,ChangePos
							local evnt
							evnt = o.MouseEnter:Connect(function()
								local lock = false
								local a
								if (not lock) and (not clicking) and Mode == "" and (not sop)and (not sop2) then
									lock = true
								localService:Fire({"Sound","Selecte2"})
								o.Visible = false
								local mouse = plr:GetMouse()
								local pos,size = UDim2.new(0,o.AbsolutePosition.X-CreateFrame.AbsolutePosition.X,0,o.AbsolutePosition.Y-CreateFrame.AbsolutePosition.Y),UDim2.new(0,o.AbsoluteSize.X,0,o.AbsoluteSize.Y)
								local Fake = Instance.new("Frame",CreateFrame.BookFrame.BookScroll)
								local CloneBook = o:Clone()
								local Paper = Instance.new("Frame",CreateFrame.Sel)
								local Sinc = {}
								local function out() : ()
									if not outing and not clicking then
									outing = true
									selects = false
									clicking = false
									lock = false
									if a then
										a:Disconnect()
									end
									if click then
									click:Disconnect()
									end
									if BackClick then
										BackClick:Disconnect()
									end
									modify.Tween(CloneBook,"Position",pos,0.2,true)
									modify.Tween(Paper,"Size",UDim2.new(0,size.X.Offset-4,0,5),0.2,true)
									outing = false
									task.wait(0.2)
									o.Visible = true
									print("iiiiiiiiiiiiiiiiiiiiiiiaaaaaaaaaaaaaaaaaaaaaaaaaa")
									
									Paper:Destroy()
									CloneBook:Destroy()
									Fake:Destroy()
									end
								end
								Fake.Name = v.Name.."Cloned"
								Fake.LayoutOrder = o.LayoutOrder
								Fake.BackgroundTransparency = 1
								
								CloneBook.Visible = true
								CloneBook.ZIndex = 10
								CloneBook.Position = pos
								CloneBook.Size = size
								CloneBook.Parent = CreateFrame.Sel
								Paper.Size = UDim2.new(0,size.X.Offset-4,0,5)
								Paper.BackgroundColor3 = Color3.new(0.780392, 0.780392, 0.780392)
								Paper.BorderSizePixel = 0
								Paper.Position = pos+ UDim2.new(0,2,0,0)
								Paper.ZIndex = 8
								modify.Tween(Paper,"Size",UDim2.new(0,size.X.Offset-4,0,25),0.2)
								for i=1 , math.floor(size.X.Offset/2) do
									if math.random(1,50) >= 30 then
									local PaperSinc = Instance.new("Frame",Paper)
									PaperSinc.BackgroundColor3 = Color3.new(0.184314, 0.184314, 0.164706)
									PaperSinc.Position = UDim2.new(0,i*2,0,0)
									PaperSinc.Size = UDim2.new(0,1,1,0)
									PaperSinc.ZIndex = 9
									PaperSinc.BorderSizePixel = 0
									end
								end
								modify.Tween(CloneBook,"Position",pos+UDim2.new(0,0,0,20),0.2)
								
							click = CloneBook.MouseButton1Up:Connect(function()
								clicking = true
								Mode = o.Name
								print("Truing"..tostring(clicking))
									clicking = false
									out()
									--modify.Open(CreateFrame.BookFrame"),"DrawUp",false,0.1)
									--wait(0.1)
									Background_Vibe(false)
									ModeBar.Mode.Mode_Value.Text = Mode
									modify.Open(CreateFrame.Creating,"Child",true,0.5,true)
									modify.Slide(CreateFrame.Creating,0.7)
									modify.Tiping(MSG,"Set up your room",0.02,true,true)
									EnabledFrame = CreateFrame:GetPropertyChangedSignal("Visible"):Connect(function()
									if CreateFrame.Visible == false then
									print("ttttttttttttttttttttttttttttttttt")
									print("AAAAAAAsfff")
									EnabledFrame:Disconnect()
									CreateFrame.BookFrame.Position = UDim2.new(0,0,0,0)
									spawn(function()
										sop2 = true
										clicking = false
										print("Normal")
										for int, ent in pairs(eventing) do
											ent:Disconnect()
										end
											Mode = ""
											Backing:Disconnect()
											for int, ent in pairs(eventing) do
												ent:Disconnect()
											end
											eventing = {}
											MSG.Text = ""
											ResetRoom()
											clicking = false
											CreateCloseButton.Visible = false
											Card_Move(Match,true)
											Background_Vibe(false)
											task.wait(0.6)
											selects = false
									end)
										out()
									end
								end)
								BackClick =  CreateCloseButton.MouseButton1Up:Connect(function()
									print("ON BACK")
									clicking = false
									print(not outing , not clicking)
									out()
									clicking = false
								end)
							end)
							wait(0.1)
							a = mouse.Move:Connect(function()
								local MousePos = game:GetService("UserInputService"):GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
                                local getGUI = plr.PlayerGui:GetGuiObjectsAtPosition(MousePos.X,MousePos.Y)
									if not table.find(getGUI,Fake) then
										out()
										a:Disconnect()
									end
							end)
							
								if o.Name == "Joker" then
									modify.Tiping(MSG,"Joker card is added.",0.02,true,true)
								elseif o.Name == "Item" then
									modify.Tiping(MSG,"Items can be used.",0.02,true,true)
								elseif o.Name == "Original" then
									modify.Tiping(MSG,"This is the default mode.",0.02,true,true)
								end
								end
							end)
							table.insert(eventing,evnt)
						end
					end
					--
					modify.Tiping(MSG,"Choose the book of the mode you want",0.02,true,true)
					Backing = CreateCloseButton.MouseButton1Up:Connect(function()
						if not backs and (Mode == "" or not CreateFrame.Creating.Visible) and not sop2 then
						Backing:Disconnect()
						end
						Backs()
					end)
					wait(0.2)
					sop = false
					
				else
					selects = false
				end
				
			end)
			end
		end)
		
		v.MouseLeave:Connect(function()
			if not selects and play  and not CreateFrame.Visible then
			modify.Tween(v.Card,"CFrame",CFrame_Card,0.2,true)
			modify.Tween(v.Card,"Position",Vector3.new(0,0,-2),0.2,true)
			modify.Tween(v.CardNum,"Rotation",0,0.2,true)
			modify.Tween(v.Line,"Rotation",0,0.2,true)
			v.CardNum.Text = v:GetAttribute("This_Object")
			v.Line.Position = Line_Pose
			if even then even:Disconnect() end
			even = nil
			end
		end)
	end
end
local HoverField = 0
for i, v in pairs(Start.Buttons:GetChildren()) do
	if v.ClassName == "TextButton" then
		local WasP,WasS = v.Position,v.Size
		v.MouseEnter:Connect(function()
			localService:Fire({"Sound","Selecte"})
			modify.Tween(v,"Position",WasP - UDim2.new(0,3,0,3),0.1)
			modify.Tween(v,"TextColor3",Color3.new(0.352941, 0.352941, 0.352941),0.1)
			modify.Tween(v,"Size",WasS + UDim2.new(0,6,0,6),0.1)
			HoverField = 10
		end)
		v.MouseLeave:Connect(function()
			modify.Tween(v,"TextColor3",Color3.new(1, 1, 1),0.1)
			modify.Tween(v,"Position",WasP,0.1)
			modify.Tween(v,"Size",WasS,0.1)
			HoverField = 0
		end)
		v.MouseButton1Up:Connect(function()
			if v.Name == "Play" then
				modify.load(Match,true)
			else
				modify.Open(Start.Help_Frame,"More",true,0.2,true) 
			end
		end)
	end
end
Start.Help_Frame.CloseButton.MouseButton1Up:Connect(function()
	modify.Open(Start.Help_Frame,"More",false,0.2,true) 
end)
modify.UiMove(Start.Help_Frame.Title,"Rotation",5,-5,4)
--Create_Frame
-- PlaySpeed
function Checking(bttn : Instance,War : boolean) : ()
	local check = coroutine.create(function()
		local OriginColor = bttn.BackgroundColor3
		bttn.BackgroundColor3 = War and Color3.new(1, 0.388235, 0.388235) or Color3.new(0.0823529, 0.0823529, 0.0823529)
		task.wait(.05)
		bttn.BackgroundColor3 = OriginColor
	end)
	coroutine.resume(check)
end
for i , v in pairs(TopBar_in:GetChildren()) do
	if v.ClassName == "TextButton" then
		v.MouseButton1Up:Connect(function()
			if v.Name == "Slow" and Number_of_cards ~= 28 and TopBar_in.Speed.Text ~= "Slow" then
				print(TopBar_in.Speed.Text)
				Number_of_cards = 28
				localService:Fire({"Sound","Setting"})
				TopBar_in.Speed.Text = "Slow"
				Checking(v)
			elseif v.Name == "Middle" and Number_of_cards ~= 24 and TopBar_in.Speed.Text ~= "Middle" then
				print(TopBar_in.Speed.Text)
				Number_of_cards = 24
				localService:Fire({"Sound","Setting"})
				TopBar_in.Speed.Text = "Middle"
				Checking(v)
			elseif v.Name == "Fast" and Number_of_cards ~= 18 and TopBar_in.Speed.Text ~= "Fast" then
				print(TopBar_in.Speed.Text)
				Number_of_cards = 18
				localService:Fire({"Sound","Setting"})
				TopBar_in.Speed.Text = "Fast"
				Checking(v)
			else
				modify.Tiping(MSG,"Already set up",0,true,false)
				localService:Fire({"Sound","Nope"})
				Checking(v,true)
			end
		end)
	end
end
--LeftSetting
for i , v in pairs(LeftBar:GetDescendants()) do
	if v.ClassName == "TextButton" then
		v.MouseButton1Up:Connect(function()
			if v.Name == "Up" and MaxPlr >= 2 and MaxPlr < 4 then
				MaxPlr += 1
         				localService:Fire({"Sound","Setting"})
				LeftBar.MaxPlr_Frame.PLAYER.Text = tostring(MaxPlr)
				Checking(v)
			elseif v.Name == "Down" and MaxPlr > 2 and MaxPlr <= 4 then
				MaxPlr -= 1
				localService:Fire({"Sound","Setting"})
				LeftBar.MaxPlr_Frame.PLAYER.Text = tostring(MaxPlr)
				Checking(v)
			elseif v.Name == "Yes" and JokerMode ~= true then
				JokerMode = true
				localService:Fire({"Sound","Setting"})
				LeftBar.Joker_Mode.ON_OFF.Text = "On"
				Checking(v)
			elseif v.Name == "No" and JokerMode ~= false then
				JokerMode = false
				localService:Fire({"Sound","Setting"})
				LeftBar.Joker_Mode.ON_OFF.Text = "Off"
				Checking(v)
			else
				modify.Tiping(MSG,v.Parent.Name == "MaxPlr_Frame" and "Max" or "Already set up",0,true,false)
				localService:Fire({"Sound","Nope"})
				Checking(v,true)
			end
		end)
	end
end

local PlrCell,RoomCell,Room = game:GetService("ReplicatedStorage").UiFolder.IntroUi.PlayerCell,game:GetService("ReplicatedStorage").UiFolder.IntroUi.RoomCell,game:GetService("ReplicatedStorage").UiFolder.IntroUi.Room
local RoomFolder = game:GetService("ReplicatedStorage").RoomFolder
function clonetable(t : {any}) : {any}
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
ResultBar.Reset_Button.MouseButton1Up:Connect(function()
	--modify.Open(CreateFrame.Creating,"Child",true,0.1,true)
	localService:Fire({"Sound","Setting"})
	modify.Tiping(MSG,"Default setting",0,true,false)
	Checking(ResultBar.Reset_Button,true)
	ResetRoom()
end)
local RoomMake = false
ResultBar.Complite_Button.MouseButton1Up:Connect(function()
	if RoomMake == false then
	    RoomMake = true
		BindableServer:InvokeServer({"Room",Mode,MaxPlr,JokerMode,Number_of_cards}, plr.Name)
	    spawn(function()
		modify.Open(CreateFrame,"More",false,0.2,true)
		end)
		localService:Fire({"Sound","Setting"})
		ResetRoom()
	end
end)
local function PlrName_Into_Insctance(ToS : string?) : {} -- PlrName Table -- 테이블 개체로 풀어주는 함수
	if typeof(ToS) == "table" then
		local InstanceResult, Failed, FailInstance = {}, false, {} -- Result, FailedType, Fail Plr Name Table
		for i, PlrName in pairs(ToS) do
			local Instanced = game:GetService("Players"):FindFirstChild(PlrName)
			if Instanced then print(`String Into Instance[{Instanced.Name}] Working!`); InstanceResult[i] = Instanced else warn(`Fail : System can't found player Instance[{PlrName}]`); Failed = true; InstanceResult[i] = PlrName end
		end
		print("InstanceResult : ",InstanceResult)
		return {["InstanceResult"] = InstanceResult, ["Fail"] = Failed, ["FailInstance"] = FailInstance}
	elseif typeof(ToS) == "string" then
		local InstanceResult, Failed = nil, false
		local Instanced = game:GetService("Players"):FindFirstChild(ToS)
		if Instanced then
			InstanceResult = Instanced
			print(`String[Char] Into Instance[{Instanced.Name}] Working!`)
		else
			Failed = true
			warn(`Fail[Char] : System can't found player Instance[{ToS}]`)
		end
		return {["InstanceResult"] = InstanceResult, ["Fail"] = Failed}
	end
	return
end
local RoomLists = Match.RoomList_Frame.Room.List_Frame.RoomList
RoomLists.ChildAdded:Connect(function(Room)
	if Room:FindFirstChild("Join_Button") then
		Match.RoomList_Frame.Nothing.Visible = false
		print(Match.RoomList_Frame.Nothing.Visible)
		Room.Join_Button.MouseButton1Up:Connect(function()
			local RC = Room.RoomCreater.Value
			BindableServer:InvokeServer({"Invite"},RC)
		end)
	end
end)
RoomLists.ChildRemoved:Connect(function(Room)
		if #RoomLists:GetChildren() == 1 then
		Match.RoomList_Frame.Nothing.Visible = true
		print(Match.RoomList_Frame.Nothing.Visible)
		end
end)
--
local function PlrThumnailImage(Image : Instance, Plr :Instance) : ()
	local userId = Plr.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size420x420
	local content, isReady = game:GetService("Players"):GetUserThumbnailAsync(userId, thumbType, thumbSize)

	Image.Image = content
end
local function Load_List(InPlayer : Instance, RI : any, OldRC : string) : ()-- Instanced -- OldRC 파라미터 있는 이유는 방장 나가면 교체 때문 InPlayer 파라미터 있는 이유 방에 첫번째 플레이어가 방장이되게하기 위해
	local RC = InPlayer[1]
	for i, v in pairs(Roomlist.Room.List_Frame.RoomList:GetChildren()) do
		if v.ClassName == "UIGridLayout" or v.RoomCreater.Value ~= OldRC then continue end
		v:Destroy()
	end
	
	local Typed,Moded,MaxPlred,Jokered,CardNumed,Play = unpack(RI)
	local RCC = RoomCell:Clone()
	print(RC)
	    RCC.Setting.Master.Text = RC.Name
	    RCC.Setting.Moded.Text = Moded
	    if Jokered then
		RCC.Setting.Jokered.TextColor3 = Color3.new(0.431373, 1, 0.478431)
		RCC.Setting.Jokered.Text = "Joker"
	    else
		RCC.Setting.Jokered.TextColor3 = Color3.new(1, 0.537255, 0.537255)
		RCC.Setting.Jokered.Text = "No Joker"
	    end
		RCC.Setting.PlrMaxed.Text = string.format("Plr (%d/%d)", #InPlayer, MaxPlred) 
		RCC.RoomCreater.Value = RC.Name
		if #InPlayer >= MaxPlred or Play then RCC.Setting.PlrMaxed.TextColor3 = Color3.new(1, 0.537255, 0.537255) 
		RCC.Join_Button.BackgroundColor3 = Color3.new(1, 0.537255, 0.537255) end
		if Play then RCC.BackgroundColor3 = Color3.new(0.0666667, 0.0666667, 0.0666667) end
	    RCC.Parent = Roomlist.Room.List_Frame.RoomList
	    PlrThumnailImage(RCC.PlayerImage,RC) 
	    Roomlist.Nothing.Visible = false
end

local function Load_Room(InPlayer , RI) : () -- Instanced
	local function DeleteRoom()
		local Delete = Match:FindFirstChild("Room_Frame")
		local DeleteRC = Match:FindFirstChild("RoomRC_Frame")
		if Delete then
			Delete:Destroy()
			DeleteRoom()
		elseif DeleteRC then
			DeleteRC:Destroy()
			DeleteRoom()
		end
	end
	DeleteRoom()
	local RFC = RoomFrame:Clone()
	if InPlayer[1] == plr then
		RFC = RoomRC_Frame:Clone()
	end
	local Cell =  RFC.Room.List_Frame.Cell_Frame
	Cell.MasterCell.name.Text = string.upper(InPlayer[1].Name)
	Cell.MasterCell.Rating.Text = string.format("RATING %d",tostring(InPlayer[1].Stats.Rating.Value))
	PlrThumnailImage(Cell.MasterCell.PlayerImage,InPlayer[1])
	RFC.Parent = Match
	for i, v in pairs(InPlayer) do
		if i == 1 then continue end
		local PCell = PlrCell:Clone()
		PCell.name.Text = string.upper(v.Name)
		PCell.Rating.Text = string.format("RATING %d",tostring(v.Stats.Rating.Value))
		PlrThumnailImage(PCell.PlayerImage,v)
		PCell.Parent = Cell
	end
	if (RFC) then
	modify.UiMove(RFC.Room.Title,"Rotation",5,-5,4)
	modify.Open(RFC,"More",true,0.2,true)
	local LeaveButton
	local StartButton
	LeaveButton = RFC.Room.Start_Frame.Leave_Button.MouseButton1Up:Once(function()
		local CRI = clonetable(RI)
		CRI[1] = "Leave"
		modify.Tiping(MSG,"Leave the room",0.02,true,false)
		localService:Fire({"Sound","Setting"})
		BindableServer:InvokeServer(CRI, InPlayer[1].Name)
		modify.Open(RFC,"More",false,0.2,true)
		RoomMake = false
		Debri:AddItem(RFC,0.2)
		modify.Open(Match.Blank2.DownBar.Leave_Menu,"More",true,0.2)
		LeaveButton:Disconnect()
		LeaveButton = nil
		StartButton:Disconnect()
		StartButton = nil
	end)
	if RFC.Room.Start_Frame:FindFirstChild("Start_Button") then
	
	StartButton = RFC.Room.Start_Frame.Start_Button.MouseButton1Up:Connect(function()
		if #InPlayer > 1 then
			StartButton:Disconnect()
			StartButton = nil
			LeaveButton:Disconnect()
			LeaveButton = nil
			
			local CRI = clonetable(RI)
			CRI[1] = "Start"
			localService:Fire({"Sound","Setting"})
			BindableServer:InvokeServer(CRI, InPlayer[1].Name)
		else
			localService:Fire({"Sound","Nope"})
			modify.Tiping(MSG,"Not enough players.",0,true,true)
		end
	end)
	end
	end
end
local function List_Remove(RC : string) : ()
	local RoomUploadList = Roomlist.Room.List_Frame.RoomList
	for i, v in pairs(RoomUploadList:GetChildren()) do
		if v.ClassName == "UIGridLayout" or v:FindFirstChild("RoomCreater").Value ~= RC then continue end
		v:Destroy()
	end
end
local function Start_Task(Switch : boolean) : ()
	if Switch then
		Game_Start = true
		lighting.Brightness = 0
		lighting.EnvironmentDiffuseScale = 1
		lighting.EnvironmentSpecularScale = 1
		lighting.ClockTime = 6
		
		modify.load(Match,false)
		intro_music:Stop()
		RoomMake = false
	else
		Game_Start = false
		Match.Visible = true
	    lighting.EnvironmentDiffuseScale = 0
		lighting.EnvironmentSpecularScale = 0
		local CCam = workspace.Camera
		CCam.CameraType = Enum.CameraType.Scriptable
		task.wait(2)
		modify.Tween(CCam,"CFrame",CFrame.new(workspace:WaitForChild("Void"):WaitForChild("First_Camera").Position)*CFrame.Angles(0,math.rad(180) ,0),0.1)
	end
end
local function MainRoomService(Room_information : any, Special_plr : string, SomeData : string) : ()
	if Special_plr == "That's You" then Special_plr = plr.Name end
	Special_plr = (Room_information[1] == "List_Load" or Room_information[1] == "List_Remove") and Special_plr or Special_plr and game:GetService("Players"):FindFirstChild(Special_plr) or Special_plr
	SomeData = SomeData and {["InPlayer"] = PlrName_Into_Insctance(SomeData["InPlayer"])["InstanceResult"]} or SomeData
	if Room_information[1] == "Room" then
		Load_Room(SomeData["InPlayer"], Room_information)
		Load_List(SomeData["InPlayer"], Room_information)
		modify.Tiping(MSG,"made a party room",0.02,true,false)
		---- RoomLoading
	elseif Room_information[1] == "Invite" then
		Load_Room(SomeData["InPlayer"], Room_information)
	elseif Room_information[1] == "List_Load" then
		Load_List(SomeData["InPlayer"], Room_information, Special_plr)
	elseif Room_information[1] == "List_Remove" then
		List_Remove(Special_plr)
	elseif Room_information[1] == "Start_Game" then
		modify.Tiping(MSG,"Game Start!",0.02,true,false)
		task.wait(1)
		Start_Task(true)
		local RoomFrame = Match:FindFirstChild("RoomRC_Frame") or Match:FindFirstChild("Room_Frame")
		if RoomFrame then RoomFrame:Destroy() end
	elseif Room_information[1] == "List_Playing" then
		Load_List(SomeData["InPlayer"], Room_information)
	end
end

RoomService.OnClientEvent:Connect(MainRoomService)
local coroutineLoad = coroutine.create(function()
	for i=1, 3 do 
	--print("RoomList Load ...")
	task.wait(1)
	local AllRoomIPM = BindableServer:InvokeServer({"GetAllRoomIPM"})
	--print(unpack(AllRoomIPM) == nil)
	print("CheckingData : ",AllRoomIPM)
	local table_nil = true
	for i, TblChild in pairs(AllRoomIPM) do
		table_nil = false
	end
	if table_nil then print("unexpected table value...", "System Get",AllRoomIPM,#AllRoomIPM) continue end
	--print(AllRoomIPM)
	-- 모든 방의 정보를 받아옴
		for i, GameBar in pairs(Roomlist.Room.List_Frame.RoomList:GetChildren()) do -- 초기화
		if GameBar.ClassName == "UIGridLayout" then continue end
		GameBar:Destroy() -- 삭제
	end
	for i, RoomData in pairs(AllRoomIPM) do
		local RoomIFM, InPlayer = unpack(RoomData)
		Load_List(PlrName_Into_Insctance(InPlayer)["InstanceResult"] ,RoomIFM)
	end
end
end)
coroutine.resume(coroutineLoad)
local Cam = workspace.Camera
while wait(0.05) do
	if Start.Visible and (not Game_Start) then
	modify.Tween(Cam,"FieldOfView",80-(intro_music.PlaybackLoudness/1000)*20 - HoverField,0.1)
	else
	Cam.FieldOfView = 80
	end
end