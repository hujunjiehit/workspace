require "TSLib"

function goBack_iphone6p(...)
	-- body
	--[[if getColor(293,136) ~= 0x39af4d then
		pull_the_screen(293,136,-50);
		mSleep(500);
	end]]
	tap(48,126);
	mSleep(500);
end

function login_iphone6p(userName,passWord)
	
	nLog("now begin to login iphone6p");
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(1088, 2126);	 --点击我的tab，拉起登陆界面 
	repeat
		mSleep(500)
	until isColor(614,888,0xf2f2f2,95)
	
	tap(1000,344) --收起输入法键盘
	mSleep(500)
		
	tap(538,600);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(1500);
		
	tap(538,740);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	tap(900,900); --点击登陆按钮
	repeat
		mSleep(2000);
    until getColor(684,286) ~= 0x3aab47
	

	nLog(userName.."登录成功");
	
	tap(1088, 2126);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(500)
end

function logout_iphone6p()
	tap(1088, 2126);		 --点击我的tab，拉起登陆界面 
	mSleep(500);
	
	tap(628,1658);	--进入设置
	mSleep(1000);
	
	--tap(622, 1336);	--点击退出登录
	--mSleep(1500)
	repeat
		mSleep(300);
		tap(622, 1336);	--点击退出登录
		mSleep(1000);
	until isColor(770,1186,0x64cf95, 85) or isColor(770,1186,0x62cd93,85)
	
	mSleep(500)
	tap(872, 1182);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end


--去到评价页面
function gotoPingjiaPage_iphone6p()
	
	tap(1088, 2126);	 --点击我的tab
	mSleep(500);
	
	tap(654,686); --点击我的订单
	repeat
		mSleep(1000);
	until isColor(620,994,0xffffff,80)  or isColor(636,1808,0xf2f2f2,80) --加载进度判断

	--[[if getColor(293,136) ~= 0x39af4d then
		pull_the_screen(293,136,-50);
		mSleep(500);
	end]]
	mSleep(1000);
	
	tap(628,126); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	
	tap(620,370); 	 --选择私教团购订单
	repeat
		mSleep(1000);
	until getColor(618,994) == 0xffffff and getColor(714,966) == 0xffffff	--加载进度判断
	pull_the_screen(320,560,1000)	--滑动到顶,避免漏掉第一个
	mSleep(1000);
	nLog("成功进入评价详情页");
end

function startToPingjia_iphone6p(begin)
		
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	mSleep(200)
	m,n = findColorInRegionFuzzy(0x33c774,80,990,204,1228,2180);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		mSleep(500);
		return flag_count;
	end
	
	mSleep(500);
	
	--开始评价
	index = 1;
	repeat
		x = m + 80;
		y = n + 32 + 230*(index-1);
		
		nLog(" index = "..index);
		
		if y >= 2200 then
			return flag_count;
		end
		
		mSleep(500);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(464,2132,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(500); --加载数据
			until isColor(254,326,0x7ce5aa,85) or getColor(138,204) ~= 0xffffff
		
			tap(633,921);	--点击输入框，获取焦点
			mSleep(500);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(500);
			tap(1136,296);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(464, 2132);   --点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(464, 2132);   --点击提交评价
					times = 0;
				end
			until isColor(464,2132,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			--repeat
				mSleep(1000);
			--until isColor(762,898,0xffffff,95) or isColor(744,994,0xffffff,95)
		end
		index = index + 1;
	until false 
end

function doTheWork_pingjia_iphone6p(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6p(userName,passWord);
		mSleep(500)
		
		gotoPingjiaPage_iphone6p();
		
		sum_num = 0;
		num1 = startToPingjia_iphone6p(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(320,560,-508)
			mSleep(1500)
			num1 = startToPingjia_iphone6p(5);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack_iphone6p();
		
		logout_iphone6p();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage_iphone6p()
	tap(1088, 2126);	 --点击我的tab
	mSleep(200)
	
	repeat
		tap(580,496);	--点击关注
		mSleep(1000)
		nLog("正在加载关注列表")
	until isColor(1052,284,0xc4c4c4,85) and isColor(634,893, 0xffffff, 85)
	
	sucess = false;
	repeat
		mSleep(500);
		repeat
			tap(130,296);	--点击第一个关注的头像
			mSleep(1000)
			nLog("正在加载私教小屋")
		until isColor(952,2132,0x5cd390,90)
	
		mSleep(1000)
		pull_the_screen(320,560,-50)
		--mSleep(1000)
		step = 0;
		repeat
		-- body
			tap(1138,1500+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(50)
			step = step + 1;
		until isColor(952,2132,0x5cd390,90) == false
	
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(500);
		until (isColor(616,550, 0xffffff,85) and isColor(830,292,0xffffff,85)) or (isColor( 542, 1017, 0xffffff, 85) and isColor(663, 1016,0xffffff, 85))
		
		mSleep(500);
		if isColor(616,550, 0xffffff,85) and isColor(830,292,0xffffff,85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack_iphone6p();
			goBack_iphone6p();
		end
		mSleep(500);
	until sucess == true
	
	nLog("成功进入课程详情页");
	return 0; 
end

function startToXiadan_iphone6p(begin)
	for index = begin,8 do	
		nLog("index = "..index.."   y  = "..tostring(300+242*(index-1)));
		y = 300+242*(index-1);
		
		if index == 1 then
			mSleep(500)
			repeat
				tap(664,300);
				mSleep(1000)
				nLog("loading..1")
			until isColor(624,990,0xffffff,80) and (isColor(962,2132,0xaaaaaa,80) or isColor(962,2132,0x5cd390,80))--加载完毕
		else
			mSleep(500)
			tap(664,300+242*(index-1));
			repeat
				mSleep(1000)
				nLog("loading..1")
			until isColor(624,990,0xffffff,80) --加载完毕
		end

		
		mSleep(500);
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if isColor(962,2132,0xaaaaaa,80) then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack_iphone6p();
		elseif isColor(1018, 2145,0xffffff,95) or isColor(1018, 2145,0xc8c7cc,95) then
			--还在当前页面，什么都不做
		else
			mSleep(500);
			repeat
				if isColor(956,2132,0x5cd390,95) then
					tap(962,2132); --点击报名
				end
				mSleep(500)
				nLog("loading..2")
			until isColor(956,2132,0x33744f,95) or isColor(778,2136,0x33c774,95) --加载完毕
	
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if isColor(962,2132,0x33744f,95) or isColor(1176,1094,0x8c8c8c,95) then
				nLog("已经选过课了，返回进行下一个")
				tap(618,1344);	--点击关闭
				mSleep(500);
				goBack_iphone6p();
			--[[elseif getColor(608,  588) == 0x999999 then
				--iphone6 课程撤销  待处理****************************************
				nLog("课程已撤销，返回点击好的")
				tap(317, 626);
				mSleep(1000);
				goBack_iphone6();]]
			elseif isColor(778,2136,0x33c774,85) then
				nLog("可以选课")
				repeat
					mSleep(500)
					tap(912,2130);  --点击稍后支付
					mSleep(500)
				until isColor(758,2130,0x1f7746,95) or isColor(1190,1002,0x999999,95)
				 
				mSleep(500);
				repeat
					tap(608,1256);   --选课成功，点击我知道了
					mSleep(500)
				until isColor(956,2132,0x5cd390,95) or isColor(956,2132,0xaaaaaa,95)
				
				mSleep(500);
				goBack_iphone6p();
			else
				--进入空白页面
				nLog("进入空白页面")
				mSleep(1000);
				goBack_iphone6p(500);
				goBack_iphone6p(500);
			end
		end
		

	end
end

function doTheWork_xiadan_iphone6p(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6p(userName,passWord);
		
		mSleep(500);
		
		geToAllCourcesPage_iphone6p();
		
		mSleep(500);
		
		startToXiadan_iphone6p(1)
		mSleep(1000)
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(320,560,-340)
			mSleep(2000)
			startToXiadan_iphone6p(5)
		end
		
		
		mSleep(500)
		
		
		if yueke_mode == nil then
			--需要约两个号的课程
			nLog("开始约第二个号的课程")
			mSleep(500);
			goBack_iphone6p();
			goBack_iphone6p();
			
			--回到关注列表页
			mSleep(500);
			if (isColor(1056, 470, 0xc4c4c4, 85)) then
				mSleep(1000)
				--有第二个关注的人
				sucess = false;
				repeat
					mSleep(500);
					repeat
						tap(130,478);	--点击第二个关注的头像
						mSleep(1000)
						nLog("正在加载私教小屋")
					until isColor(952,2132,0x5cd390,90)

					--mSleep(1000)
					--pull_the_screen(320,560,-50)
					mSleep(1000)
					step = 0;
					repeat
					-- body
						tap(1138,1500+step*20); --每次下滑20px，尝试点击改点坐标
						mSleep(50)
						step = step + 1;
					until isColor(952,2132,0x5cd390,90) == false
				
					--可能进入动力秀 或者 团课界面
					repeat
						mSleep(500);
					until (isColor(616,550, 0xffffff,85) and isColor(830,292,0xffffff,85)) or (isColor( 542, 1017, 0xffffff, 85) and isColor(663, 1016,0xffffff, 85))
					
					mSleep(500);
					if isColor(616,550, 0xffffff,85) and isColor(830,292,0xffffff,85) then
						--进入团课界面
						sucess = true;
					else
						--进入动力秀界面
						sucess = false;
						goBack_iphone6p();
						goBack_iphone6p();
					end
					mSleep(1000);
				until sucess == true
				
				mSleep(1000);
				nLog("成功进入第二个私教课程详情页");
				
				startToXiadan_iphone6p(1)
				if pull_count == nil then
					pull_count = 1;
				end
				for k = 1,pull_count do
					pull_the_screen(320,560,-340)
					mSleep(2000)
					startToXiadan_iphone6p(5)
				end
				
				goBack_iphone6p();
				goBack_iphone6p();
				goBack_iphone6p();
				logout_iphone6p();
				mSleep(1000);
			else
				--没有第二个关注的人
				mSleep(1000)
				goBack_iphone6p();
				logout_iphone6p();
				mSleep(1000);
			end
		else
			--不需要约两个号的课程
			toast("不需要约两个号的课程",1);
			goBack_iphone6p();
			goBack_iphone6p();
			goBack_iphone6p();
			
			logout_iphone6p();
			mSleep(1000);
		end
		
		
		--goBack_iphone6p();
		--goBack_iphone6p();
		--goBack_iphone6p();
		
		--logout_iphone6p();
		--mSleep(1000);
	end
end

function doTheWork_fukuan_iphone6p(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6p(userName,passWord);
		
		mSleep(1000);
			
		tap(586,890);
		repeat
			-- body
			mSleep(1000);
		until  getColor(1000, 2130) == 0xcecece or getColor(1000, 2130) == 0xf2f2f2
		
		tap(68,2134);
		mSleep(1000);
		
		toast("付款之后，请进入设置界面",2)
		
		
		repeat
			mSleep(1000);
			nLog("waiting for fukuan...")
		until isColor( 1060,477, 0x4cd864, 85) and isColor( 360,  1337, 0xfc8080, 85) and isColor( 600, 1200, 0xf2f2f2, 85)
		
		nLog("进入设置界面");
		
		choice = dialogRet("是否继续付款下一个？", "继续付款", "结束付款", "", 0);
		if choice == 0 then
			nLog("继续付款下一个");
			
			mSleep(1000);
			repeat
				mSleep(300);
				tap(622, 1336);	--点击退出登录
				mSleep(1000);
			until isColor( 770, 1186, 0x64cf95, 85)
			
			mSleep(500)
			tap(872, 1182);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
		else
			nLog("结束付款");
			
			mSleep(1000);
			repeat
				mSleep(300);
				tap(622, 1336);	--点击退出登录
				mSleep(1000);
			until isColor( 770, 1186, 0x64cf95, 85)
			
			mSleep(500)
			tap(872, 1182);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			return lua_exit();
		end
	end
end


function main_iphone6p(...)
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
	
	UINew({titles="脚本配置iphone6p",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,管理评价语,添加帐号"})
	UILabel("评价时下滑次数：",15,"left","255,0,0") --宽度写-1为一行，自定义宽度可写其他数值
	UIEdit("pull_count","输入下滑次数","1",15,"center","0,0,255")
	UICheck("yueke_mode","只约一个私教号的课","0");
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
			
			if isFileExist("/var/mobile/Media/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
				writeFileString("/var/mobile/Media/TouchSprite/res/评价语.txt","很好非常好\n");
			end
			words = readFile("/var/mobile/Media/TouchSprite/res/评价语.txt");
			words_count = #words;
			
			doTheWork_pingjia_iphone6p();
			
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
			
			doTheWork_xiadan_iphone6p();
			
		end
	elseif mode == "登录付款" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			index = tonumber(strSplit(name)[1]);
			
			doTheWork_fukuan_iphone6p();
		end
	elseif mode == "管理评价语" then
		
		manage_the_pingjia_words();
		
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
