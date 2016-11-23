require "TSLib"

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	showFloatButton(false);
	
	sysver = getOSVer();    --获取系统版本
	sysint = tonumber(string.sub(sysver, 1, 1)..string.sub(sysver, 3,3)..string.sub(sysver, 5, 5)); 
	
	toast(sysint,1)
	
	showFloatButton(true);
	closeLog("脚本宣传记录");  --关闭日志
end

main()