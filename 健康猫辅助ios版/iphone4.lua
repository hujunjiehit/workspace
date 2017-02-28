require "TSLib"

function goBack_iphone4(...)
	-- body
	tap(26,84);
	mSleep(1000);
end

function login_iphone4(userName,passWord)
	
	nLog("now begin to login iphone4");
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(560,908);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	tap(560,200) --收起输入法键盘
	mSleep(500)
		
	tap(350,408);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(500);
	
	tap(560,200) --收起输入法键盘
	mSleep(500)
	
	tap(350,490);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	tap(560,200) --收起输入法键盘
	mSleep(500)
	
	repeat
		tap(460,600); --点击登陆按钮
		mSleep(2000);
    until getColor(350, 194) ~= 0x3aab47
	
	mSleep(1000);
	nLog(userName.."登录成功");
	
	tap(560,908);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(1000)
end

function logout_iphone4()
	tap(560,908);		 --点击我的tab，拉起登陆界面 
	mSleep(500);
	
	toast(sysint,1);
	if sysint >= 700 and sysint <= 710  then
		pull_the_screen(320,560,-300)	--滑动，露出设置按钮
		mSleep(2000)

		tap(300,725);	--进入设置
		mSleep(1000)
	else
		pull_the_screen(320,560,-300)	--滑动，露出设置按钮
		mSleep(2000)

		tap(300,780);	--进入设置
		mSleep(1000)
	end
	
	repeat
		mSleep(200);
		tap(318, 883);	--点击退出登录
		mSleep(1000);
	until isColor(514,533,0x62cd93,80)
	
	mSleep(500);
	tap(450, 532);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end


function gotoPingjiaPage_iphone4()
	
	tap(560,908);	 --点击我的tab
	mSleep(2000);
	
	pull_the_screen(320,560,200)	--滑动到顶，方便定坐标
	mSleep(2000)
		
	tap(334,441); --点击我的订单
	repeat
		mSleep(1000);
	until (isColor( 364,497,0xffffff,95) and isColor( 320,  455, 0xffffff, 95) and isColor( 380,  346, 0xffffff, 95)) or getColor(347,816) == 0xf2f2f2 --加载进度判断
	
	mSleep(500);
	
	tap(325,84); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	
	
	tap(325,250); 	 --选择私教团购订单
	repeat
		mSleep(1000);
	until isColor(364,497,0xffffff, 95) and isColor(320,455,0xffffff,95) and isColor(380,346,0xffffff,95)		--加载进度判断
	mSleep(500);
	pull_the_screen(320,460,300)	--滑动到顶,避免漏掉第一个
	mSleep(500);
	nLog("成功进入评价详情页");
end

function startToPingjia_iphone4(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,488,167,629,919);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		mSleep(500);
		return flag_count;
	end
	
	mSleep(1000);
	
	--开始评价
	index = 1;
	repeat
		x = m + 50;
		y = n + 20 + 152*(index-1);
		
		nLog(" index = "..index);
		
		if y >= 950 then
			return flag_count;
		end
		
		mSleep(500);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(183,909,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(500); --加载数据
			until isColor(169,217,0x7ce5aa,85) or getColor(98,208) ~= 0xffffff
		
			mSleep(500);
			
			tap(332,624);	--点击输入框，获取焦点
			mSleep(1500);
			
			--math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			--num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			--nLog("评价语："..words[num])
			inputText("很好非常好");
			
			mSleep(1000);
			tap(600,176);	--点击空白，取消输入法键盘
			mSleep(1000);
			
			tap(320, 909);   --点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(320, 909);   --点击提交评价
					times = 0;
				end
			until isColor(161,913,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			repeat
				mSleep(1000);
			until isColor(429,472,0xffffff,95) or isColor(427,401,0xffffff,95)
		end
		index = index + 1;
	until false
end


function doTheWork_pingjia_iphone4(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone4(userName,passWord);
		mSleep(500)
		
		gotoPingjiaPage_iphone4();
		
		sum_num = 0;
		num1 = startToPingjia_iphone4(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			mSleep(1000)
			pull_the_screen(320,560,-420)
			mSleep(2000)
			num1 = startToPingjia_iphone4(4);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack_iphone4();
		
		logout_iphone4();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage_iphone4()

	tap(560,908);	 --点击我的tab
	mSleep(200);
	
	pull_the_screen(320,460,200)	--滑动，方便定坐标
	mSleep(1000)
	--repeat
	--	mSleep(500)
	--until  isColor(100,456,0xff6bac, 85) or isColor( 100,587,0xff5555, 85) or isColor( 101,715,0xff852a, 85)

	repeat
		tap(320,334);	--点击关注
		mSleep(1000)
		nLog("正在加载关注列表")
	until isColor(335,184,0xffffff,90) and isColor(320,430,0xffffff, 90) and isColor(514,189,0xc4c4c4, 90)

	sucess = false;
	repeat
		mSleep(500);
		repeat
			tap(86,190);	--点击第一个关注的头像
			mSleep(1000)
			nLog("正在加载私教小屋")
		until isColor(480,910,0x5cd390,90)
	
		mSleep(1000)
		pull_the_screen(320,560,-100)
		mSleep(500)
		step = 0;
		repeat
			-- body
			tap(580,560+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(100)
			step = step + 1;
		until getColor(480, 910) ~= 0x5cd390
	
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(500);
		until (isColor(456,197, 0xffffff,85) and isColor(446,320,0xffffff,85)) or (isColor( 216,  548, 0xffffff, 85) and isColor(319, 549,0xffffff, 85))
		
		mSleep(500);
		if isColor(456,197, 0xffffff,85) and isColor(446,320,0xffffff,85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack_iphone4();
			goBack_iphone4();
		end
		mSleep(500);
	until sucess == true
	nLog("成功进入课程详情页");
	return 0; 
end

function startToXiadan_iphone4(begin)
	
	mSleep(1000)
	for index = begin,5 do	
		nLog("index = "..index.."   y  = "..tostring(200+161*(index-1)));
		y = 200+161*(index-1);
		
		mSleep(500)
		tap(380,200+161*(index-1));
		repeat
			mSleep(1000)
			nLog("loading..1")
		until isColor(286,506,0xffffff,80)  --加载完毕
		
		mSleep(1000);
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if getColor(460, 910) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack_iphone4();
		elseif getColor(515, 890) == 0xffffff then
			--还在当前页面，什么都不做
		else
			mSleep(500);
			repeat
				tap(535,908); --点击报名
				mSleep(1000)
				nLog("loading..2")
			until isColor(480,909,0x5cd390,95) == false  --加载完毕
		
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if isColor(480,909,0x33744f,95) or isColor(610,535,0x8c8c8c,95) then
				nLog("已经选过课了，返回进行下一个")
				mSleep(1000)
				tap(322,636);
				mSleep(500);
				goBack_iphone4();
			elseif getColor(608,  588) == 0x999999 then
				--iphone6 课程撤销  待处理****************************************
				nLog("课程已撤销，返回点击好的")
				tap(317, 626);
				mSleep(1000);
				goBack_iphone4();
			elseif isColor(410, 909, 0x33c774, 85) then
				nLog("可以选课")
				repeat
					tap(410,909);  --点击稍后支付
					mSleep(1000)
					nLog("loading...3")
				until isColor(410,909,0x1f7746,90) or isColor(410,909,0x1e7646,90) or isColor(621,478,0x999999,99)
				
				mSleep(1000);
				
				tap(316,676);   --选课成功，点击我知道了
				mSleep(500);
				if isColor(410,909,0x1f7746,90) or isColor(410,909,0x1e7646,90) or isColor(621,478,0x999999,99) then
					tap(316,583);   --选课成功，点击我知道了
				end
				mSleep(1000);
				
				goBack_iphone4();
				
			else
				--进入空白页面
				nLog("进入空白页面")
				mSleep(1000);
				goBack_iphone4();
				goBack_iphone4();
			end
		end
		

	end
end

function doTheWork_xiadan_iphone4(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone4(userName,passWord);
		
		mSleep(1000);
		
		geToAllCourcesPage_iphone4();
		
		mSleep(1000);
		
		startToXiadan_iphone4(1)
		if pull_count == nil then
			pull_count = 1;
		end
		
		for k = 1,pull_count do
			mSleep(1000)
			pull_the_screen(320,560,-450)
			mSleep(2000)
			startToXiadan_iphone4(1);
		end
		
		mSleep(1000);
		
		if yueke_mode == nil then
			--需要约两个号的课程
			nLog("开始约第二个号的课程")
			mSleep(1000);
			goBack_iphone4();
			goBack_iphone4();
			
			--回到关注列表页
			mSleep(500);
			if (isColor(513, 314, 0xc4c4c4, 85)) then
				--有第二个关注的人
				sucess = false;
				repeat
					
					mSleep(500);
					repeat
						tap(92,317);	--点击第二个关注的头像
						mSleep(1000)
					until isColor(480,910,0x5cd390,90)
					
					mSleep(1000)
					pull_the_screen(320,560,-100)
					mSleep(500)
					step = 0;
					repeat
						-- body
						tap(580,560+step*20); --每次下滑20px，尝试点击改点坐标
						mSleep(100)
						step = step + 1;
					until getColor(480, 910) ~= 0x5cd390
	
					--可能进入动力秀 或者 团课界面
					repeat
						mSleep(500);
					until (isColor(456,197, 0xffffff,85) and isColor(446,320,0xffffff,85)) or (isColor( 216,  548, 0xffffff, 85) and isColor(319, 549,0xffffff, 85))
					
					mSleep(500);
					if isColor(456,197, 0xffffff,85) and isColor(446,320,0xffffff,85) then
						--进入团课界面
						sucess = true;
					else
						--进入动力秀界面
						sucess = false;
						goBack_iphone4();
						goBack_iphone4();
					end
					mSleep(500);
				until sucess == true

				mSleep(1000);
				nLog("成功进入第二个私教课程详情页");
				
				mSleep(1500);
		
				startToXiadan_iphone4(1)
				if pull_count == nil then
					pull_count = 1;
				end
				
				for k = 1,pull_count do
					mSleep(1000)
					pull_the_screen(320,560,-450)
					mSleep(2000)
					startToXiadan_iphone4(1);
				end
				
				mSleep(1000);
				goBack_iphone4();
				goBack_iphone4();
				goBack_iphone4();
				logout_iphone4();
				mSleep(1000);
			else
				--没有第二个关注的人
				nLog("没有第二个关注的人")
				goBack_iphone4();
				logout_iphone4();
				mSleep(1000);
			end
		else
			--不需要约两个号的课程
			goBack_iphone4();
			goBack_iphone4();
			goBack_iphone4();
			
			logout_iphone4();
			mSleep(1000);
		end
	end
end

function doTheWork_fukuan_iphone4(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone4(userName,passWord);
			
		mSleep(1000);
		
		pull_the_screen(320,560,200)	--滑动到顶，方便定坐标
		mSleep(1000)
	
		tap(294,593);
		repeat
			-- body
			mSleep(500);
		until  getColor(477, 915) == 0xcecece or getColor(477, 915) == 0xf2f2f2
		
		tap(45,913);
		mSleep(1000);
		
		toast("付款之后，请进入设置界面",2)
		
		repeat
			mSleep(1000);
			nLog("waiting for fukuan...")
		until isColor( 529,316, 0x4cd964, 85) and isColor( 192,  882, 0xfc8080, 85) and isColor( 310, 807, 0xf2f2f2, 85)
		
		nLog("进入设置界面");
		
		choice = dialogRet("是否继续付款下一个？", "继续付款", "结束付款", "", 0);
		if choice == 0 then
			nLog("继续付款下一个");
			
			mSleep(1000);
			repeat
				mSleep(200);
				tap(318, 883);	--点击退出登录
				mSleep(1000);
			until isColor(514,533,0x62cd93,80)
	
			mSleep(500);
			tap(450, 532);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			
		else
			nLog("结束付款");
			mSleep(1000);
			repeat
				mSleep(200);
				tap(318, 883);	--点击退出登录
				mSleep(1000);
			until isColor(514,533,0x62cd93,80)
	
			mSleep(500);
			tap(450, 532);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			return lua_exit();
		end
	end
end



function main_iphone4(...)
	-- body
	data = readFile("/var/mobile/Media/TouchSprite/res/info.txt") 	--读取文件内容，返回一个table
	str = "";
	nLog("hello"..#data)
	for i = 1,#data do
		--nLog(i..":"..data[i])
		result = strSplit(data[i],",")
		if result ~= nill and result[1] ~= " " then
			str = str..i.."@第"..i.."个帐号:"..result[1]..",";
		end
	end
	
	sysver = getOSVer();    --获取系统版本
	sysint = tonumber(string.sub(sysver, 1, 1)..string.sub(sysver, 3,3)..string.sub(sysver, 5, 5));
	--nLog("str = "..str);
	
	UINew({titles="脚本配置iphone4",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,添加帐号"})
	UILabel("评价时下滑次数：",15,"left","255,0,0") --宽度写-1为一行，自定义宽度可写其他数值
	UIEdit("pull_count","输入下滑次数","1",15,"center","0,0,255")
	UICheck("yueke_mode","只约一个私教号的课","0");
	UILabel("请选择需要登录的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	--[[for i = 1,pull_count do
		dialog(i,0);
		mSleep(1000);
	end]]
	
	
	if mode == "自动评价" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			nLog("开始评价, name = "..name);
			
			index = tonumber(strSplit(name)[1]);
			nLog("index = "..index);
			
			if isFileExist("/var/mobile/Media/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
				writeFileString("/var/mobile/Media/TouchSprite/res/评价语.txt","很好非常好\n");
			end
			words = readFile("/var/mobile/Media/TouchSprite/res/评价语.txt");
			words_count = #words;
		
			doTheWork_pingjia_iphone4();
			
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

			--setScreenScale(true, 640, 1136) 
			
			doTheWork_xiadan_iphone4();
			
			--setScreenScale(false)
		end
	elseif mode == "登录付款" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			index = tonumber(strSplit(name)[1]);
			
			doTheWork_fukuan_iphone4();
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
