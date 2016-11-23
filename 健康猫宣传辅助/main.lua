require "TSLib"

function goBack(...)
	tap(26,84);
	mSleep(1000);
end

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy,10,200)
end


function do_the_work(begin)
	-- body
	for index = begin,7 do
		y = 407 + 154*(index-1);
		tap(416,407 + 143*(index-1));
		repeat
			mSleep(500);
			nLog("loading..");
		until isColor( 559, 1283, 0x5cd390, 85)
		mSleep(1000);
		
		tap(352,1283);	--点击私聊
		mSleep(1000);
		
		tap(352,1283);	--点击输入框获取焦点
		mSleep(1000);
		
		inputText(data[1]);
		mSleep(2000);
		
		tap(656,1287);
		mSleep(2000);
		
		wLog("脚本宣传记录","成功发送消息:"..num.."--"..os.date("%c")); 
		num = num + 1;
			
		goBack();
		mSleep(500);
		goBack();
	end
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("脚本宣传记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	
	showFloatButton(false);
	
	width,height = getScreenSize();
	nLog("[DATE]"..width.."---"..height);
	
	if isFileExist("/var/mobile/Media/TouchSprite/res/宣传语.txt") == false then
		writeFile("/var/mobile/Media/TouchSprite/res/宣传语.txt",{"亲,还在为下单、评价而烦恼吗？ 这里有健康猫 自动约课 自动评价的脚本，手机全自动操作，省时省力，等你来体验哦，脚本运行在手机上，完全模拟人的操作来控制手机，安全可靠，免费试用24小时。有兴趣的可以去体验下。详情搜索淘宝店铺：游泳乐园，如若有所打扰，请见谅哦[愉快]"})
	end
	
	data = readFile("/var/mobile/Media/TouchSprite/res/宣传语.txt") 	--读取文件内容，返回一个table
	
	nLog(data[1]);
	
	num = 1;
	mSleep(2000);
	do_the_work(1);
		
	repeat
		mSleep(1000);
		pull_the_screen(320,560,-408)
		mSleep(2000);
		do_the_work(3);
	until false;

	
	showFloatButton(true);
	closeLog("脚本宣传记录");  --关闭日志
end

main()