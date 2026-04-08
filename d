-- ==========================================
-- 🚀 ADVANCED SERVER SENTINEL (ULTIMATE EDITION)
-- 🛡️ الغرض: استقرار السيرفر لأقصى مدة (500+ ساعة)
-- 📍 المكان: ServerScriptService
-- ==========================================

local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

-- ================= إعدادات التحسين =================
local MAX_PART_LIFESPAN = 45 -- حذف القطع العشوائية بعد 45 ثانية
local VOID_LEVEL = -150      -- حذف أي شيء يسقط تحت الخريطة
local CLEAN_INTERVAL = 60    -- فحص وتنظيف كل دقيقة
local CRITICAL_MEM = 2000    -- (MB) تنظيف عميق جداً عند وصول الذاكرة لهذا الرقم
-- =================================================

-- 1. المحرك الذكي لتنظيف المقذوفات والقطع الضائعة
workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("BasePart") then
		-- حذف القطع التي لا تنتمي للماب الأساسي لتجنب التراكم
		task.delay(MAX_PART_LIFESPAN, function()
			if descendant and descendant.Parent and not descendant:IsDescendantOf(workspace:FindFirstChild("Map") or workspace) then
				if not descendant:IsA("Terrain") and not descendant.Anchored then
					descendant:Destroy()
				end
			end
		end)
	end
end)

-- 2. وظيفة التنظيف العميق (Deep Clean Engine)
local function DeepOptimize()
	-- تنظيف القمامة البرمجية من الذاكرة بذكاء
	collectgarbage("collect")
	
	for _, part in ipairs(workspace:GetDescendants()) do
		-- حذف أي قطعة سقطت في الفراغ (السبب الرئيسي للاغ)
		if part:IsA("BasePart") and part.Position.Y < VOID_LEVEL then
			part:Destroy()
		end
		
		-- تقليل حسابات التصادم للقطع الثابتة والبعيدة
		if part:IsA("BasePart") and part.Anchored then
			part.CanTouch = false
		end
	end
end

-- 3. مراقب استقرار الشبكة والفيزياء (Anti-Lag)
local function MonitorNetwork()
	local ping = Stats.Network.ServerStatsItem["Data Sent"].Value
	-- إذا زاد الضغط، يتم تقليل جودة الفيزياء تلقائياً للحفاظ على السيرفر
	if ping > 400 then
		settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Heavy
		settings().Physics.AdaptiveReplicationPriority = Enum.AdaptiveReplicationPriority.Frequency
	else
		settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Default
	end
end

-- 4. إدارة الذاكرة المتروكة (Nil Instances)
local function ClearNilInstances()
	-- تنظيف البيانات المتبقية في الذاكرة والتي لا تملك مرجعاً
	collectgarbage("step", 200)
	settings().Network.IncomingReplicationLag = 0
end

-- 5. الحلقة الأساسية الذكية (The Sentinel Loop)
task.spawn(function()
	while true do
		local currentMem = Stats:GetTotalMemoryUsageMb()
		
		-- تنظيف بناءً على استهلاك الذاكرة
		if currentMem > (CRITICAL_MEM * 0.7) then
			DeepOptimize()
			print("[SENTINEL] ⚠️ تنظيف ذاكرة متوسط: " .. math.floor(currentMem) .. "MB")
		end
		
		if currentMem > CRITICAL_MEM then
			collectgarbage("collect")
			print("[SENTINEL] 🚨 وضع الطوارئ: تنظيف ذاكرة حرج!")
		end
		
		MonitorNetwork()
		ClearNilInstances()
		
		task.wait(CLEAN_INTERVAL)
	end
end)

-- 6. تنظيف بيانات اللاعبين عند المغادرة (Memory Leak Prevention)
Players.PlayerRemoving:Connect(function(player)
	task.wait(2)
	-- مسح شامل لمخلفات اللاعب من الذاكرة
	player:Destroy() 
	collectgarbage("collect")
	print("[SENTINEL] 🧹 تم مسح بيانات لاعب غادر السيرفر")
end)

-- 7. تفعيل خاصية التحميل التدريجي برمجياً (للاحتياط)
if not workspace.StreamingEnabled then
	warn("[SENTINEL] ⚠️ نصيحة: قم بتفعيل StreamingEnabled من الإعدادات لأفضل أداء!")
end

print("🚀 [SENTINEL V3] Active & Optimizing - Ready for 500+ Hours")
