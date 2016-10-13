function write_to_log(str_to_write)
	-- body
	log_file = io.open(path.."/log.txt","a");
	log_file:write(str_to_write.."\n");
	log_file:close();
end

function split(str, pat)
     local t = {}
     local fpat = "(.-)" .. pat
     local last_end = 1
     local s, e, cap = str:find(fpat, 1)
     while s do
          if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
          end
          last_end = e+1
          s, e, cap = str:find(fpat, last_end)
     end
     if last_end <= #str then
          cap = str:sub(last_end)
          table.insert(t, cap)
     end
     return t
end

function pull_the_screen(x,y,dy)
	touchDown(x, y);    --在 (150, 550) 按下
	mSleep(30);
	touchMove(x, y+dy);   --移动到 (150, 600)
	mSleep(30);
	touchUp(x, y+dy);
end

function touchClick(x,y)
	touchDown(x, y);
	mSleep(30);
	touchUp(x, y);
end

function login(userName,passWord)
	touchClick(626,1227); --点击我的tab，拉起登陆界面
	mSleep(2000);
	
	switchTSInputMethod(true);
	m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
	nLog(m.."----"..n)
	isFirst = true;
	while m == -1 and n == -1 do
		nLog("flag is false");
		mSleep(500);
		touchClick(400,429);  --点击帐号输入框
		mSleep(1000);
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");

		mSleep(2000);
		inputText(userName);
	
		mSleep(1000);
		touchClick(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		end
		
		mSleep(2000);
		inputText(passWord);
	
		mSleep(1000)
		touchClick(529,629); 
		
		repeat
		mSleep(1000)
		until getColor(408,205) ~= 0x17441c   --健康猫logo color
		
		mSleep(2000)
		m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
		isFirst = false;
	end
	nLog(m.."----"..n)
	nLog(userName.."登录成功");
	switchTSInputMethod(false);
end

function gotoPingjiaPage()
	touchClick(626,1227); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	touchClick(236,456); --点击我的订单
	repeat
	mSleep(1000)
	until getColor(386,668) ~= 0xc2c2c2			--加载进度判断
	
	mSleep(1000)
	touchClick(351,98); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	touchClick(357,268); 	 --选择私教团购订单
	mSleep(1000)
		
	--[[确保一定要进入私教团购订单页面
	repeat
		mSleep(1000)
		touchClick(351,98); 	 --点击上面的私教订单，展开选项
		mSleep(1000)
		touchClick(357,268); 	 --选择私教团购订单
		mSleep(1000)
		x, y = findImageInRegionFuzzy("私教团购订单.png",60, 127,51,648,141,0x22ac39);
		nLog("x = "..x.."   y = "..y);
	until x ~= -1 and y ~= -1]]

	repeat
		mSleep(1000);
	until getColor(386,668) ~= 0xc2c2c2
	nLog("loading finish");   --here may be fail, so we need to record the progress
end

function logout()
	touchClick(626,1227); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	touchClick(320,1020);	--进入设置
	mSleep(500)
	touchClick(350,799);	--点击退出登录
	mSleep(500)
	touchClick(513,675);	--点击确定
	repeat
		mSleep(1000)
	until getColor(501,798) ~= 0x663434  --健康猫logo color
	nLog(userName.."退出登录");
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

function startToPingjia()
	
	switchTSInputMethod(true);
	
	flag_count = 0; 
	
	for index = 1,7 do	
		nLog("index = "..index.."   y  = "..tostring(218+155*(index-1)));
		y = 207+142*(index-1);
		touchClick(350,218+155*(index-1));
		repeat
			mSleep(1000)
		until getColor(386,668) ~= 0xc2c2c2		--数据加载完毕
		
		
		if getColor(282, 1231) == 0x33c774 then  --可以评价
			touchClick(282,1231)
			mSleep(2000);
			
			touchClick(457,466);	--点击五星
			mSleep(2000);
			
			touchClick(333,627);	--点击输入框，获取焦点
			mSleep(2000);
			inputText("很好非常好");
			mSleep(2000);
			
			touchClick(351,1231);	--提交评价
			mSleep(3000)  --#################需要优化
			
			flag_count = flag_count + 1;
			
			os.execute("input keyevent 4");
			mSleep(2000)
		else	
			--已经评价过了，直接返回
			os.execute("input keyevent 4");
			mSleep(2000)
		end
		
	end
	
	nLog("成功进行了"..flag_count.."条评价");
	
	switchTSInputMethod(false);
	
	return flag_count;
end


function main()
	init(0)
	initLog("test", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("test","[DATE] init log OK!!!"); 
	showFloatButton(false);
	
	path = getSDCardPath();
	file = io.open(path.."/info.txt","r");
	
	write_to_log("\n\n\n\n脚本开始时间:"..os.date("%c"))
	
	index = 1
	for line in file:lines() do
		num = tostring(index)
		index = index + 1;
		str = split(line,",")
		userName = str[1]
		passWord = str[2]
		if passWord == nil then
			break;
		end
		
		nLog("\n\n\n第"..num.."个用户,userName："..userName);
		wLog("test","第"..num.."个用户,userName："..userName); 
		login(userName,passWord);
		mSleep(1000);
		
		gotoPingjiaPage();  --跳转到评价页面
		
		num1 = startToPingjia();
		nLog("num1 = "..num1);
		
		
		pull_the_screen(100,550,-110);
		mSleep(2000)
		num2 = startToPingjia();
		nLog("num2 = "..num2);
		
		nLog("帐号"..userName.."成功进行了"..num1+num2.."条评价");
		wLog("test","帐号"..userName.."成功进行了"..num1+num2.."条评价");
		write_to_log("帐号"..userName.."成功进行了"..num1+num2.."条评价")
		
		mSleep(2000)
		os.execute("input keyevent 4")
		mSleep(2000)
		logout();
	end
	
	file:close()
	
	--os.execute("am start -n com.zhanyun.ihealth/com.gzdxjk.healthmall.ui.login.LoginActivity")

	--pull_the_screen(100,550,-110)
	
	closeLog("test");  --关闭日志
end

main()