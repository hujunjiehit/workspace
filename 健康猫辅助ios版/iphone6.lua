require "TSLib"

function goBack_iphone6(...)
	-- body
	tap(26,84);
	mSleep(1000);
end

function login_iphone6(userName,passWord)
	
	nLog("now begin to login iphone6");
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(658,1282);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	tap(666,269) --收起输入法键盘
	mSleep(500)
		
	tap(283,401);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(500);
		
	tap(333,492);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	repeat
		tap(530,601); --点击登陆按钮
		mSleep(1000);
    until getColor(424, 176) ~= 0x3aab47
	

	nLog(userName.."登录成功");
	
	tap(658,1282);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(500)
end

function logout_iphone6()
	tap(658,1282);		 --点击我的tab，拉起登陆界面 
	mSleep(500);
	
	tap(380,1100);	--进入设置
	mSleep(1000);
	
	tap(279, 891);	--点击退出登录
	mSleep(1500)
	
	tap(469, 714);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end


function gotoPingjiaPage_iphone6()
	
	tap(658,1282);	 --点击我的tab
	mSleep(500);
	
	tap(386,464); --点击我的订单
	repeat
		mSleep(1000);
	until ( getColor(396,526) == 0xffffff and getColor(394,612) == 0xffffff and getColor(462,569) == 0xffffff ) or getColor(280,540) == 0xf2f2f2 --加载进度判断
	
	tap(385,84); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	
	
	tap(370,249); 	 --选择私教团购订单
	repeat
		mSleep(1000);
	until getColor(396,526) == 0xffffff and getColor(394,612) == 0xffffff and getColor(462,569) == 0xffffff		--加载进度判断
	pull_the_screen(320,560,50)	--滑动到顶,避免漏掉第一个
	mSleep(1000);
	nLog("成功进入评价详情页");
end

function startToPingjia_iphone6(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,514,139,743,1327);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	for index = begin,8 do	
		nLog("index = "..index.."   y  = "..tostring(200+153*(index-1)));
		y = 200+152*(index-1);
		tap(400,200+152*(index-1));	
		
		repeat
			mSleep(500)
			nLog("正在加载课程详情页 wait...");
		until getColor(94,  426) ~= 0xffffff
		--此处有可能网络出错
		
		mSleep(500);
		
		if getColor(274, 1280) == 0x5cd390 then  --可以评价
			
			nLog("可以评价。");
	
			tap(274, 1280)
			mSleep(1000);
			
			tap(330,570);	--点击输入框，获取焦点
			mSleep(500);
			inputText("很好非常好");
			mSleep(500);
			
			tap(610,330);	--点击空白，取消输入法键盘
			mSleep(500);
			
			repeat
				tap(274, 1280)	--点击提交评价
				mSleep(1000)
			until getColor(274,1280) ~=  0x5cd390
			--根据color_next判断下一步动作
			--1.color_next == 0x33c774 未跳转，还在当前页面，表示网络出错
			--2.color_next == 0xf2f2f2 跳转成功，表示评价成功
			
			mSleep(500)
			if getColor(274,1280) == 0x5cd390 then
				--评价失败
				--todo ********************************************************
				nLog("评价失败。");
				goBack_iphone6();
				goBack_iphone6();
			else
				--评价成功
				goBack_iphone6();
				nLog("评价成功。");
				flag_count = flag_count + 1;
			end
		else	
			nLog("已经评价过了，直接返回。");
			goBack_iphone6();
		end
	end
	nLog("成功进行了"..flag_count.."条评价");
	return flag_count;
end

function doTheWork_pingjia_iphone6(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6(userName,passWord);
		mSleep(500)
		
		gotoPingjiaPage_iphone6();
		
		num1 = startToPingjia_iphone6(1);
		nLog("num1 = "..num1);
		
		pull_the_screen(320,560,-508)
		mSleep(1000)
		
		num2 = startToPingjia_iphone6(4);
		nLog("num2 = "..num2);
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..num1+num2.."条评价");
		
		goBack_iphone6();
		
		logout_iphone6();
		mSleep(1000);
	end
end


function main_iphone6(...)
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
	
	UINew({titles="脚本配置iphone6",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,自动登录,添加帐号"})
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
			
			doTheWork_pingjia_iphone6();
			
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

			setScreenScale(true, 640, 1136) 
			
			doTheWork_xiadan();
			
			setScreenScale(false)
		end
	elseif mode == "自动登录" then
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
			
			login_iphone6(userName,passWord);
		
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
