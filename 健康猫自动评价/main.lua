 require "TSLib"
 
function write_to_log(str_to_write)
	-- body
	path = getSDCardPath();
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
	moveTo(x,y,x,y+dy)
end

function touchClick(x,y)
	touchDown(x, y);
	mSleep(30);
	touchUp(x, y);
end

function login(userName,passWord)
	tap(626,1227); --点击我的tab，拉起登陆界面 
	switchTSInputMethod(true);
	
	mSleep(1000);
	m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
	nLog(m.."----"..n)
	isFirst = true;
	while m == -1 and n == -1 do
		nLog("flag is false");
		mSleep(500);
		tap(400,429);  --点击帐号输入框
		mSleep(1000);
		--[[for var = 1,15 do
			inputText("\b")       --删除输入框中的文字（假设输入框中已存在文字）
		end]]
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");

		mSleep(1000);
		inputText(userName);
	
		mSleep(1000);
		tap(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			--[[for var = 1,15 do
				inputText("\b");     --删除输入框中的文字(假设输入框中已存在文字)
			end]]
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		end
		
		mSleep(1000);
		inputText(passWord);
	
		mSleep(1000)
		tap(529,629); 
		
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
	tap(626,1227); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	tap(236,456); --点击我的订单
	repeat
	mSleep(1000)
	until getColor(386,668) ~= 0xc2c2c2			--加载进度判断
	
	mSleep(1000)
	tap(351,98); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	tap(357,268); 	 --选择私教团购订单
	mSleep(1000)

	repeat
		mSleep(1000);
	until getColor(386,668) ~= 0xc2c2c2
	nLog("loading finish");   --here may be fail, so we need to record the progress
end

function logout()
	tap(626,1227); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	tap(320,1020);	--进入设置
	mSleep(500)
	tap(350,799);	--点击退出登录
	mSleep(500)
	tap(513,675);	--点击确定
	repeat
		mSleep(1000)
	until getColor(501,798) ~= 0x663434  --健康猫logo color
	nLog(userName.."退出登录");
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

function startToPingjia(begin)
	
	flag_count = 0; 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,552,150,719,1279);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	
	switchTSInputMethod(true);
	for index = begin,7 do	
		nLog("index = "..index.."   y  = "..tostring(218+155*(index-1)));
		y = 207+142*(index-1);
		tap(350,218+155*(index-1));		
		repeat
			mSleep(1000)
		until getColor(386,668) ~= 0xc2c2c2		--数据加载完毕
		--此处有可能网络出错
		
		
		if getColor(282, 1231) == 0x33c774 then  --可以评价
			tap(282,1231)
			mSleep(2000);
			
			tap(457,466);	--点击五星
			mSleep(1000);
			
			tap(333,627);	--点击输入框，获取焦点
			mSleep(1000);
			inputText("很好非常好");
			mSleep(1000);
			
			tap(351,1231);	--点击提交评价
			repeat
				nLog("wait for...");
				mSleep(1000)
				color_next = getColor(220,1232)		--点击之后，该点的颜色
			until color_next == 0x33c774 or color_next == 0xf2f2f2
			--根据color_next判断下一步动作
			--1.color_next == 0x33c774 未跳转，还在当前页面，表示网络出错
			--2.color_next == 0xf2f2f2 跳转成功，表示评价成功
			
			mSleep(2000)
			color_next = getColor(220,1232)
			if color_next == 0x33c774 then
				--评价失败，可能网络出错，此时直接返回到列表页
				nLog("评价失败，可能网络异常。");
				os.execute("input keyevent 4");
				mSleep(2000)
				os.execute("input keyevent 4");
				mSleep(2000)
			elseif color_next == 0xf2f2f2 then
				--评价成功
				nLog("评价成功。");
				flag_count = flag_count + 1;
				os.execute("input keyevent 4");
				mSleep(2000)
			end
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
	
	write_to_log("\n\n\n\n脚本开始时间:"..os.date("%c"))
	
	path = getSDCardPath();
	data = readFile(path.."/info.txt") 	--读取文件内容，返回一个table
	str = "";
	for i = 1,#data do
		--nLog(i..":"..data[i])
		result = strSplit(data[i],",")
		if result ~= nill then
			str = str..i.."@第"..i.."个帐号:"..result[1]..",";
		end
	end
	
	UINew({titles="我的脚本",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("请选择从哪一个帐号开始依次往下评价：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("choice_name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	nLog("choice_name = "..choice_name)  --choice_name是UICombo返回的，用户选择的字符串
	
	index = tonumber(strSplit(choice_name)[1]);
	nLog("index = "..index);
	
	
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		mSleep(500)
		
		login(userName,passWord);
		
		mSleep(1000);
		
		gotoPingjiaPage();  --跳转到评价页面
		
		num1 = startToPingjia(1);
		nLog("num1 = "..num1);
		
		pull_the_screen(320,800,-600);
		mSleep(1000)
		
		num2 = startToPingjia(3);
		nLog("num2 = "..num2);
		
		nLog("帐号"..userName.."成功进行了"..num1+num2.."条评价");
		write_to_log("帐号"..userName.."成功进行了"..num1+num2.."条评价")
		
		mSleep(1000)
		os.execute("input keyevent 4")
		mSleep(2000)
		logout();
	end
	
	
	--[[
	path = getSDCardPath();
	file = io.open(path.."/info.txt","r");
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
	
	file:close()]]
	
	closeLog("test");  --关闭日志
end

main()