require "TSLib"
require "iphone6"
require "iphone6p"

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy);
	mSleep(1000);
end

function goBack(...)
	-- body
	tap(23,84);
	mSleep(1000);
end


--跳转到所有团课界面
function geToAllCourcesPage()
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(200)
	if sysint >= 700 and sysint <= 710 then
		pull_the_screen(320,560,100)	--滑动，露出设置按钮
	else
		pull_the_screen(320,560,-100)	--滑动，露出设置按钮
	end
	mSleep(1000)
	
	--tap(303,185);	--点击关注
	if sysint >= 700 and sysint <= 710then
		tap(336,330);	--点击关注
	else
		tap(303,185);	--点击关注
	end
	repeat
		mSleep(500)
	until getColor(264,582) == 0xffffff
	
	sucess = false;
	repeat
		mSleep(500);
		tap(80,188);	--点击第一个关注的头像
		repeat
			mSleep(500)
		until getColor(478, 1085) == 0x5cd390
		
		mSleep(1000)
		pull_the_screen(320,560,-50)
		mSleep(500)
		step = 0;
		repeat
			-- body
			tap(575,650+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(200)
			step = step + 1;
		until getColor(478, 1085) ~= 0x5cd390
		
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(1000)
			nLog("waiting...")
		until isColor(447,192,0xffffff,85) or (isColor( 319,  550, 0xffffff, 85) and isColor( 425,  549, 0xffffff, 85))
		
		if isColor( 464,  210, 0xffffff, 85) and isColor( 459,  356, 0xffffff, 85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack();
			goBack();
		end
		mSleep(1000);
	until sucess == true
	
	mSleep(1000);
	nLog("成功进入课程详情页");
	return 0; 
end

function getDistance(recognize)
	-- body
	local data = strSplit(recognize)
	local num = strSplit(data[2],".")
	return tonumber(num[1]);
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	sysver = getOSVer();    --获取系统版本
	sysint = tonumber(string.sub(sysver, 1, 1)..string.sub(sysver, 3,3)..string.sub(sysver, 5, 5));
	
	recognize = ocrText(538, 201, 742, 259, 0);  --OCR 英文识别
	mSleep(500); 
	result = getDistance(recognize)
	dialog("识别出的字符："..result, 0);
	
	if	result < 20 then
		nLog("target")
	else
		nLog("not target")
	end
	
	mSleep(1000)
	m,n = findColorInRegionFuzzy(0x9960fd,90,1,599,745,1232); 
	nLog("m = "..m.."   n = "..n)
	recognize = ocrText(538,n,742,n+58, 0);  --OCR 英文识别
	mSleep(500); 
	result = getDistance(recognize)
	dialog("识别出的字符："..result, 0);
	
	if	result < 20 then
		nLog("target")
	else
		nLog("not target")
	end
	closeLog("脚本评价记录");  --关闭日志
end

main()