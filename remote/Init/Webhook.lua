--[[

Webhook
@phoontg

]]

local HttpService = game:GetService("HttpService")

local Webhook = {}
Webhook.__index = Webhook

Webhook.URL = ""

function Webhook:Send(player, remoteName, method, action)
	if not self.URL or self.URL == "" then return end
	if not player or not remoteName or not method or not action then return end

	local embed = {
		title = "RTT",
		color = 01010101,
		description = string.format(
			"**Player**\n`%s` (ID: `%d`)\n\n**Remote**\n`%s`\n\n**Method**\n`%s`\n\n**?? Action Taken**\n`%s`",
			player.Name,
			player.UserId,
			remoteName,
			method,
			action
		),
		timestamp = DateTime.now():ToIsoDate(),
		footer = {
			text = "RTT"
		}
	}

	local payload = HttpService:JSONEncode({
		embeds = {embed}
	})

	pcall(function()
		HttpService:PostAsync(self.URL, payload, Enum.HttpContentType.ApplicationJson)
	end)
end

return Webhook