--!strict
local Strings: { [string]: string } = require("../Config/Strings")
local Locale = {}
function Locale.text(key: string, values: { [string]: any }?): string
	local text = Strings[key] or key
	return (
		string.gsub(text, "{([%w_]+)}", function(name)
			return if values and values[name] ~= nil then tostring(values[name]) else "{" .. name .. "}"
		end)
	)
end
function Locale.init()
	local service = game:GetService("LocalizationService")
	if service:FindFirstChild("PayTheClown") then
		return
	end
	local localization = Instance.new("LocalizationTable")
	local entries = {}
	for key, source in Strings do
		table.insert(entries, { Key = key, Source = source, Values = { ["en-us"] = source } })
	end
	localization.Name = "PayTheClown"
	localization.SourceLocaleId = "en-us"
	localization:SetEntries(entries)
	localization.Parent = service
end
return Locale
