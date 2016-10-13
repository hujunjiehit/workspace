


function main()
	-- body
	path = getSDCardPath();
	
	deviceBrand = getDeviceBrand();
	deviceModel = getDeviceModel(); 
	
	nLog("deviceBrand = "..deviceBrand.."   deviceModel = "..deviceModel);
	
	if deviceModel == "Micromax AO5510" then
		nLog("hello,".."大神f2");
	else
		nLog("hello,".."S6-nt");
	end
	
		
	
	--nLog("hello,world");
	--x, y = findImageInRegionFuzzy("more_info_大神f2.png", 90, 471,  149,  717, 1180, 0xffffff);
	--nLog("x = "..x.."   y = "..y);
	
end

main()