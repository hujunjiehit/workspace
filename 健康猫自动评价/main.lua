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
	mSleep(500);
	
	target_color = getColor(400,211)	--获取健康猫logo的背景颜色
	nLog("target_color = 0x"..string.format("%X",target_color));
	
	isFirst = true;
	while  target_color ==  0x3aab47 do
		nLog("now begin to login");
		mSleep(500);
		tap(400,429);  --点击帐号输入框
		mSleep(500);
		
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		
		mSleep(500);
		inputText(userName);
		
		mSleep(500);
		tap(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		end
		
		mSleep(500);
		inputText(passWord);
		
		mSleep(500)
		tap(450,629); --点击登陆按钮
		
		repeat
			mSleep(500)
			nLog("loging now...")
		until getColor(450,629) ~= 0xf5f5f5   --正在登录的颜色
		mSleep(2000)
		isFirst = false;
		target_color = getColor(400,211) --获取健康猫logo的背景颜色
	end
	nLog("login sucess!");
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
	tap(351,86); 	 --点击上面的私教订单，展开选项
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
	mSleep(1000)
	tap(350,799);	--点击退出登录
	

	deviceModel = getDeviceModel();
	write_to_log(deviceModel);
	if deviceModel == "Meitu M4" then  
		mSleep(1000)
		tap(610,806);	--点击确定
	else
		mSleep(1000)
		tap(610,720);	--点击确定
	end

	
	
	repeat
		mSleep(1000)
	until getColor(501,798) ~= 0x663434  --健康猫logo color
	mSleep(1000)
	nLog(userName.."退出登录");
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

function startToPingjia(begin)
	
	flag_count = 0; 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,0,50,720,1280);
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
			nLog("正在加载课程详情页 wait...");
		until getColor(82,194) ~= 0xffffff	--数据加载中的颜色
		--此处有可能网络出错
		
		mSleep(1000);
		
		if getColor(282, 1231) == 0x33c774 then  --可以评价
			tap(282,1231)
			mSleep(2000);
			
			tap(457,476);	--点击五星   **************兼容性处理
			mSleep(500);
			
			tap(457,453);	--点击五星   **************兼容性处理，兼容模拟器
			mSleep(500);
			
			tap(457,466);	--点击五星
			mSleep(500);
			
			tap(333,627);	--点击输入框，获取焦点
			mSleep(2000);
			--inputText("很好非常好");
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
				
			mSleep(2000);
			
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

function doTheWork_pingjia(...)
	-- body
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
			until getColor(82,194) ~= 0xffffff	--数据加载中的颜色
			--此处有可能网络出错
			
			mSleep(1000);
		
			if getColor(282, 1231) == 0x33c774 then  --可以评价
				tap(282,1231)
				mSleep(2000);
				
				tap(333,627);	--点击输入框，获取焦点
				mSleep(1000);
				--inputText("很好非常好");
				
				math.randomseed(getRndNum()) -- 随机种子初始化真随机数
				num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
				inputText(words[num]);
				
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
	until m == -1 and n == -1
	
	nLog("成功进行了"..flag_count.."条评价");
	switchTSInputMethod(false);
	
	return flag_count;
end

function doTheWork_pingjia_special(...)
		-- body
		for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		mSleep(500)
		
		login(userName,passWord);
		
		mSleep(1000);
		
		gotoPingjiaPage();  --跳转到评价页面
		
		num1 = startToPingjia_special(1);
		nLog("num1 = "..num1);
		
		pull_the_screen(320,800,-600);
		mSleep(1000)
		
		num2 = startToPingjia_special(3);
		nLog("num2 = "..num2);
		
		nLog("帐号"..userName.."成功进行了"..num1+num2.."条评价");
		write_to_log("帐号"..userName.."成功进行了"..num1+num2.."条评价")
		
		mSleep(1000)
		os.execute("input keyevent 4")
		mSleep(2000)
		logout();
	end
end

function write_info(str)
	-- body
	path = getSDCardPath();
	return writeFile(path.."/info.txt",{str});
end

function write_new_pingjia(new_word)
	-- body
	path = getSDCardPath();
	return writeFile(path.."/TouchSprite/res/评价语.txt",{new_word});
end

function manage_the_pingjia_words(...)
	-- body
	path = getSDCardPath();
	if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
		writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
	end

	repeat
		words = readFile(path.."/TouchSprite/res/评价语.txt");
		local pingjia_words = "";
		local check_string = "";
		local int counts = #words;
		for i = 1,#words do
			--nLog(i..":"..data[i])
			pingjia_words = pingjia_words..words[i]..",";
			check_string = check_string.."check"..i..",";
		end
		UINew({titles="管理评价语",okname="添加",cancelname="取消"})
		UILabel("管理评价语",22,"center","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UILabel("\n当前评价语如下：",18,"left","0,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UICheck(check_string,pingjia_words,"");
		
		UILabel("\n\n输入您要添加的评价语(不少于五个字)：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UIEdit("new_word","此处输入要添加的评价语","",18,"center","0,0,255")
		
		UILabel("\n评价时会从所有的评价语里面随机选择一个",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UIShow();
		
		if new_word == nil then
			--
		elseif new_word ~= nil and getStrNum(new_word) < 5 then
			dialog("评价语不能小于5个字", 0)
		else
			if write_new_pingjia(new_word) == true then
				dialog("评价语添加成功", 0);
			else
				dialog("评价语添加失败", 0);
			end
			
		end
	until (false)

	
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
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio("mode","自动评价功能,评价查漏版本,管理评价语,手动添加帐号")
	UILabel("请选择从哪一个帐号开始依次往下评价：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("choice_name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	
	UIShow();
	
	index = tonumber(strSplit(choice_name)[1]);
	nLog("index = "..index);
	
	setScreenScale(true, 720, 1280);
	
	if mode == "手动添加帐号" then
		repeat
			UINew({titles="添加帐号界面",okname="添加",cancelname="取消"})
			UILabel("输入帐号：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_username","此处输入您的帐号","",15,"center","0,0,255")
			UILabel("输入密码：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_password","此处输入您的密码","",15,"center","0,0,255")
			UIShow();
	
			nLog("input_username:"..input_username);
			nLog("input_password:"..input_password);
			choice = dialogRet("请确认您要添加的帐号和密码：\n 帐号："..input_username.."\n".."密码："..input_password,"重新输入","确认添加","", 0);
			if choice == 1 then
				nLog(" now ready to add data");
				result = write_info(input_username..","..input_password..",");
				nLog("add result:"..tostring(result));
				if result == true then
					dialog("帐号添加成功",0);
				else
					dialog("帐号添加失败",0);
				end
			end
		until false
	elseif mode == "评价查漏版本" then
		if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
			writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
		end
		words = readFile(path.."/TouchSprite/res/评价语.txt");
		words_count = #words;
				
		doTheWork_pingjia_special();
		
	elseif mode == "管理评价语" then
		manage_the_pingjia_words();
	else
		if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
			writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
		end
		words = readFile(path.."/TouchSprite/res/评价语.txt");
		words_count = #words;
		doTheWork_pingjia();
	end
	setScreenScale(false, 720, 1280)
	closeLog("test");  --关闭日志
end

main()