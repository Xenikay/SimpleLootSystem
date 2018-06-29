local LOOTING_HUD_TEXT = "Press [USE] to loot"

hook.Add( "InitPostEntity", "PGL_lootSystem", function()
	LocalPlayer().lootSystem = {}
	local LS = LocalPlayer().lootSystem
	LS.Progress = 0
	LS.ProgressBarEnabled = false
	LS.useKey = input.LookupBinding( "+use" ) 
	LS.Smooth = 0
	LOOTING_HUD_TEXT = "Press [" .. string.upper(LocalPlayer().lootSystem.useKey) .. "] to loot"	
end)

net.Receive("Loot_SetDrawProgress", function()
	local Progress = net.ReadUInt(7)
	if Progress > 100 then Progress = 100 end
	LocalPlayer().lootSystem.Progress = Progress
end)

net.Receive("Loot_EnableProgress", function()
	LocalPlayer().lootSystem.ProgressBarEnabled = net.ReadBool()
end)

local SmoothedProgress = 0
local SW, SH, LV = ScrW(), ScrH(), CurTime()
hook.Add( "HUDPaint", "HP_lootSystem", function()
	local LS = LocalPlayer().lootSystem
	local dt = CurTime() - LV
	local ent = LocalPlayer():GetEyeTraceNoCursor().Entity

	if ent:GetNWInt("nextSearch") > CurTime() then return end	

	draw.SimpleText( LS.Progress, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ), 0, 4 ) 	if ent:GetNWBool( "isLoot" ) and LocalPlayer():GetPos():Distance( ent:GetPos() ) < 110  then
		LS.Smooth = math.Clamp( LS.Smooth + ( 450 * dt ), 0, 255 )
		SmoothedProgress = math.Approach(SmoothedProgress, LS.Progress, (LS.Progress - SmoothedProgress) / 2)
		
		if LS.ProgressBarEnabled then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( SW*0.3, SH*0.55, (SW*0.4)*(SmoothedProgress*0.01), SH*0.02 )
			surface.SetDrawColor( 255, 255, 255, 5 )
			surface.DrawRect( SW*0.3, SH*0.55, SW*0.4, SH*0.02 )
		end
	
		LS.Smooth = math.Clamp( LS.Smooth - ( 1200 * dt ), 0, 255 )

		
		draw.SimpleText( LOOTING_HUD_TEXT, "CloseCaption_Bold", SW/2, SH*0.58, Color( 255, 255, 255, 255 ), 1, 2 )
		LV = CurTime()
	end
end )

