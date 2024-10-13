local Players = game:GetService("Players")
local BindableServer = game:GetService("ReplicatedStorage"):FindFirstChild("EventFolder"):FindFirstChild('ServerInvoke')
local RoomService = game:GetService("ReplicatedStorage"):FindFirstChild("EventFolder"):FindFirstChild("RoomService")
local Start = game:GetService("ServerScriptService"):WaitForChild("Booting"):FindFirstChild("Starting")
--local IntroUiFolder = game:GetService("ReplicatedStorage"):FindFirstChild("UiFolder"):FindFirstChild("IntroUi")
local SaveRoom = {}--Room : Key

local Task = {}
Task.__index = Task
function clonetable(t : any)
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
local function PlrName_Into_Insctance(ToS : string?) : {} -- PlrName Table -- 테이블 개체로 풀어주는 함수
	if typeof(ToS) == "table" then 
		print(ToS)
		local InstanceResult, Failed, FailInstance = {}, false, {} -- Result, FailedType, Fail Plr Name Table
		for i, PlrName in pairs(ToS) do
			local Instanced = game:GetService("Players"):FindFirstChild(PlrName)
			if Instanced then print(`String Into Instance[{Instanced.Name}] Working!`); InstanceResult[i] = Instanced 
			else warn(`Fail : System can't found player Instance[{PlrName}]`); Failed = true; InstanceResult[i] = PlrName end
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
function Task:LoadORInvite(Inviting_Plr : Instance, RC : string, RI : any, InviteTask : boolean) : () -- InvitingPlr가 instance 받는 이유는 이벤트 보낸 로컬이기 때문. 안전한 정보
	print("첫 매게 값 확인 : ",Inviting_Plr)
	--if not table.find(SaveRoom[RC][2], RC) then print("REEEEEEEESSSSSSSSSSSEEEEEEEEEEEET") return end
	local CRI = clonetable(RI) -- 방 정보 참조 안하고 복사
	
	CRI[1] = "Invite" -- 참가 타입으로 조작
	
	if InviteTask then -- 참가 작동 타입이라면
		table.insert(SaveRoom[RC][2],Inviting_Plr.Name) -- 방 플레이어에 참가 플레이어 추가 
	end
	print(SaveRoom[RC][2])
	local InsSaveRoom = PlrName_Into_Insctance(SaveRoom[RC][2])["InstanceResult"]
	for i, Rplr in pairs(InsSaveRoom) do -- 방 플레이어 for 문
		RoomService:FireClient(Rplr, CRI, Inviting_Plr.Name, {["InPlayer"] = SaveRoom[RC][2]}) -- .방 프레임 로드 이벤트 신호만 Invite
	end
	CRI[1] = "List_Load" -- 리스트 로드 타입으로 조작
	RoomService:FireAllClients(CRI, RC, {["InPlayer"] = SaveRoom[RC][2]}) -- 모든 플레이어 리스트 로드
	print(InviteTask)
end
local function Leaveing(plr : Instance,RC : string) : ()
	if table.find(SaveRoom[RC][2], plr.Name) then table.remove(SaveRoom[RC][2], table.find(SaveRoom[RC][2], plr.Name)) else return end -- 방에 플레이어가 있다면 플레이어 값 삭제
		print(SaveRoom[RC][2])
		local Room_information = SaveRoom[RC][1]
		print(RC,plr)
	if #SaveRoom[RC][2] >= 1 then -- 나갔을때 사람이 있다면
		-- 혼자가 아닐때
		local CRI = clonetable(Room_information) -- 방 정보 참조 안하고 복사
		CRI[1] = "List_Load" -- 리스트 로드로 방 정보 조작
		
		if RC == plr.Name then -- 나간 사람이 방장 이라면
			print("방장맞음")
			local ChangeRCT = clonetable(SaveRoom[RC]) -- 방장 을 바꾸기 위해 방장 테이블 복사
			RC = SaveRoom[RC][2][1] -- 방장 변수 변경
			SaveRoom[RC] = ChangeRCT -- 바뀐 방장 테이블 추가
			SaveRoom[plr.Name] = nil
			print(table.find(SaveRoom, plr.Name))
			table.remove(SaveRoom, table.find(SaveRoom, plr.Name)) -- 원래 방장 테이블 삭제
			RoomService:FireAllClients(CRI, plr.Name, {["InPlayer"] = SaveRoom[RC][2]}) -- 모든 사람 리스트 로드
			print(SaveRoom)
		end
		print(Room_information)
		Task:LoadORInvite(plr, RC, CRI, false) -- 로딩 건으로 작동
		print(SaveRoom)
	else
		-- 혼자 일때
		local CRI = clonetable(Room_information) -- 방 정보 참조 안하고 복사
		CRI[1] = "List_Remove" -- 리스트 삭제로 타입 변경
		RoomService:FireAllClients(CRI, RC) -- 모든 플레이어 리스트 삭제
	end
end
BindableServer.OnServerInvoke = function(plr : Instance,Room_information : any,RCM) : any -- 정보 Room_information = 방정보 , any = 방장
	local RC = RCM
	print(plr)
	print(Room_information)
	if Room_information[1] == "Room" then -- 타입이 Room이 라면
		print("Make a Room")
		Room_information[6] = false
		SaveRoom[plr.Name] = {Room_information,{plr.Name}} -- 방 정보 저장
		RoomService:FireClient(plr,Room_information, plr.Name, {["InPlayer"] = SaveRoom[RC][2]}) -- 방 방장 방 창 열기
		for i, v in pairs(game:GetService("Players"):GetPlayers()) do -- 나 빼고 이벤트 보내기 위해 For문
			if v == plr then continue end -- 위에서 이미 나한태 보냈기에 나라면 무시
			local CRI = clonetable(Room_information) -- 테이블 복사 참조 안함
			CRI[1] = "List_Load" -- 테이블 조작 리스트 로드 타입으로 변경
			RoomService:FireClient(v, CRI, v.Name, {["InPlayer"] =  SaveRoom[RC][2]}) -- 리스트가 추가 됐기 때문에 로드하라고 플레이어 모두에게 보냄
		end
	elseif Room_information[1] == "Invite" then -- 타입이 Invite 라면
		print("Invite")
		print(SaveRoom[RC][1][3])
		print(SaveRoom[RC][1][3] <= #SaveRoom[RC][2])
		if not table.find(SaveRoom[RC][2],plr.Name) and not (SaveRoom[RC][1][3] <= #SaveRoom[RC][2]) then -- 이미 방에 들어온 플레이어가 아니라면
			print("Invite request")
			local CorrectRI = clonetable(SaveRoom[RC][1]) -- 방 정보 테이블 참조 안하고 복사
			CorrectRI[1] = "Invite"  -- 조작
			print(CorrectRI)
			Task:LoadORInvite(plr, RC, CorrectRI, true) -- 함수로 초대 건으로 동작
		elseif (SaveRoom[RC][1][3] <= #SaveRoom[RC][2]) then
			print("Room is full")
		else
			print("Alreay in this room")
		end
	elseif Room_information[1] == "Leave" then -- 타입이 나가는 거라면 -- 파라미터 형식 예외
		Leaveing(plr,RC)
	elseif Room_information[1] == "Start" then -- 나갔을때 방이 비었을때 -- 파라미터 형식 예외
		print(SaveRoom)
		print(SaveRoom[RC][2])
		SaveRoom[RC][1][6] = true
		local InsSaveRoom = PlrName_Into_Insctance(SaveRoom[RC][2])["InstanceResult"]
		Start:Fire( InsSaveRoom ) -- 게임 시작 이벤트
		local CRI = clonetable(SaveRoom[RC][1]) -- 방 정보 참조 안하고 복사
		CRI[6] = true
		CRI[1] = "Start_Game" -- 게임 시작 타입으로 조작
		for i, Rplr in pairs(InsSaveRoom) do -- 방 플레이어 For문 으로 각각 이벤트
			print(Rplr)
			print(typeof(Rplr))
			RoomService:FireClient(Rplr, CRI) -- 게임 시작 이벤트 시작
		end
		CRI[1] = "List_Remove"
		RoomService:FireAllClients(CRI,RC)
		SaveRoom[RC] = nil
	elseif Room_information[1] == "GetAllRoomIPM" then
		print(SaveRoom)
		print(#SaveRoom)
		print(unpack(SaveRoom) == nil)
		return SaveRoom
	end
end
local function CheckJoinRoom(plr : Instance) : boolean
	for i, v in pairs(SaveRoom) do
		local Check = table.find(v[2],plr.Name)
		if Check then
			return i
		end
	end
end
Players.PlayerRemoving:Connect(function(plr)
	local RC = CheckJoinRoom(plr)
	if RC then
		Leaveing(plr,RC)
	end
end)