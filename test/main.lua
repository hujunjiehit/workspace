require "TSLib"
 
function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function main()
	init(0);
	initLog("test", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
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
	nLog("hello,".."S6-nt");
	setScreenScale(true, 720, 1280);
	
	data = {};
	table.insert(data,7);
	
	table.insert(data,8);
	
	result = "";
	for i = 1,#data do
		result = result..data[i].." ";
	end
	
	mSleep(1000)
	dialog("可能没选中的课程："..result,0);
	
	setScreenScale(false, 720, 1280);
	
	closeLog("test");  --关闭日志
end

main()