require "TSLib"

function pull_the_screen_new(x,y,dy)
	moveTo(x,y,x,y+dy,2,50);
	mSleep(500);
end

function goBack_iphone6(delaytime)
	-- body
	delaytime = delaytime or 1000
	tap(26,84);
	mSleep(delaytime);
end

function login_iphone6(userName,passWord)
	
	nLog("now begin to login iphone6");
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(658,1282);	 --点击我的tab，拉起登陆界面 
	repeat
		mSleep(500)
	until isColor(373,609,0xf2f2f2,95)

	
	tap(666,269) --收起输入法键盘
	mSleep(500)
		
	tap(283,401);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(1500);
		
	tap(333,492);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	tap(530,601); --点击登陆按钮
	repeat
		mSleep(2000);
    until getColor(424, 176) ~= 0x3aab47
	
	mSleep(1000);
	nLog(userName.."登录成功");
	
	tap(658,1282);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(500)
end

function logout_iphone6()
	tap(658,1282);		 --点击我的tab，拉起登陆界面 
	mSleep(500);
	
	--old 380,975
	tap(380,1100);	--进入设置
	mSleep(1000);
	
	repeat
		mSleep(200);
		tap(279, 891);	--点击退出登录
		mSleep(1000);
	until isColor(597,718,0x65d095,85) or isColor(588,712,0x62cd92,85)
	
	mSleep(500);
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
	
	mSleep(500);
	
	tap(385,84); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	
	
	tap(370,249); 	 --选择私教团购订单
	repeat
		mSleep(1000);
	until isColor(396,526,0xffffff,95) and isColor(394,612,0xffffff,95) and isColor(462,569,0xffffff,95)		--加载进度判断
	mSleep(500);
	pull_the_screen(320,560,1000)	--滑动到顶,避免漏掉第一个
	mSleep(500);
	nLog("成功进入评价详情页");
end

function startToPingjia_iphone6(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,587,139,740,1329);
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
		
		if y >= 1330 then
			return flag_count;
		end
		
		mSleep(500);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(274, 1280,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(500); --加载数据
			until isColor(193,217,0x7ce5aa,85) or getColor(97,205) ~= 0xffffff
		
			tap(330,570);	--点击输入框，获取焦点
			mSleep(500);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(500);
			tap(610,330);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(274, 1280);   --点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(274, 1280);   --点击提交评价
					times = 0;
				end
			until isColor(274,1280,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			--repeat
				mSleep(1000);
			--until isColor(450,533,0xffffff,95) or isColor(445,609,0xffffff,95)
		end
		index = index + 1;
	until false
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
		
		sum_num = 0;
		num1 = startToPingjia_iphone6(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(320,560,-508)
			mSleep(2000)
			num1 = startToPingjia_iphone6(4);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack_iphone6();
		
		logout_iphone6();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage_iphone6(position)

	sucess = false;
	repeat
		mSleep(500);
		repeat
			--old 80,190
			tap(80,190+123*(position-1));	--点击第一个关注的头像
			mSleep(2000)
			nLog("正在加载私教小屋")
		until isColor(566,1287,0x5cd390,90)
	
		mSleep(2000)
		pull_the_screen(320,560,-80)
		mSleep(500)
		step = 0;
		repeat
			-- body
			tap(685,600+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(100)
			step = step + 1;
		until getColor(566, 1287) ~= 0x5cd390
	
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(500);
		until (isColor(544,203, 0xffffff,85) and isColor(555,347,0xffffff,85)) or (isColor( 371,  626, 0xffffff, 85) and isColor(499, 625,0xffffff, 85))
		
		mSleep(500);
		if isColor(544,203, 0xffffff,85) and isColor(555,347,0xffffff,85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack_iphone6();
			goBack_iphone6();
		end
		mSleep(500);
	until sucess == true
	nLog("成功进入课程详情页");
	return 0; 
end

function doTheWork_fukuan_iphone6(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6(userName,passWord);
			
		mSleep(1000);
			
		tap(375,591);
		repeat
			-- body
			mSleep(500);
		until  getColor(583, 1281) == 0xcecece or getColor(583, 1281) == 0xf2f2f2
		
		tap(46,1285);
		mSleep(1000);
		
		toast("付款之后，请进入设置界面",2)
		
		repeat
			mSleep(1000);
			nLog("waiting for fukuan...")
		until isColor( 643,317, 0x4cd964, 85) and isColor( 200,  890, 0xfc8080, 85) and isColor( 340, 800, 0xf2f2f2, 85)
		
		nLog("进入设置界面");
		
		choice = dialogRet("是否继续付款下一个？", "继续付款", "结束付款", "", 0);
		if choice == 0 then
			nLog("继续付款下一个");
			
			mSleep(1000);
			repeat
				mSleep(200);
				tap(279, 891);	--点击退出登录
				mSleep(1000);
			until isColor( 597,718,0x65d095,90)
	
			mSleep(500);
			tap(469, 714);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			
		else
			nLog("结束付款");
			mSleep(1000);
			repeat
				mSleep(200);
				tap(279, 891);	--点击退出登录
				mSleep(1000);
			until isColor( 597,718,0x65d095,90)
	
			mSleep(500);
			tap(469, 714);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			return lua_exit();
		end
	end
end

function startToXiadan_new_iphone6(begin)
	for index = begin,7 do	
		nLog("index = "..index.."   y  = "..tostring(208+161*(index-1)));
		y = 208+161*(index-1);
		
		mSleep(500)
		if y > 1332 then
			--没有下一节课程
			mSleep(500)
			nLog("没有下一节课程")
		else
			--该节课程可以点击
			nLog("该节课程可以点击")
			repeat
				mSleep(500)
				tap(475,y)
				mSleep(500)
			until isColor(371,616,0xffffff,95) and (isColor(580, 1285,0xaaaaaa,80) or isColor(580, 1285,0x5cd390,80))  --加载完毕
			
			mSleep(500);
			--课程详情加载完毕
			nLog("课程详情加载完毕")
			if getColor(580, 1285) == 0xaaaaaa then   --灰色按钮
				--如果已经报名，直接返回
				mSleep(500);
				goBack_iphone6(500);
			else
				--可以报名
				repeat
					if isColor(580,1285,0x5cd390,95) then
						tap(625,1285); --点击报名
					end
					mSleep(500)
					nLog("loading..2")
				until isColor(580,1285,0x33744f,95) or isColor(651,1289,0x33c774,95) --加载完毕
				
				mSleep(500)
				
				if isColor(580,1285,0x33744f,95) or isColor(710,643,0x8c8c8c,95) then
					nLog("已经选过课了，返回进行下一个")
					tap(380,820);
					mSleep(500);
					goBack_iphone6(500);
				elseif getColor(608,  588) == 0x999999 then
					--iphone6 课程撤销  待处理****************************************
					nLog("课程已撤销，返回点击好的")
					tap(317, 626);
					mSleep(1000);
					goBack_iphone6(500);
				elseif isColor(651,1289,0x33c774,85) then
					nLog("可以选课")
					mSleep(500)
					repeat
						if isColor( 449,517, 0xffffff, 95) or isColor(449,577,0xffffff,95) then 
							tap(586,1284);  --点击稍后支付
						end
						mSleep(1000)
					until isColor(460,1280,0x1f7746,95) or isColor(710,624,0x999999,95)
					
					mSleep(500);
					repeat
						tap(372,771);   --选课成功，点击我知道了
						mSleep(500)
					until isColor(580,1285,0x5cd390,95) or isColor(580,1285,0xaaaaaa,95)
					
					mSleep(500);
					goBack_iphone6(500);
				else
					--进入空白页面
					nLog("进入空白页面")
					mSleep(1000);
					goBack_iphone6(500);
					goBack_iphone6(500);
				end
			end
		end
	end
end

function doTheWork_xiadan_new_iphone6(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_iphone6(userName,passWord);
		mSleep(500);
		
		tap(658,1282);	 --点击我的tab
		mSleep(200);
	
		repeat
			tap(351,332);	--点击关注
			mSleep(1000)
			nLog("正在加载关注列表")
		until isColor(384,182,0xffffff,90) and isColor(375,600,0xffffff, 90) and isColor(624,190,0xc4c4c4, 90)
		
		--进入关注列表页
		if yueke_mode == nil then
			nLog("需要约多个号")
			
			mSleep(500)
			position = 1;
			repeat
				nLog("开始约第"..position.."个号")
				
				geToAllCourcesPage_iphone6(position);
				
				mSleep(500)
				
				startToXiadan_new_iphone6(1)
				if pull_count == nil then
					pull_count = 1;
				end
				
				for k = 1,pull_count do
					mSleep(500)
					pull_the_screen_new(320,560,-630)
					mSleep(1000)
					startToXiadan_new_iphone6(4);
				end
				
				mSleep(1000);
				goBack_iphone6(500);
				goBack_iphone6(500);
				position = position + 1;
				mSleep(500)
			until isColor(623,189+123*(position-1),0xc4c4c4,90) == false
			
			nLog("没有更多关注的私教了。。end")
		else
			nLog("不需要约多个号，只约第一个关注的号即可")
			
			geToAllCourcesPage_iphone6(1);
			
			mSleep(500);
		
			startToXiadan_new_iphone6(1)
			if pull_count == nil then
				pull_count = 1;
			end
			
			for k = 1,pull_count do
				mSleep(500)
				pull_the_screen_new(320,560,-630)
				mSleep(1000)
				startToXiadan_new_iphone6(4);
			end
			
			mSleep(1000);
			goBack_iphone6(500);
			goBack_iphone6(500);
			mSleep(500)
		end
		
		goBack_iphone6(1000);
		logout_iphone6(1000);
		mSleep(1000)
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
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,管理评价语,添加帐号"})
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
			
			doTheWork_xiadan_new_iphone6();
		end
	elseif mode == "登录付款" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			index = tonumber(strSplit(name)[1]);
			
			doTheWork_fukuan_iphone6();
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
