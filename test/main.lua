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

function startToPingjia(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,448,133,625,1022);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	for index = begin,6 do	
		nLog("index = "..index.."   y  = "..tostring(195+154*(index-1)));
		y = 195+154*(index-1);
		tap(346,195+154*(index-1));	
		
		repeat
			mSleep(500)
			nLog("正在加载课程详情页 wait...");
		until getColor(390,434) == 0xffffff
		--此处有可能网络出错
		
		mSleep(1000);
		
		if getColor(232, 1080) == 0x5cd390 then  --可以评价
			
			nLog("可以评价。");
			
			tap(232, 1080)
			mSleep(1000);
			
			tap(280,600);	--点击输入框，获取焦点
			mSleep(500);
			inputText("很好非常好");
			mSleep(500);
			
			tap(525,190);	--点击空白，取消输入法键盘
			mSleep(500);
			
			repeat
				tap(320,1080);	--点击提交评价
				mSleep(1000)
			until getColor(320,1080) ~=  0x5cd390
			
			
			--根据color_next判断下一步动作
			--1.color_next == 0x33c774 未跳转，还在当前页面，表示网络出错
			--2.color_next == 0xf2f2f2 跳转成功，表示评价成功
			
			mSleep(1000)
			if getColor(210,1080) == 0x5cd390 then
				--评价失败
				nLog("评价失败。");
				goBack();
				goBack();
			else
				--评价成功
				repeat
					mSleep(500)
					nLog("正在加载课程详情页 wait...");
				until getColor(390,434) == 0xffffff
				
				goBack();
				nLog("评价成功。");
				flag_count = flag_count + 1;
			end
		else	
			nLog("已经评价过了，直接返回。");
			goBack();
		end
	end
	nLog("成功进行了"..flag_count.."条评价");
	return flag_count;
end


function main()
	init("0", 0);  --竖屏
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	
	results = {};
	flag_index = 0;
	--pull_the_screen(320,560,-30)
	--geToAllCourcesPage_iphone6();
	startToPingjia(1);
	closeLog("脚本评价记录");  --关闭日志
end

main()