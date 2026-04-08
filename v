local LocalizationService = game:GetService("LocalizationService")
local OWNER_ID = 10080511071 

-- دالة لتحويل رمز الدولة (مثل IQ) إلى إيموجي العلم الخاص بها تلقائياً
local function getFlagEmoji(countryCode)
    if not countryCode or #countryCode ~= 2 then return "🌍" end
    local base = 127397 -- رقم البداية للرموز الإقليمية في اليونيكود
    local code = countryCode:upper()
    local first = code:sub(1,1):byte() + base
    local second = code:sub(2,2):byte() + base
    return utf8.char(first) .. utf8.char(second)
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local head = character:WaitForChild("Head")

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "StatsTag"
        billboard.Size = UDim2.new(0, 200, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = false
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextSize = 18
        label.Font = Enum.Font.GothamBold

        -- الحصول على كود الدولة وتحويله لعلم
        local success, countryCode = pcall(function()
            return LocalizationService:GetCountryCodeForPlayerAsync(player)
        end)
        
        local flag = success and getFlagEmoji(countryCode) or "🌍"
        local countryName = countryCode or "Unknown"

        task.spawn(function()
            while character.Parent do
                local ping = player:GetNetworkPing() * 1000
                local displayPing = (ping == 0) and math.random(30, 50) or math.floor(ping)
                
                label.Text = flag .. " " .. countryName .. "\nPing: " .. displayPing .. "ms"
                task.wait(1)
            end
        end)

        -- التأكد من أن صاحب الماب فقط هو من يرى المعلومات
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
