require "TSLib"
require "iphone6"
require "iphone6p"

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

function goBack(...)
	-- body
	tap(23,84);
	mSleep(1000);
end

function login(userName,passWord)
	
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	tap(524,206) --收起输入法键盘
	mSleep(500)
	
	target_color = getColor(355,200)	--获取健康猫logo的背景颜色
	nLog("target_color = 0x"..string.format("%X",target_color));
	
	isFirst = true;
	while  target_color ==  0x3aab47 do
		nLog("now begin to login");
		
		tap(295,404);	 --点击帐号输入框
		mSleep(500)
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		mSleep(500)
		inputText(userName);
		mSleep(500);
		
		tap(400,484);   --点击密码输入框
		mSleep(500);
		if isFirst == false then
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
			mSleep(500)
		end
		inputText(passWord);
		mSleep(500);
		
		tap(458,598); --点击登陆按钮
		repeat
			mSleep(500)
			nLog("loging now...")
		until getColor(231,340) ~= 0x303030   --正在登录
		mSleep(500)
		isFirst = false;
		target_color = getColor(355,200) --获取健康猫logo的背景颜色
	end
	nLog(userName.."登录成功");
	
	tap(560,1083);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(500)
end

function gotoPingjiaPage()
	
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	pull_the_screen(320,560,-50)	--滑动到顶，方便定坐标
	mSleep(1000)
	
	tap(313,313); --点击我的订单
	repeat
		mSleep(1000)
	until getColor(264,582) ~= 0x333333	and getColor(264,582) ~= 0x3a3a3a		--加载进度判断
	
	tap(323,82); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	tap(322,249); 	 --选择私教团购订单

	repeat
		mSleep(1000);
	until getColor(264,582) ~= 0x333333	and getColor(264,582) ~= 0x3a3a3a
	pull_the_screen(320,560,50)	--滑动到顶,避免漏掉第一个
	mSleep(1000)
	nLog("成功进入评价详情页");
end


function startToPingjia(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	
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
			mSleep(1000);
			inputText("很好非常好");
			mSleep(500);
			
			tap(525,190);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(320,1080);	--点击提交评价
			repeat
				mSleep(1000)
			until getColor(325,532) == 0xffffff and getColor(315, 920) == 0xefeff4
			
			
			--根据color_next判断下一步动作
			--1.color_next == 0x33c774 未跳转，还在当前页面，表示网络出错
			--2.color_next == 0xf2f2f2 跳转成功，表示评价成功
			
			mSleep(1000)
			if getColor(315, 920) == 0xffffff then
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


function logout()
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	pull_the_screen(320,560,-50)	--滑动，露出设置按钮
	mSleep(1000)
	
	tap(300,956);	--进入设置
	mSleep(1000)
	
	tap(300,892);	--点击退出登录
	mSleep(1500)	--不能太小，要等对话框出来
	
	
	tap(450,617);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end


function doTheWork_pingjia(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		mSleep(2000)
		
		gotoPingjiaPage();
		mSleep(1000);
		
		for k = 1,40 do
			--nLog(i..":"..data[i])
			toast(k,1)
			startToPingjia(1);
			mSleep(2000);
			
			pull_the_screen(320,560,-508)
			mSleep(3000)
		end 
		--[[
		repeat
			startToPingjia(1);
			mSleep(1000);
			
			pull_the_screen(320,560,-508)
			mSleep(1000)
			--先判断需不需要评价，通过找颜色，如果不需要直接返回
			m,n = findColorInRegionFuzzy(0x33c774,80,448,133,625,1022);
		until m == -1 and n == -1]]
		
		goBack();
		
		logout();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage()
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	pull_the_screen(320,560,-50)	--滑动，露出设置按钮
	mSleep(1000)
	
	tap(303,185);	--点击关注
	repeat
		mSleep(500)
	until getColor(264,582) == 0xffffff
	
	tap(80,188);	--点击第一个关注的头像
	repeat
		mSleep(500)
	until getColor(478, 1085) == 0x5cd390 
	
	mSleep(1000)
	pull_the_screen(320,560,-50)
	mSleep(500)
	step = 0;
	repeat
		-- body
		tap(575,750+step*20); --每次下滑20px，尝试点击改点坐标
		mSleep(500)
		step = step + 1;
	until getColor(478, 1085) ~= 0x5cd390
	mSleep(1000)
	nLog("成功进入课程详情页");
	return 0; 
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
		
		
		if getColor(469, 1085) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack();
		elseif getColor(469, 1085) == 0xffffff then
			--还在当前页面，什么都不做
		else
			mSleep(1000);
			tap(483,1085); --点击报名
			repeat
				mSleep(1000)
				nLog("loading..2")
			until getColor(580,1084) == 0x459e6c or getColor(580,1084) == 0x33c774 or getColor(608,  588) == 0xbfbfbf or getColor(608,  588) == 0x999999  --加载完毕
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if getColor(580,1084) == 0x459e6c or getColor(608,  588) == 0xbfbfbf then
				nLog("已经选过课了，返回进行下一个")
				tap(400,724);
				mSleep(500);
				goBack();
			elseif getColor(608,  588) == 0x999999 then
				nLog("课程已撤销，返回点击好的")
				tap(317, 626);
				mSleep(1000);
				goBack();
			else
				nLog("可以选课")
				repeat
					-- body
					tap(486,1086);  --点击稍后支付
					mSleep(1000)
					m,n = findColorInRegionFuzzy(0x007aff, 90, 53,420, 628,737); 
					nLog("m = "..m.."   n = "..n);
				until m ~= -1 and n ~= -1
				mSleep(500);
				
				tap(323,674);   --选课成功，点击我知道了
				mSleep(1000);
				goBack();
			end
		end
		

	end
end

function doTheWork_xiadan(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		
		geToAllCourcesPage();
		
		mSleep(1000);
		
		startToXiadan(1)

		pull_the_screen(320,560,-240)
		mSleep(2000)
	
		startToXiadan(2)
		
		goBack();
		goBack();
		goBack();
		
		logout();
		mSleep(1000);
	end
end

function write_info(str)
	-- body
	return writeFile("/var/mobile/Media/TouchSprite/res/info.txt",{str});
end

function main_iphone5(...)
	-- body
	data = readFile("/var/mobile/Media/TouchSprite/res/info.txt") 	--读取文件内容，返回一个table
	str = "";
	for i = 1,#data do
		--nLog(i..":"..data[i])
		result = strSplit(data[i],",")
		if result ~= nill and result[1] ~= " " then
			str = str..i.."@第"..i.."个帐号:"..result[1]..",";
		end
	end
	
	--nLog("str = "..str);
	
	UINew({titles="脚本配置(特殊版本)",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,添加帐号"})
	UILabel("请选择需要登录的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	if mode == "自动评价" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			nLog("开始评价, name = "..name);
			
			index = tonumber(strSplit(name)[1]);
			nLog("index = "..index);
			
			doTheWork_pingjia();
			
		end
	elseif mode == "自动约课" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			nLog("开始下单, name = "..name);
			
			index = tonumber(strSplit(name)[1]);
			nLog("index = "..index);
			
			doTheWork_xiadan();
	
		end
	elseif mode == "登录付款" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			nLog("name = "..name);
		
			index = strSplit(name)[1];
			nLog("index = "..index);
			
			info = strSplit(data[tonumber(index)],",");
			
			userName = info[1];
			passWord = info[2];
			
			nLog("userName = "..userName.."   passWord = "..passWord);
			
			mSleep(1000)
			
			login(userName,passWord);
			tap(560,1083);	 --点击我的tab，拉起登陆界面 
			mSleep(500)
			pull_the_screen(320,560,-50)	--滑动，露出设置按钮
			mSleep(1000)
	
			tap(264,443);
			repeat
				-- body
				mSleep(500);
			until  getColor(481, 1090) == 0xcecece or getColor(481, 1090) == 0xf2f2f2
			tap(46,1086);
			mSleep(1000);
		end
	elseif mode == "添加帐号" then
		repeat
			UINew({titles="添加帐号界面",okname="添加",cancelname="取消"})
			UILabel("输入帐号：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_username","此处输入您的帐号","",15,"center","0,0,255")
			UILabel("输入密码：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_password","此处输入您的密码","",15,"center","0,0,255")
			UIShow();
	
			nLog("input_username:"..input_username);
			nLog("input_password:"..input_password);
			choice = dialogRet("请确认您要添加的帐号和密码：\n 帐号："..input_username.."\n".."密码："..input_password, "确认添加", "重新输入", "", 0);
			if choice == 0 then
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
end 

function beforeUserExit(...)
	-- body
	showFloatButton(true);
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	
	showFloatButton(false);
	
	width,height = getScreenSize();
	nLog("[DATE]"..width.."---"..height);
	if width == 640 and height == 1136 then
		main_iphone5();
	elseif width == 750 and height == 1334 then
		main_iphone6();
	else
		main_iphone6p();
	end
	
	showFloatButton(true);
	closeLog("脚本评价记录");  --关闭日志
end

main()