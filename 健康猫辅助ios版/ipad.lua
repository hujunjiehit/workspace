require "TSLib"

function goBack_ipad(...)
	-- body
	tap(90,116);
	mSleep(1000);
end

function login_ipad(userName,passWord)
	
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(625,935);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	tap(597,267) --收起输入法键盘
	mSleep(500)
	
	tap(388,440);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(500);
	
	tap(597,267) --收起输入法键盘
	mSleep(500)
	
	tap(388,520);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	tap(597,267) --收起输入法键盘
	mSleep(500)
	
	repeat
		tap(523,628); --点击登陆按钮
		mSleep(2000);
    until getColor(415, 229) ~= 0x3aab47
	
	mSleep(1000);
	nLog(userName.."登录成功");
	
	tap(625,935);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(1000)
end

function logout_ipad()
	tap(625,935);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	toast(sysint,1);
	if sysint >= 700 and sysint <= 710  then
		pull_the_screen(320,560,-500)	--滑动，露出设置按钮
		mSleep(2000)
		tap(367,814);	--进入设置
		mSleep(1000)
	else
		pull_the_screen(320,560,-500)	--滑动，露出设置按钮
		mSleep(2000)
		tap(367,814);	--进入设置
		mSleep(1000)
	end


	repeat
		mSleep(200);
		tap(388,917);	--点击退出登录
		mSleep(1000);
	until isColor(576,560,0x65d096,90)
	mSleep(1000)
	tap(576,560);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end

function gotoPingjiaPage_ipad()
	
	tap(625,935); --点击我的tab
	mSleep(500)
	
	pull_the_screen(320,560,100)	--滑动到顶，方便定坐标
	mSleep(1000)
	
	tap(390,495); --点击我的订单
	repeat
		mSleep(1000)
	until isColor(384,494,0xffffff,85)	or isColor( 384,494,0xf2f2f2, 85)	--加载进度判断
	
	tap(388,117); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	tap(380,282); 	 --选择私教团购订单

	repeat
		mSleep(1000);
	until isColor( 347,  540, 0xffffff, 85) or isColor( 469,  501, 0xffffff, 85) or isColor(453,  378, 0xffffff, 85)
	
	mSleep(1000);
	pull_the_screen(320,560,400);	--滑动到顶,避免漏掉第一个
	mSleep(1000);
	nLog("成功进入评价详情页");
end


function startToPingjia_ipad(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,523,177,688,980);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	mSleep(1500);
	
	--开始评价
	index = 1;
	repeat
		x = m + 60;
		y = n + 20 + 154*(index-1);
		
		nLog(" index = "..index);
		
		if y >= 980 then
			return flag_count;
		end
		
		mSleep(1000);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(273, 942,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(1000); --加载数据
			until isColor(233,250,0x7ce5aa,85) or getColor(157,234) ~= 0xffffff
		
			tap(332,622);	--点击输入框，获取焦点
			mSleep(1500);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(1000);
			tap(650,207);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(382,945);	--点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(320,1080);	--点击提交评价
					times = 0;
				end
			until isColor(273, 942,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			repeat
				mSleep(1000);
			until isColor(458,497,0xffffff,95) or isColor(459,390,0xffffff,95)
		end
		index = index + 1;
	until false
	
end



function doTheWork_pingjia_ipad(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_ipad(userName,passWord);
		mSleep(1500)
		
		gotoPingjiaPage_ipad();
		
		sum_num = 0;
		num1 = startToPingjia_ipad(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(320,560,-408)
			mSleep(1500)
			num1 = startToPingjia_ipad(2);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack_ipad();
		
		logout_ipad();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage_ipad()
	tap(625,935); --点击我的tab 
	mSleep(200)
	pull_the_screen(320,560,100)	--滑动，露出设置按钮

	mSleep(1000)
	
	tap(383,362);	--点击关注

	repeat
		mSleep(500)
	until getColor(350,532) == 0xffffff
	
	sucess = false;
	repeat
		mSleep(500);
		tap(150,228);	--点击第一个关注的头像
		repeat
			mSleep(500)
		until isColor( 540,  943, 0x5cd390, 85)
		
		mSleep(1000)
		pull_the_screen(320,560,-50)
		mSleep(1500)
		step = 0;
		repeat
			-- body
			tap(635,500+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(100)
			step = step + 1;
		until getColor(540,943) ~= 0x5cd390
		
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(1000)
			nLog("waiting...")
		until isColor(476,230,0xffffff,85) or isColor( 279,  473, 0xffffff, 85)
		
		mSleep(500);
		if isColor(476,230, 0xffffff, 85) and isColor( 553,  254, 0xffffff, 85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack_ipad();
			goBack_ipad();
		end
		mSleep(1000);
	until sucess == true
	
	mSleep(1000);
	nLog("成功进入课程详情页");
	return 0; 
end

function startToXiadan_ipad(begin)
	mSleep(1000);
	for index = begin,5 do	
		nLog("index = "..index.."   y  = "..tostring(234+160*(index-1)));
		y = 234+160*(index-1);
		
		tap(429,234+160*(index-1));
		repeat
			mSleep(1000)
			nLog("loading..1")
		until isColor(371,505,0xffffff,80)  --加载完毕
		
		mSleep(500);
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if getColor(548, 930) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack_ipad();
		elseif getColor(548, 930) == 0xffffff then
			--还在当前页面，什么都不做
		else
			mSleep(500);
			tap(548, 930); --点击报名
			repeat
				mSleep(1000)
				nLog("loading..2")
			until getColor(548, 930) ~= 0x5cd390  --加载完毕
			
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if getColor(548, 930) == 0x459e6c or getColor(678,  489) == 0xbfbfbf then
				nLog("已经选过课了，返回进行下一个")
				tap(383,675);
				mSleep(500);
				goBack_ipad();
			elseif getColor(608,  588) == 0x999999 then
				nLog("课程已撤销，返回点击好的------待定")
				tap(317, 626);
				mSleep(1000);
				goBack_ipad();
			elseif getColor(463,940) == 0x33c774 then
				nLog("可以选课")
				repeat
					-- body
					tap(536,940);  --点击稍后支付
					mSleep(1000)
					m,n = findColorInRegionFuzzy(0x007aff, 90, 166,574, 496,644); 
					nLog("m = "..m.."   n = "..n);
					
					--[[
					if isColor(481, 1084,0xefeff4,95) and isColor(461,978,0xefeff4,95) then
						m = 0;
						n = 0;
					end
					]]
					mSleep(1000);
				until m ~= -1 and n ~= -1

				mSleep(500);
				tap(388,612);   --选课成功，点击我知道了
				mSleep(1000);
				goBack_ipad();

			else
				--进入空白页面
				mSleep(1000);
				goBack_ipad();
				goBack_ipad();
			end
		end
	end
end

function doTheWork_xiadan_ipad(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_ipad(userName,passWord);
		mSleep(500)
		
		geToAllCourcesPage_ipad();
		
		mSleep(1500);
		
		startToXiadan_ipad(1)
		if pull_count == nil then
			pull_count = 1;
		end
		
		for k = 1,pull_count do
			pull_the_screen(320,560,-408)
			mSleep(2000)
			startToXiadan_ipad(1);
		end
		mSleep(1000);
		
		
		if yueke_mode == nil then
			--需要约两个号的课程
			nLog("开始约第二个号的课程")
			mSleep(1000);
			goBack_ipad();
			goBack_ipad();
			
			--回到关注列表页
			mSleep(500);
			if (isColor(580,344, 0xc4c4c4, 85)) then
				--有第二个关注的人
				sucess = false;
				repeat
					mSleep(500);
					tap(150,350);	--点击第2个关注的头像
					repeat
						mSleep(500)
					until isColor( 540,  943, 0x5cd390, 85)
					
					mSleep(1000)
					pull_the_screen(320,560,-50)
					mSleep(1500)
					step = 0;
					repeat
						-- body
						tap(635,500+step*20); --每次下滑20px，尝试点击改点坐标
						mSleep(100)
						step = step + 1;
					until getColor(540,943) ~= 0x5cd390
					
					--可能进入动力秀 或者 团课界面
					repeat
						mSleep(1000)
						nLog("waiting...")
					until isColor(476,230,0xffffff,85) or isColor( 279,  473, 0xffffff, 85)
					
					mSleep(500);
					if isColor(476,230, 0xffffff, 85) and isColor( 553,  254, 0xffffff, 85) then
						--进入团课界面
						sucess = true;
					else
						--进入动力秀界面
						sucess = false;
						goBack_ipad();
						goBack_ipad();
					end
					mSleep(1000);
				until sucess == true
				
				mSleep(1000);
				nLog("成功进入第二个私教课程详情页");
				
				startToXiadan_ipad(1)
				if pull_count == nil then
					pull_count = 1;
				end
				
				for k = 1,pull_count do
					pull_the_screen(320,560,-408)
					mSleep(2000)
					startToXiadan_ipad(1);
				end
				mSleep(1000);
				
				goBack_ipad();
				goBack_ipad();
				goBack_ipad();
				logout_ipad();
				mSleep(1000);
			else
				--没有第二个关注的人
				nLog("没有第二个关注的人")
				goBack_ipad();
				logout_ipad();
				mSleep(1000);
			end
		else
			--不需要约两个号的课程
			goBack_ipad();
			goBack_ipad();
			goBack_ipad();
			
			logout_ipad();
			mSleep(1000);
		end
		
		--goBack_ipad();
		--goBack_ipad();
		--goBack_ipad();
		
		--logout_ipad();
		--mSleep(1000);
	end
end


function main_ipad_real(...)
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
	
	sysver = getOSVer();    --获取系统版本
	sysint = tonumber(string.sub(sysver, 1, 1)..string.sub(sysver, 3,3)..string.sub(sysver, 5, 5));
	--nLog("str = "..str);
	
	UINew({titles="脚本配置ipad7.9",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",30,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,管理评价语,添加帐号"})
	UILabel("评价或者约课时下滑次数：",30,"left","255,0,0") --宽度写-1为一行，自定义宽度可写其他数值
	UIEdit("pull_count","输入下滑次数","1",30,"center","0,0,255")
	UICheck("yueke_mode","只约一个私教号的课","0");
	UILabel("请选择需要登录的帐号：",30,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
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
			
			doTheWork_pingjia_ipad();
			
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
			
			doTheWork_xiadan_ipad();
	
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
			
			login_ipad(userName,passWord);
			
			tap(625,935);	 --点击我的tab，拉起登陆界面 
			mSleep(500)
			
			pull_the_screen(320,560,500)	--滑动
			mSleep(1000)
	
			tap(402,625);
			repeat
				-- body
				mSleep(1000);
			until isColor( 468, 201,0xf2f2f2 , 85) or isColor( 468,  201, 0xffffff, 85)
			mSleep(500);
			tap(109,940);
			mSleep(1000);
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

function main_ipad(...)
	-- body
	--setScreenScale(true, 768, 1024)  --以768,1024分辨率为基准坐标进行缩放
	
	main_ipad_real();

	--setScreenScale(false)  --关闭缩放
end