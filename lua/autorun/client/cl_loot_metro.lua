ENUM_KEY_MOUSE_LOOTING = { [107] = true, [108] = true, [109] = true, [110] = true, [111] = true }

function input.IsKeyOrMouseDown( key )
	if ( ENUM_KEY_MOUSE_LOOTING[key] ) then
		return input.IsMouseDown( key )
	else
		return input.IsKeyDown( key )
	end
end

hook.Add( "PlayerBindPress", "PBP_lootSystem", function( ply, bind, pressed )
	if ( bind == "+use" ) then
		local LS = LocalPlayer().lootSystem
		if ( input.LookupBinding( "+use" ) ~= LS.useKey ) then
			LS.useKey = input.LookupBinding( "+use" ) 
			LS.decimalKey = 0
			for i = 0 , 159 do
				if ( input.LookupKeyBinding( i ) == "+use" ) then
					LS.decimalKey = i
				end
			end
		end		
	end
end )

hook.Add( "InitPostEntity", "PGL_lootSystem", function()
	LocalPlayer().lootSystem = {}
	local LS = LocalPlayer().lootSystem
	LS.lootPercent = 0
	LS.timeBeginLooting = 0
	LS.lootEntity = nil
	LS.canLoot = false
	LS.isKeyDown = false
	LS.useKey = input.LookupBinding( "+use" ) 
	LS.decimalKey = 0
	LS.Smooth = 0
	for i = 0 , 159 do
		if ( input.LookupKeyBinding( i ) == "+use" ) then
			LS.decimalKey = i
		end
	end
	LOOTING_HUD_TEXT = "Press [" .. string.upper(LocalPlayer().lootSystem.useKey) .. "] to loot"	
end)


local SW, SH, LV = ScrW(), ScrH(), CurTime()
hook.Add( "HUDPaint", "HP_lootSystem", function()
	local LS = LocalPlayer().lootSystem
	local ent = LocalPlayer():GetEyeTraceNoCursor().Entity
	local dt = CurTime() - LV
	
	draw.SimpleText( LS.lootPercent, "DermaDefault", 0, 0, Color( 255, 255, 255, 255 ), 0, 4 )
	if ( ent == NULL ) then return end
	if ( ent:GetNWBool( "isLoot" ) and CurTime() > ent:GetNWInt( "nextSearch" ) and LocalPlayer():GetPos():Distance( ent:GetPos() ) < 110 ) then
		LS.Smooth = math.Clamp( LS.Smooth + ( 450 * dt ), 0, 255 )
		if ( input.IsKeyOrMouseDown( LS.decimalKey ) and LS.isKeyDown == false ) then
			LS.isKeyDown = true
			LS.canLoot = true
			LS.timeBeginLooting = CurTime()
			surface.PlaySound( "looting_system/act_loot_" .. math.random( 1, 3 ) .. ".wav" )
		end
		if ( LS.isKeyDown and LS.canLoot and CurTime() > ent:GetNWInt( "nextSearch" ) ) then
			LS.lootPercent = ((CurTime() - LS.timeBeginLooting)/ ent:GetNWInt( "timeToLoot" ) )*100
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawRect( SW*0.3, SH*0.55, (SW*0.4)*(LS.lootPercent*0.01), SH*0.02 )
			surface.SetDrawColor( 255, 255, 255, 5 )
			surface.DrawRect( SW*0.3, SH*0.55, SW*0.4, SH*0.02 )
			if ( LS.lootPercent >= 100 ) then
				net.Start( "Net_requestLoot" )
					net.WriteEntity( ent )
				net.SendToServer()
				LS.canLoot = false
			end
		end
	else
		LS.Smooth = math.Clamp( LS.Smooth - ( 1200 * dt ), 0, 255 )
		LS.timeBeginLooting = CurTime()
	end
	if ( input.IsKeyOrMouseDown( LS.decimalKey ) == false and LS.isKeyDown ) then
		LS.isKeyDown = false
		LS.canLoot = true
		LS.lootPercent = 0
	end
	
	draw.SimpleText( LOOTING_HUD_TEXT, "CloseCaption_Bold", SW/2, SH*0.58, Color( 255, 255, 255, LS.Smooth ), 1, 2 )
	LV = CurTime()
end )







