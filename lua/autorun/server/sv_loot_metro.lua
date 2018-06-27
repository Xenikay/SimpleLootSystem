util.AddNetworkString( "Net_requestLoot" )
net.Receive( "Net_requestLoot", function( len, ply )
	local NEnt = net.ReadEntity()
	if ( CurTime() > NEnt:GetNWInt( "nextSearch" ) ) then
		NEnt:Loot( ply )
	end
end)



