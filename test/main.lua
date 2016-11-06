require "TSLib"
 
function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function goBack(...)
	-- body
	tap(23,84);
	mSleep(1000);
end

function goBack_iphone6(...)
	-- body
	tap(26,84);
	mSleep(1000);
end

--跳转到所有团课界面
function geToAllCourcesPage_iphone6()
	tap(658,1282);	 --点击我的tab
	mSleep(500)
	
	tap(351,332);	--点击关注
	repeat
		mSleep(500)
	until getColor(373,499) == 0xffffff and getColor(371,600) == 0xffffff
	
	tap(80,190);	--点击第一个关注的头像
	repeat
		mSleep(500)
	until getColor(566, 1287) == 0x5cd390 
	
	mSleep(1000)
	pull_the_screen(320,560,-50)
	mSleep(500)
	step = 0;
	repeat
		-- body
		tap(685,980+step*20); --每次下滑20px，尝试点击改点坐标
		mSleep(500)
		step = step + 1;
	until getColor(566, 1287) ~= 0x5cd390
	
	repeat
		mSleep(500);
	until getColor(590,523) == 0xffffff and getColor(599,697) == 0xffffff
	
	nLog("成功进入课程详情页");
	return 0; 
end

function startToXiadan_iphone6(begin)
	for index = begin,7 do	
		nLog("index = "..index.."   y  = "..tostring(208+161*(index-1)));
		y = 208+161*(index-1);
		
		tap(420,208+161*(index-1));
		repeat
			mSleep(500)
			nLog("loading..1")
		until getColor(379,519) == 0xffffff  --加载完毕
		
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if getColor(580, 1285) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack_iphone6();
		elseif getColor(580, 1285) == 0xffffff then
			--还在当前页面，什么都不做
		else
			tap(625,1285); --点击报名
			repeat
				mSleep(500)
				nLog("loading..2")
			until getColor(580, 1285) == 0x459e6c or getColor(580, 1285) == 0x33c774 or getColor(710,643) == 0xbfbfbf or getColor(608,  588) == 0x999999  --加载完毕
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if getColor(580,1084) == 0x459e6c or getColor(710,643) == 0xbfbfbf then
				nLog("已经选过课了，返回进行下一个")
				tap(380,820);
				mSleep(500);
				goBack_iphone6();
			elseif getColor(608,  588) == 0x999999 then
				--iphone6 课程撤销  待处理****************************************
				nLog("课程已撤销，返回点击好的")
				tap(317, 626);
				mSleep(1000);
				goBack();
			else
				nLog("可以选课")
				repeat
					-- body
					tap(586,1284);  --点击稍后支付
					mSleep(1000)
					m,n = findColorInRegionFuzzy(0x007aff, 90, 110,530, 630,800); 
					nLog("m = "..m.."   n = "..n);
				until m ~= -1 and n ~= -1
				mSleep(500);
				
				tap(372,771);   --选课成功，点击我知道了
				mSleep(1000);
				goBack_iphone6();
			end
		end
		

	end
end


function main()
	init(0);
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	
	results = {};
	flag_index = 0;
	--pull_the_screen(320,560,-30)
	--geToAllCourcesPage_iphone6();
	
	startToXiadan_iphone6(1);
	pull_the_screen(320,560,-240)
	mSleep(2000)
	startToXiadan_iphone6(4);
	closeLog("脚本评价记录");  --关闭日志
end

main()