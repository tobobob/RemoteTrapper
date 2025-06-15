--[[

Whitelist
@phoontg

]]

local Whitelist = {}
Whitelist.__index = Whitelist

local defaultList = {
	12345678,
	87654321,
}

function Whitelist.new()
	local self = setmetatable({}, Whitelist)
	self.allowed = {}

	for _, id in ipairs(defaultList) do
		self.allowed[id] = true
	end

	return self
end

function Whitelist:IsWhitelisted(userId)
	return self.allowed[userId] == true
end

function Whitelist:AddUser(userId)
	self.allowed[userId] = true
end

function Whitelist:RemoveUser(userId)
	self.allowed[userId] = nil
end

function Whitelist:GetAll()
	local list = {}
	for id in pairs(self.allowed) do
		table.insert(list, id)
	end
	return list
end

return Whitelist
