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

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	


	closeLog("脚本宣传记录");  --关闭日志
end

main()