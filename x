local LocalizationService = game:GetService("LocalizationService")
local OWNER_ID = 10080511071 

-- قائمة لتحويل الرموز لأسماء دول عربية وأعلام
local countries = {
	["IQ"] = "العراق 🇮🇶",
	["SA"] = "السعودية 🇸🇦",
	["EG"] = "مصر 🇪🇬",
	["AE"] = "الإمارات 🇦🇪",
	["KW"] = "الكويت 🇰🇼",
	["QA"] = "قطر 🇶🇦",
	["OM"] = "عمان 🇴🇲",
	["BH"] = "البحرين 🇧🇭",
	["JO"] = "الأردن 🇯🇴",
	["PS"] = "فلسطين 🇵🇸",
	["LY"] = "ليبيا 🇱🇾",
	["DZ"] = "الجزائر 🇩🇿",
	["MA"] = "المغرب 🇲🇦",
	["SY"] = "سوريا 🇸🇾",
	["LB"] = "لبنان 🇱🇧",
	["YE"] = "اليمن 🇾🇪"
}

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local head = character:WaitForChild("Head")

		-- إنشاء اللوحة
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "LocationTag"
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = false 
		billboard.Parent = head

		local label = Instance.new("TextLabel")
		label.Parent = billboard
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 0) -- لون أصفر
		label.TextStrokeTransparency = 0
		label.TextSize = 18
		label.Font = Enum.Font.GothamBold

		-- جلب كود الدولة من جهاز اللاعب
		local success, code = pcall(function()
			return LocalizationService:GetCountryCodeForPlayerAsync(player)
		end)

		local playerLocation = "غير معروف 🌍"
		if success and code then
			playerLocation = countries[code] or "دولة: " .. code
		end

		-- تحديث البنق والبلد
		task.spawn(function()
			while character.Parent do
				local ping = math.floor(player:GetNetworkPing() * 1000)
				label.Text = playerLocation .. "\nالبنق: " .. ping .. "ms"
				task.wait(1)
			end
		end)

		-- يظهر لك أنت فقط
		if game.Players.LocalPlayer and game.Players.LocalPlayer.UserId == OWNER_ID then
			billboard.Enabled = true
		else
			task.spawn(function()
				while not game.Players:GetPlayerByUserId(OWNER_ID) do task.wait(1) end
				billboard.Enabled = true
			end)
		end
	end)
end)
