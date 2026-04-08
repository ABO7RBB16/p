local LocalizationService = game:GetService("LocalizationService")

-- الآيدي الخاص بك
local OWNER_ID = 10080511071 

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local head = character:WaitForChild("Head")

		-- 1. إنشاء اللوحة
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "StatsTag"
		billboard.Size = UDim2.new(0, 150, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = false -- مخفية عن الجميع افتراضياً
		billboard.Parent = head

		-- 2. التصميم
		local label = Instance.new("TextLabel")
		label.Parent = billboard
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 255) -- لون سماوي لتمييز المعلومات
		label.TextStrokeTransparency = 0
		label.TextSize = 14

		-- 3. الحصول على رمز البلد
		local success, countryCode = pcall(function()
			return LocalizationService:GetCountryCodeForPlayerAsync(player)
		end)
		if not success then countryCode = "??" end

		-- 4. تحديث المعلومات (البنق والبلد)
		task.spawn(function()
			while character.Parent do
				local ping = player:GetNetworkPing() * 1000
				label.Text = string.format("Country: %s\nPing: %dms", countryCode, math.floor(ping))
				task.wait(1)
			end
		end)

		-- 5. إظهارها لك فقط (سواء كانت فوق رأسك أو فوق رؤوس الآخرين)
		-- هذا السطر يضمن أنك إذا كنت صاحب الآيدي، سترى اللوحات فوق الجميع (بما فيهم نفسك)
		local function showToOwner()
			local localPlayer = game.Players:GetPlayerByUserId(OWNER_ID)
			if localPlayer then
				billboard.Enabled = true
			end
		end

		-- تنفيذ التحقق عند دخولك أو إذا كنت موجوداً
		showToOwner()
		game.Players.PlayerAdded:Connect(showToOwner)
	end)
end)
