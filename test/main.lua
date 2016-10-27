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
	for index = begin,8 do	
		nLog("index = "..index.."   y  = "..tostring(207+142*(index-1)));
		y = 207+142*(index-1);
		
		flag_index = flag_index + 1;
		
		repeat
			mSleep(1000);
        until getColor(470,207+142*(index-1)) == 0xffffff or getColor(470,207+142*(index-1)) == 0xfafafa
		
		color_current = getColor(510,1230)   --点击之前，该点的颜色
		
		tap(470,207+142*(index-1));
		mSleep(1000)
		
		repeat
			nLog("wait for---loading the detail course page");
			mSleep(2000)
			color_next = getColor(510,1230)		--点击之后，该点的颜色
		until color_next == color_current or color_next == 0x33c774 or color_next == 0xd8d8d8 or color_next == 0xfafafa
		
		nLog("color_next:"..string.format("%X",color_next));
		
		--根据color_next判断下一步动作
		--1.color_next == color_current 未跳转，还在当前页面，表示没有更多课程
		--2.color_next == 0x33c774 绿色按钮，表示可以报名
		--3.color_next == 0xd8d8d8 灰色按钮，表示已经报名了
	
		if color_next == 0x33c774 then
			--color_next == 0x33c774 绿色按钮，表示可以报名
			tap(510,1230);
			mSleep(2000)
			color = getColor(540, 1033);
			if color == 0x666666 then
				--灰色，表示有弹窗，已经下过单了，直接返回
				nLog("已经选过课了，返回进行下一个")
				os.execute("input keyevent 4");
				mSleep(1000)
				os.execute("input keyevent 4");
				mSleep(1000)
			else
				--可以选课
				repeat
					if getColor(95,1220) == 0xff8282 then
						--红色的立即支付
						tap(510,1230); --点击稍后支付，然后循环等待，直到付款成功
					end
					
					mSleep(2000);
					nLog("please whait...")
				until getColor(265, 1223) == 0xffffff 
				
				--选课成功
				nLog("选课成功")
				table.insert(results,flag_index);
				mSleep(1000)
				os.execute("input keyevent 4");
				mSleep(1000)
			end
		elseif color_next == 0xd8d8d8 or color_next == 0xfafafa then
			--color_next == 0xd8d8d8 灰色按钮，表示已经报名了 或者 网络出错
			os.execute("input keyevent 4");
			mSleep(2000)
			nLog("按钮灰色,已经报名了")
		else
			nLog("no more course")
		end
	end
end


function main()
	init(0);
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	results = {};
	flag_index = 0;
	startToXiadan(1)
	
	closeLog("脚本评价记录");  --关闭日志
end

main()