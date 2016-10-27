require "TSLib"
 
function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function goBack(...)
	-- body
	tap(23,84);
	mSleep(1000);
end


function startToXiadan(begin)
	for index = begin,6 do	
		nLog("index = "..index.."   y  = "..tostring(208+160*(index-1)));
		y = 208+160*(index-1);
		
		tap(344,208+160*(index-1));
		repeat
			mSleep(1000)
			nLog("loading..1")
		until getColor(392, 478) == 0xffffff  --加载完毕
		
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		tap(483,1085); --点击报名
		repeat
			mSleep(500)
			nLog("loading..2")
		until getColor(580,1084) == 0x459e6c or getColor(580,1084) == 0x33c774 --加载完毕
		--0x459e6c	 已经报过名了
		--0x33c774   可以报名
		if getColor(580,1084) == 0x459e6c then
			nLog("已经选过课了，返回进行下一个")
			tap(400,724);
			mSleep(500);
			goBack();
		else
			nLog("可以选课")
			repeat
				-- body
				tap(486,1086);  --点击稍后支付
				mSleep(1000)
			until getColor(580,1084) == 0x1f7746   --选课成功的颜色
			mSleep(500);
			
			tap(323,674);   --选课成功，点击我知道了
			mSleep(1000);
			goBack();
		end
	end
end


function main()
	init(0);
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	
	
	--pull_the_screen(320,560,-240)  --
	startToXiadan(1)

	pull_the_screen(320,560,-240)
	mSleep(2000)
	
	startToXiadan(2)
	--startToXiadan(1);
	
	closeLog("脚本评价记录");  --关闭日志
end

main()