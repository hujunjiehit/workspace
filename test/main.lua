


function main()
	-- body
	path = getSDCardPath();
	
	nLog("hello,world");
	x, y = findImageInRegionFuzzy("私教团购订单.png",80, 127,51,648,141,0x22ac39);
	nLog("x = "..x.."   y = "..y);
	
end

main()