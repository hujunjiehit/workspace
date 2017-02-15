require "TSLib"
local sz = require("sz")
local cjson = sz.json
local http = sz.i82.http

local name;
local token;

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
	mSleep(1000);
end

function goBack(...)
	-- body
	tap(23,84);
	mSleep(1000);
end

function write_info(str)
	return writeFile("/var/mobile/Media/TouchSprite/res/info.txt",{str});
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	
	mSleep(1000)
	
	--writeFileString("/var/mobile/Media/TouchSprite/res/test.txt","1123456@qq.com---ghhlhklhjkjn","a");
	--writeFileString("/var/mobile/Media/TouchSprite/res/test.txt","234567@qq.com---1113ffaffan","a");
	--writeFileString("/var/mobile/Media/TouchSprite/res/test.txt","abcdefghj@gmail.com---1113ffaffan","a");
	
	data = readFile("/var/mobile/Media/TouchSprite/res/test.txt")
	
	result = strSplit(data[1],"---");
	userName = result[1];
	passWord = result[2];
	
	dialog("读取的文件内容：userName = "..userName.."   passWord = "..passWord,0);
	
	if isFileExist("/var/mobile/Media/TouchSprite/res/test.txt") == true then --如果文件存在 删除文件
		delFile("/var/mobile/Media/TouchSprite/res/test.txt")
	end
	
	--重新写入文件
	for i = 2,#data do
		if data[i] ~= nil and data[i] ~= "" then 
			writeFileString("/var/mobile/Media/TouchSprite/res/test.txt",data[i],"a");
		end
	end


	closeLog("脚本宣传记录");  --关闭日志
end

main()


