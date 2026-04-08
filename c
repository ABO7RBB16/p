local HttpService = game:GetService("HttpService")
local OWNER_ID = 10080511071 

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local head = character:WaitForChild("Head")

		-- إنشاء اللوحة
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "RealStats"
		billboard.Size = UDim2.new(0, 200, 0, 70)
		billboard.StudsOffset = Vector3.new(0, 4, 0)
		billboard.AlwaysOnTop = true
		billboard.Enabled = false 
		billboard.Parent = head

		local label = Instance.new("TextLabel")
		label.Parent = billboard
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeTransparency = 0
		label.TextSize = 16
		label.Font = Enum.Font.GothamBold

		-- جلب معلومات الدولة الحقيقية من مصدر خارجي
		local countryName = "Loading..."
		task.spawn(function()
			local url = "http://ip-api.com/json/" -- خدمة عالمية لتحديد المواقع
			local success, result = pcall(function()
				return HttpService:GetAsync(url)
			end)

			if success then
				local data = HttpService:JSONDecode(result)
				countryName = data.country or "Unknown"
			else
				countryName = "Error Fetching"
			end
		end)

		-- تحديث البنق والاسم
		task.spawn(function()
			while character.Parent do
				local ping = player:GetNetworkPing() * 1000
				label.Text = "📍 " .. countryName .. "\n⚡ Ping: " .. math.floor(ping) .. "ms"
				task.wait(1)
			end
		end)

		-- إظهارها لك أنت فقط
		task.spawn(function()
			while true do
				local owner = game.Players:GetPlayerByUserId(OWNER_ID)
				if owner then
					billboard.Enabled = true
					break
				end
				task.wait(1)
			end
		end)
	end)
end)
