require "TSLib"

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy);
	mSleep(1000);
end

function getDistance(recognize)
	-- body
	data = strSplit(recognize)
	if data[2] == nil then
		data = strSplit(recognize,"®")
	end
	data[2] = data[2] or "10000."
	local num = strSplit(data[2],".")
	return tonumber(num[1]);
end

function do_the_work(...)
	--判断第一个单子
	mSleep(500)
	recognize = ocrText(538, 201, 742, 259, 0);  --OCR 英文识别
	nLog("识别出的字符："..recognize);
	mSleep(500); 
	result = getDistance(recognize)
	toast("第一个单子距离"..result.."公里",1);
	
	
	mSleep(500);
	m,n = findColorInRegionFuzzy(0x9960fd,100,1,599,16,1135); 
	nLog("1  m = "..m.."   n = "..n)
	if m ~= -1 and n ~= -1 then
		mSleep(1000)
		recognize = ocrText(538,n,742,n+58, 0);  --OCR 英文识别
		nLog("识别出的字符："..recognize);
		mSleep(500);
		result = getDistance(recognize)
		toast("第二个单子距离"..result.."公里",1);
	end
	
	mSleep(500);
	m,n = findColorInRegionFuzzy(0xd8534f,100,1,599,16,1135); 
	nLog("2  m = "..m.."   n = "..n)
	if m ~= -1 and n ~= -1 then
		mSleep(1000)
		recognize = ocrText(538,n,742,n+58, 0);  --OCR 英文识别
		nLog("识别出的字符："..recognize);
		mSleep(500);
		result = getDistance(recognize)
		toast("第二个单子距离"..result.."公里",1);
	end
	
end

function main_iphone6(...)
	
	UINew({titles="脚本配置iphone6/6p",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("自动刷新时间设置:",15,"left","100,100,100",250,1) --宽度写-1为一行，自定义宽度可写其他数值
	UIEdit("delaytime","刷新间隔","2",15,"center","0,0,255","number",200,1)
	UILabel("(单位秒)",15,"left","100,100,100",280,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIShow();
	
	if delaytime == nil then
		dialog("请先设置自动刷新间隔",0)
		lua_exit()
	end

	mSleep(1000)
	repeat
		
		do_the_work();
			
		pull_the_screen(320,260,400);
		mSleep(delaytime*1000)
	until false
end

function main(...)
	init("0", 0);  --竖屏
	initLog("货拉拉日志", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("货拉拉日志","\n\n\n\n脚本开始时间:"..os.date("%c")); 
			
	width,height = getScreenSize();
	
	nLog("[DATE]"..width.."---"..height);
	
	if (width == 1242 and height == 2208) or (width == 750 and height == 1334) then
		setScreenScale(true, 750, 1334) --以750,1334分辨率为基准坐标进行缩放
		main_iphone6()
		setScreenScale(false) --关闭缩放
	else
		dialog("暂不支持的分辨率，请联系脚本作者", 0);
	end
	
	--[[if width == 640 and height == 1136 then
		main_iphone5();
	elseif width == 640 and height == 960 then
		main_iphone4();
	elseif width == 750 and height == 1334 then
		main_iphone6();
	elseif width == 1242 and height == 2208 then
		main_iphone6p();
	elseif (width == 768 and height == 1024) then
		main_ipad();
	elseif (width == 1536 and height == 2048)  then
		main_ipadair();
	else
		dialog("暂不支持的分辨率，请联系脚本作者", 0);
	end]]
	
	closeLog("货拉拉日志");  --关闭日志
end

main()