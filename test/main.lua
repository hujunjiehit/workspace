require "TSLib"
 
function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function main()
	-- body
	--[[path = getSDCardPath();
	deviceBrand = getDeviceBrand();
	deviceModel = getDeviceModel(); 
	nLog("deviceBrand = "..deviceBrand.."   deviceModel = "..deviceModel);
	if deviceModel == "Micromax AO5510" then
		nLog("hello,".."大神f2");
	else
		nLog("hello,".."S6-nt");
	end
	]]
	pull_the_screen(320,800,-600)
	
	
end

main()