 require "TSLib"

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

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

--跳转到所有团课界面
function geToAllCourcesPage()
	tap(626,1131); --点击我的tab
	mSleep(500);
	
	tap(362,334);	--点击关注
	--[[repeat
		mSleep(500);
	until getColor(575, 203) == 0xd8d8d8]]
	
	mSleep(5000);
	
	tap(303,203);
	mSleep(2000);
	
	pull_the_screen(320,800,-600)
	mSleep(500)
	
	step = 0;
	repeat
		-- body
		tap(647,660+step*20); --每次下滑20px，尝试点击改点坐标
		mSleep(500)
		step = step + 1;
	until getColor(542,1228) ~= 0x33c774
	
	mSleep(1500)
	return 0; 
end

function logout()
	tap(320,1020);	--进入设置
	repeat
		mSleep(500);
	until getColor(288, 793) ~= 0xffffff
	
	tap(350,799);	--点击退出登录
	deviceModel = getDeviceModel();
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
			mSleep(1000)
			color_next = getColor(510,1230)		--点击之后，该点的颜色
		until color_next == color_current or color_next == 0x33c774 or color_next == 0xd8d8d8 or color_next == 0xfafafa or color_next == 0x53c987
		
		nLog("color_next:"..string.format("%X",color_next));
		
		--根据color_next判断下一步动作
		--1.color_next == color_current 未跳转，还在当前页面，表示没有更多课程
		--2.color_next == 0x33c774 绿色按钮，表示可以报名
		--3.color_next == 0xd8d8d8 灰色按钮，表示已经报名了
	
		if color_next == 0x33c774 or color_next == 0x53c987 then
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
				
				--repeat 
					--mSleep(1000);
				--until getColor(510, 1230) == 0x33c774
				
				mSleep(2000);
				--选课成功
				nLog("选课成功")
				table.insert(results,flag_index);
				mSleep(1000)
				os.execute("input keyevent 4");
				mSleep(1000)
			end
		elseif color_next == color_current then
			nLog("未跳转")
		else
			--color_next == 0xd8d8d8 灰色按钮，表示已经报名了 或者 网络出错
			os.execute("input keyevent 4");
			mSleep(1000)
			nLog("按钮灰色,已经报名了")
		end
	end
end

function doTheWorkOnce(...)
	-- body
	info = strSplit(data[index],",");
	userName = info[1];
	passWord = info[2];
	
	nLog("index = "..index.."   userName = "..userName.."   passWord = "..passWord);
	
	
	
	mSleep(500)
	
	results = {};
	flag_index = 0;
	
	login(userName,passWord)	--登录
	
	r = geToAllCourcesPage();
	nLog("r == "..r);
	if r == 0 then
		--成功跳转到所有团课界面
		nLog("go to allcoursees page sucess");
	else
		--跳转失败
		nLog("failed");
		--logout();
		lua_exit();
	end

	mSleep(1000)
	startToXiadan(1)

	pull_the_screen(320,800,-600)
	mSleep(2000)
	startToXiadan(6)
	
	os.execute("input keyevent 4");
	mSleep(1500)
	os.execute("input keyevent 4");
	mSleep(1500)
	os.execute("input keyevent 4");
	mSleep(1500)
	
	
	for var = 1,3 do
		--playAudio("alert.mp3"); --播放警报铃声
		vibrator();             --振动
		mSleep(1000);           --延迟 1 秒
	end
	
	if #results > 0 then
		str = "";
		for i = 1,#results do
			str = str..results[i].." ";
		end
		mSleep(1000)
		dialog("成功选上的课程(从上往下数)：\n"..str,0);
	end
end

function doTheWorkOneByOne(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];

	
		nLog("index = "..index.."   userName = "..userName.."   passWord = "..passWord);
	
		mSleep(500)
	
		results = {};
		flag_index = 0;
	
		login(userName,passWord)	--登录
	
		r = geToAllCourcesPage();
		nLog("r == "..r);
		if r == 0 then
			--成功跳转到所有团课界面
			nLog("go to allcoursees page sucess");
		else
			--跳转失败
			nLog("failed");
			--logout();
			lua_exit();
		end

		mSleep(1000)
		startToXiadan(1)

		pull_the_screen(320,800,-600)
		mSleep(2000)
		startToXiadan(6)
	
		os.execute("input keyevent 4");
		mSleep(1500)
		os.execute("input keyevent 4");
		mSleep(1500)
		os.execute("input keyevent 4");
		mSleep(1500)
		logout();
	end
end

function doTheWorkGoToPay(...)
	-- 登录，并进入付款界面
	info = strSplit(data[index],",");
	userName = info[1];
	passWord = info[2];
	
	nLog("index = "..index.."   userName = "..userName.."   passWord = "..passWord);
	
	mSleep(500)
	
	login(userName,passWord)	--登录
	
	mSleep(500)
	tap(326,576);
	repeat
		nLog("loading...");
		mSleep(1000);
	until getColor(385,633) ~= 0xc6c6c6 
	mSleep(500)
	tap(51,1230);
end

function write_info(str)
	-- body
	path = getSDCardPath();
	return writeFile(path.."/info.txt",{str});
end

function main()
	init(0)
	initLog("test", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("test","[DATE] init log OK!!!"); 
	showFloatButton(false);
	
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
	UIRadio("mode","约完课暂停付款,约完课自动换号,登录并进入付款界面,手动添加新帐号")
	UILabel("请选择需要下单的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("choice_name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();

	index = tonumber(strSplit(choice_name)[1]);
	
	setScreenScale(true, 720, 1280);	--分辨率缩放
	
	if mode == "约完课暂停付款" then
		doTheWorkOnce();
	elseif mode == "约完课自动换号" then
		--dialog("here", time)
		doTheWorkOneByOne();
	elseif mode == "登录并进入付款界面" then
		doTheWorkGoToPay();
	else
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
	end
	setScreenScale(false, 720, 1280);
	
	closeLog("test");  --关闭日志
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

main()