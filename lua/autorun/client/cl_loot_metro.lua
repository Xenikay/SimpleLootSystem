local LOOTING_HUD_TEXT = "Press [USE] to loot"
local SmoothedProgress = 0

hook.Add( "InitPostEntity", "PGL_lootSystem", function()
	LocalPlayer().lootSystem = {}
	local LS = LocalPlayer().lootSystem
	LS.Progress = 0
	LS.ProgressBarEnabled = false
	LS.UseStartTime = 0
	LS.useKey = input.LookupBinding( "+use" ) 
	LOOTING_HUD_TEXT = "Press [" .. string.upper(LocalPlayer().lootSystem.useKey) .. "] to loot"	
end)

net.Receive("Loot_EnableProgress", function()
	local enabled = net.ReadBool()
	local LS = LocalPlayer().lootSystem
	if enabled then 
		LS.UseStartTime = CurTime() 
	else 
		LS.UseStartTime = 0 
		LS.Progress = 0 
		SmoothedProgress = 0
	end
	LS.ProgressBarEnabled = enabled
end)


local SW, SH, LV = ScrW(), ScrH(), CurTime()
hook.Add( "HUDPaint", "HP_lootSystem", function()
	local LS = LocalPlayer().lootSystem
	local ent = LocalPlayer():GetEyeTraceNoCursor().Entity

	if ent:GetNWInt("nextSearch") > CurTime() or not ent:GetNWBool("isLoot")  or LocalPlayer():GetPos():Distance(ent:GetPos()) > 110 then return end
	
	if LS.ProgressBarEnabled then
		LS.Progress = ((CurTime() - LS.UseStartTime) / ent:GetNWInt("timeToLoot")) * 100
		if LS.Progress > 100 then LS.Progress = 100 end
		SmoothedProgress = math.Approach(SmoothedProgress, LS.Progress, (LS.Progress - SmoothedProgress) / 2)

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( SW*0.3, SH*0.55, (SW*0.4)*(SmoothedProgress*0.01), SH*0.02 )
		surface.SetDrawColor( 255, 255, 255, 5 )
		surface.DrawRect( SW*0.3, SH*0.55, SW*0.4, SH*0.02 )
	end

	draw.SimpleText( LOOTING_HUD_TEXT, "CloseCaption_Bold", SW/2, SH*0.58, Color( 255, 255, 255, 255 ), 1, 2 )
end )
