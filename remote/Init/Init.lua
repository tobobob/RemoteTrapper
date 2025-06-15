--[[ 

Init 
@phoontg

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Webhook = require(script.Webhook)
local Whitelist = require(script.Whitelist)

local Init = {}
Init.__index = Init

local Folder = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Admin")
local mode = "warn"

local banned = {}

function Init.new()
	local self = setmetatable({}, Init)
	self.whitelist = Whitelist.new()
	return self
end

function Init:IsWhitelisted(player)
	return self.whitelist:IsWhitelisted(player.UserId)
end

function Init:IsBanned(userId)
	return banned[userId] == true
end

function Init:Ban(userId)
	banned[userId] = true
end

local Webhook = require(script.Webhook)

function Init:Handle(player, remoteName, method)
	if self:IsWhitelisted(player) or self:IsBanned(player.UserId) then return end

	local action = ""

	if mode == "warn" then
		action = "Warned"
		warn(player.Name .. " triggered " .. remoteName .. " via " .. method)

	elseif mode == "kick" then
		action = "Kicked"
		warn(player.Name .. " triggered " .. remoteName .. " via " .. method)
		player:Kick("Unauthorized remote usage: " .. remoteName)

	elseif mode == "ban" then
		action = "Banned"
		warn(player.Name .. " triggered " .. remoteName .. " via " .. method .. " [Banned]")
		self:Ban(player.UserId)
		player:Kick("You are banned from using remotes.")
	end

	Webhook:Send(player, remoteName, method, action)
end



function Init:Bind(remote)
	if remote:IsA("RemoteEvent") then
		remote.OnServerEvent:Connect(function(player)
			self:Handle(player, remote.Name, "RemoteEvent")
		end)

	elseif remote:IsA("RemoteFunction") then
		remote.OnServerInvoke = function(player)
			self:Handle(player, remote.Name, "RemoteFunction")
			return nil
		end
	end
end

function Init:Init()
	for _, remote in ipairs(Folder:GetChildren()) do
		self:Bind(remote)
	end

	Folder.ChildAdded:Connect(function(remote)
		self:Bind(remote)
	end)
end

return Init
