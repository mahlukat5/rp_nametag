local badges,masks,bandanas,datanames,playericons = {},{},{},{},{}

_isLineOfSightClear = isLineOfSightClear
_getScreenFromWorldPosition = getScreenFromWorldPosition
_getElementData = getElementData
_dxGetTextWidth = dxGetTextWidth
_getElementAlpha = getElementAlpha
_getPedBonePosition = getPedBonePosition
_getDistanceBetweenPoints3D = getDistanceBetweenPoints3D
_getElementsByType = getElementsByType
_ipairs = ipairs
_pairs = pairs
_unpack = unpack
_mathfloor = math.floor
_mathmin = math.min
_tostring = tostring
_tableinsert = table.insert

for i,v in _ipairs(ayarlar.icons.extraicons) do
	datanames[v[1]]=true
end
for i,v in _ipairs(ayarlar.updateDatas) do
	datanames[v]=true
end

function renderNametags()
	if isPlayerMapVisible() then return end
	local cx, cy, cz, lx, ly, lz = getCameraMatrix()
	local target = getPedTarget(localPlayer)
	local players = _getElementsByType("player",root,true)
	for i=1,#players do
		local player = players[i]
		local vx,vy,vz = _getPedBonePosition(player, 8)
		local distance = _getDistanceBetweenPoints3D(cx, cy, cz, vx, vy, vz)
		if playericons[player] and _getElementAlpha(player) > 0 and (distance < ayarlar.drawDistance or (target and target == player) ) and _isLineOfSightClear(cx, cy, cz, vx, vy, vz, true, false, false) then
			local sx, sy = _getScreenFromWorldPosition(vx,vy,vz+ayarlar.ypos)
			if sx and sy and not _getElementData(player, "reconx") then
				--> Verileri çekiyoruz
				local r, g, b = getPlayerNametagColor(player)
				--> İconları çekiyoruz
				local xpos, ypos = -6,ayarlar.icons.ypos
				local name, icons, tinted, badgename,extras = _unpack(playericons[player] or {})
				--> İconlardan gelen isime göre nametagın uzunluğunu hesaplıyoruz
				local nw = _dxGetTextWidth(name,ayarlar.textscale,ayarlar.font)
				local nx = sx  - _mathfloor(nw/2) --> Nametagı ortaladık
				if badgename then ypos = ypos+15 end -- eğer badge takılıysa iconların Y konumunu 15 arttır
				
				--> Can barı ve zırh barını yerleştiriyoruz
				local health = _mathfloor(getElementHealth(player))
				local armour = _mathfloor(getPedArmor(player))
				if ayarlar.canbar then
					ypos = ypos+5
					if ayarlar.canbar == "bar" then
						drawHPBar(sx, sy+16, health, distance)
					elseif 	ayarlar.canbar == "yazi" then
						ypos=ypos+5
						dxDrawText("HP: ".."%"..health, nx+1, sy+15, nx+nw+1, sy+26,tocolor(0, 0, 0, 255),1, ayarlar.font,"center",nil)
						dxDrawText("HP: "..getVariableColor(health).."%"..health, nx, sy+14, nx+nw, sy+25,ayarlar.canyazirenk,1, ayarlar.font,"center",nil,false,false,false,true)
					end	
				end
				if ayarlar.zirhbar and armour > 0 then
					ypos = ypos+5
					if ayarlar.zirhbar == "bar" then
						drawArmourBar(sx, sy+22, armour, distance)
					elseif 	ayarlar.zirhbar == "yazi" then
						ypos=ypos+10
						dxDrawText("ZIRH: ".."%"..armour, nx+1, sy+28, nx+nw+1, sy+26,tocolor(0, 0, 0, 255),1, ayarlar.font,"center",nil)
						dxDrawText("ZIRH: "..getVariableColorArmor(armour).."%"..armour, nx, sy+27, nx+nw, sy+25,ayarlar.zirhyazirenk,1, ayarlar.font,"center",nil,false,false,false,true)	
					end	
				end
				--> İconları diziyoruz
				local expectedIcons = _mathmin(#icons, ayarlar.icons.maxIconsPerLine)
				local iconsThisLine,offset = 0,10 * expectedIcons
				for k, v in _ipairs(icons) do
					dxDrawImage(sx-offset+xpos,sy+ypos,ayarlar.icons.genislik,ayarlar.icons.uzunluk,ayarlar.icons.konum..v..".png",0,0,0,tocolor(255,255,255,255))
					iconsThisLine = iconsThisLine + 1
					if iconsThisLine == expectedIcons then
						expectedIcons = _mathmin(#icons - k, ayarlar.icons.maxIconsPerLine)
						offset = 10 * expectedIcons
						iconsThisLine,xpos,ypos = 0,0,ypos+ayarlar.icons.genislik+1
					else
						xpos=xpos+ayarlar.icons.genislik+1
					end
				end
				--> İsimi yazdırıyoruz
				dxDrawText(name, nx+1, sy+1, nx+nw+1, sy+21,ayarlar.golge,ayarlar.textscale, ayarlar.font,"center")
				dxDrawText(name, nx, sy, nx+nw, sy+20,tocolor(r, g, b, 255),ayarlar.textscale, ayarlar.font,"center")
				if extras["ulke"] then
					dxDrawImage(nx-ayarlar.bayrakboyut[1]-2,sy,ayarlar.bayrakboyut[1],ayarlar.bayrakboyut[2],ayarlar.bayrakkonum:format(extras["ulke"]))
				end
			end	
		end
	end	
	local peds = getElementsByType("ped",root,true)
	for i=1,#peds do
		local ped = peds[i]
		local vx, vy, vz = getPedBonePosition(ped, 8)
		local dist = getDistanceBetweenPoints3D(cx, cy, cz, vx, vy, vz)
		local canSee = (_getElementData(ped,"talk") == 1) or (_getElementData(ped, "nametag"))
		if canSee  and (dist < 10 or (target and target == ped) ) and isLineOfSightClear(cx, cy, cz, vx, vy, vz, true, false, false) then
			local sx, sy = getScreenFromWorldPosition(vx, vy, vz+0.3)
			if sx and sy then
				local pedName = getElementData(ped,"name") and _tostring(getElementData(ped,"name")):gsub("_", " ") or "The Storekeeper"
				local pnw = dxGetTextWidth(pedName, 1, "default-bold")
				local pnx = sx  - _mathfloor(pnw/2)
				dxDrawText(pedName, pnx+1, sy+1, pnx+pnw+1, sy+21,ayarlar.golge,1, "default-bold","center")
				dxDrawText(pedName, pnx, sy, pnx+pnw, sy+20,tocolor(255, 255, 255, 255),1, "default-bold","center")
			end
		end
	end
end

function getPlayerIcons(name, player, forTopHUD, distance, status)
	local badge,tinted, masked,icons,extras = false,false, false,{},{}
	for key, value in _pairs(masks) do
		if _getElementData(player, value[1]) then
			_tableinsert(icons, value[1])
			if value[4] then
				masked = true
				name = "Belirsiz Kişi"
				break
			end
		end
	end
	if not forTopHUD then
		--ADMIN / GM TAGS
		if _getElementData(player,"hiddenadmin") ~= 1 then
			if _getElementData(player,"duty_admin") == 1 then
				local adminlevel = _getElementData(player,"admin_level") or 0
				if adminlevel > 5 then
					_tableinsert(icons, "udy_on")
				end
				
				if adminlevel >= 5 then
					_tableinsert(icons, "developeradm")
				elseif adminlevel >= 1 and adminlevel <= 4  then
					_tableinsert(icons, "a"..adminlevel.."_on")
				end
			end
			local suplevel = _getElementData(player,"supporter_level") or 0
			if suplevel and suplevel > 0 and  _getElementData(player,"duty_supporter") == 1 then
				_tableinsert(icons, 'gm')
			end
		end
	
		-- DONATOR NAMETAGS
		if _getElementData(player, "donation:nametag") and _getElementData(player, "nametag_on") then
			_tableinsert(icons, 'donor')
		elseif _getElementData(player, "donation:lifeTimeNameTag") and _getElementData(player, "lifeTimeNameTag_on") then
			_tableinsert(icons, 'donor')
		end
	end
	vehicle = getPedOccupiedVehicle(player)
	local windowsDown = vehicle and _getElementData(vehicle, "vehicle:windowstat") == 1

	if vehicle and not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
		local seat0 = getVehicleOccupant(vehicle, 0) == player
		local seat1 = getVehicleOccupant(vehicle, 1) == player
		if seat0 or seat1 then
			if distance > 1.4 then
				name,tinted = "Belirsiz Kişi (Film)",true
			end
		else
			name,tinted = "Belirsiz Kişi (Film)",true
		end
	end

	if not tinted then

		if masked then
			name = "Belirsiz Kişi ["..getElementData(player, "playerid").."]"
		end
		for k, v in _pairs(badges) do
			local title = _getElementData(player, k)
			if title then
				if bandanas[v[4]]  then
					_tableinsert(icons, 'bandana')
					name = "Belirsiz Kişi (Bandana) [".._getElementData(player, "playerid").."]"
				elseif v[2] == 112 or v[2] == 64 then
					_tableinsert(icons, 'police')
					name = title.."\n"..name
					badge = title
				else
					_tableinsert(icons, "badge" .. tostring(v[5] or 1))
					name = title.."\n"..name
					badge = title
				end
			end
		end

		if tonumber(_getElementData(player, 'cellphoneGUIStateSynced') or 0) > 0 then
			_tableinsert(icons, 'phone')
		end
	end
	if not tinted then
		if not forTopHUD then
			-- local health = getElementHealth( player )
			-- local tick = math.floor(getTickCount () / 1000) % 2
			-- if health <= 10 and tick == 0 then
				-- _tableinsert(icons, 'bleeding')
			-- elseif (health <= 30) then
				-- _tableinsert(icons, 'lowhp')
			-- end
			
			
			if _getElementData(player, "player.Cuffed") then
				_tableinsert(icons, "handcuffs")
			end
			if _getElementData(player, "seatbelt") and vehicle then
				_tableinsert(icons, "seatbelt")
			end
		end

		if getPedArmor( player ) > 50 then
			_tableinsert(icons, 'armour')
		end
	end
		
	if not forTopHUD then
		if windowsDown then
			_tableinsert(icons, 'window2')
		end
	end
	for i,v in _ipairs(ayarlar.icons.extraicons) do
		local data = _getElementData(player, v[1])
		if type(v[3]) ~= "boolean" then
			if data then
				loadstring("kosul="..v[3]:format(type(data) == "boolean" and _tostring(data) or data).."")()
				if kosul then
					_tableinsert(icons, v[2]:format(data))
				end	
			end	
		elseif data == v[3] then
			_tableinsert(icons, v[2])
		end	
	end
	if ayarlar.bayrak then
		local ulke = _getElementData(player,ayarlar.bayrakdataname) or 0
		if ulke > 0 then
			extras["ulke"] = ulke
		end
	end
	return name, icons, tinted,badge,extras
end


function initStuff(res)
	if res == getThisResource() or getResourceName(res) == ayarlar.items then
		for key, value in pairs(exports[ayarlar.items]:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5] }
			if ayarlar.bandanalar[value[5]] then
				bandanas[value[5]] = true
			end
			datanames[value[5]]=true
		end
		
		masks = exports[ayarlar.items]:getMasks()
		for key, value in pairs(masks) do
			datanames[value[1]]=true
		end
		for key, oyuncu in ipairs(getElementsByType("player",root,true)) do
			updateIcons(oyuncu)
			setPlayerNametagShowing(oyuncu, false)
		end
		if res == getThisResource() then
			addEventHandler("onClientRender",root,renderNametags)
		end
	end
end
addEventHandler("onClientResourceStart", root, initStuff)
addEventHandler("onClientMinimize", root,function()
	setElementData(localPlayer, "hud:minimized", true)
end)
addEventHandler("onClientRestore", root,function()
	setElementData(localPlayer, "hud:minimized", false)
end)
addEventHandler("onClientPlayerJoin", root, function()
	setPlayerNametagShowing(source, false)
end)
addEventHandler("onClientPlayerQuit", root, function()
	if playericons[source] then playericons[oyuncu]=nil end
end)

addEventHandler("onClientElementDataChange",root,function(key,old,new)
	if isElement(source) and datanames[key] and isElementStreamedIn(source)  then
		if getElementType(source) == "player" then 
			updateIcons(source) 
		elseif getElementType(source) == "vehicle" then 
			for i,oyuncu in pairs(getVehicleOccupants(source)) do
				updateIcons(oyuncu) 
			end
		end
	end
end)
addEventHandler("onClientElementStreamIn",root,function()
	if isElement(source) and getElementType(source) == "player" then 
		setPlayerNametagShowing(source, false)
		updateIcons(source) 
	end
end)
function updateIcons(oyuncu)
	local id = _getElementData(oyuncu, "playerid")
	if not id then return end
	local name = getPlayerName(oyuncu):gsub("_", " ").." ("..id..")"
	local fakename = _getElementData(oyuncu, "fakename")
	if fakename then name = fakename end
	playericons[oyuncu] = {getPlayerIcons(name,oyuncu,false,2)}
end
function getVariableColor(variable)
	if (variable) > 50 then
		return "#71ffa1"
	elseif (variable) >= 30 and (variable) <= 50 then
		return "#fff471"
	elseif (variable) <= 29 then
		return "#ff7171"
	end
end
function getVariableColorArmor(variable)
	if (variable) > 50 then
		return "#e5dfdf"
	elseif (variable) >= 30 and (variable) <= 50 then
		return "#e5dfdf"
	elseif (variable) <= 29 then
		return "#e5dfdf"
	end
end
function drawArmourBar(x, y, v, d)
	if v < 0 then
		v = 0
	elseif v > 100 then
		v = 100
	end
	dxDrawRectangle(x - 21, y, 42, 5, tocolor(0, 0, 0, 255 - d))
	dxDrawRectangle(x - 20, y + 1, v / 2.5, 3, tocolor(255, 255, 255, 255 - d))
end
function drawHPBar(x, y, v, d)
	if v < 0 then
		v = 0
	elseif v > 100 then
		v = 100
	end
	dxDrawRectangle(x - 21, y, 42, 5, tocolor(0, 0, 0, 255 - d))
	dxDrawRectangle(x - 20, y + 1, v / 2.5, 3, tocolor((100 - v) * 2.55, v * 2.55, 0, 255 - d))
end