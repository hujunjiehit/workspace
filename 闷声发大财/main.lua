require "TSLib"

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function startToPingjia_special(begin)
	
	flag_count = 0; 
	
	switchTSInputMethod(true);
	
	repeat
		mSleep(1000)
		m,n = findColorInRegionFuzzy(0x33c774,80,0,50,720,1270);
		if m ~= -1 and n ~= -1 then
			tap(m+2,n+2);
			
			repeat
				mSleep(1000)
				nLog("正在加载课程详情页 wait...");
			until isColor(419,682,0xf2f2f2,95)
			mSleep(500);
			
			if isColor(282, 1231,0x33c774,85) then  --可以评价
				
				tap(333,627);	--点击输入框，获取焦点
				mSleep(1000);
				--inputText("很好非常好");
				
				math.randomseed(getRndNum()) -- 随机种子初始化随机数
				num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
				inputText(words[num]);
				
				mSleep(1000);
				
				tap(351,1231);	--点击提交评价
				repeat
					nLog("wait for...");
					mSleep(2000)
				until isColor(386,668,0xc2c2c2,85) == false
				mSleep(1000);
				
				if isColor(282, 1231,0x33c774,85) then --已经评价过了
					os.execute("input keyevent 4");
					mSleep(1000);
					pull_the_screen(320,800,1000);
					mSleep(2000);
				end
			else	
				--已经评价过了，直接返回
				os.execute("input keyevent 4");
				mSleep(1000)
			end
		end
	until m == -1 and n == -1
	
	nLog("成功进行了"..flag_count.."条评价");
	switchTSInputMethod(false);
	
	return flag_count;
end


function main(...)
	-- body
	init("0");  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	path = getSDCardPath();
	if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
		writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
	end
	words = readFile(path.."/TouchSprite/res/评价语.txt");
	words_count = #words;
		
	startToPingjia_special(1);

	closeLog("脚本宣传记录");  --关闭日志
end

main()