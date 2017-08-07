require "TSLib"

function goBack_ipadair(...)
	-- body
	tap(180,232);
	mSleep(1000);
end

function login_ipadair(userName,passWord)
	
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	mSleep(1500)
	tap(1248,1876);	 --点击我的tab，拉起登陆界面 
	mSleep(1500)
	
	tap(1300,438) --收起输入法键盘
	mSleep(500)
	
	tap(768,884);	 --点击帐号输入框
	mSleep(500)
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	inputText(userName);
	mSleep(500);
	
	tap(1300,438) --收起输入法键盘
	mSleep(500)
	
	tap(768,1050);   --点击密码输入框
	mSleep(500);
	inputText(passWord);
	mSleep(500);

	tap(1300,438) --收起输入法键盘
	mSleep(500)
	
	tap(1044,1264); --点击登陆按钮
	repeat
		mSleep(2000);
    until getColor(838, 454) ~= 0x3aab47
	
	mSleep(1000);
	nLog(userName.."登录成功");
	
	tap(1248,1876);  --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(1000)
end

function logout_ipadair()
	tap(1248,1876);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	toast(sysint,1);
	if sysint >= 700 and sysint <= 710  then
		pull_the_screen(640,1120,-1500)	--滑动，露出设置按钮
		mSleep(2000)
		tap(734,1628);	--进入设置
		mSleep(1000)
	else
		pull_the_screen(640,1120,-1500)	--滑动，露出设置按钮
		mSleep(2000)
		tap(734,1628);	--进入设置
		mSleep(1000)
	end


	repeat
		mSleep(200);
		tap(776,1834);	--点击退出登录
		mSleep(1000);
	until isColor(1152,1120,0x65d195,70)
	mSleep(1000)
	tap(1152,1120);	--点击确定按钮
	mSleep(2000)
	nLog(userName.."退出登录");
end

function gotoPingjiaPage_ipadair()
	
	tap(1248,1876); --点击我的tab
	mSleep(500)
	
	pull_the_screen(320,560,1000)	--滑动到顶，方便定坐标
	mSleep(1000)
	
	tap(780,1000); --点击我的订单
	repeat
		mSleep(1000)
	until isColor(768,988,0xffffff,85)	or isColor( 768,988,0xf2f2f2, 85)	--加载进度判断
	
	tap(776,234); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	tap(760,564); 	 --选择私教团购订单

	repeat
		mSleep(1000);
	until isColor( 694,  1080, 0xffffff, 85) or isColor( 938,  1002, 0xffffff, 85) or isColor(906,  756, 0xffffff, 85)
	
	mSleep(1000);
	pull_the_screen(320,560,800);	--滑动到顶,避免漏掉第一个
	mSleep(1000);
	nLog("成功进入评价详情页");
end


function startToPingjia_ipadair(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,1082,330,1386,1942);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	mSleep(1500);
	
	--开始评价
	index = 1;
	repeat
		x = m + 112;
		y = n + 50 + 308*(index-1);
		
		nLog(" index = "..index);
		
		if y >= 1980 then
			return flag_count;
		end
		
		mSleep(1000);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(546, 1884,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(1000); --加载数据
			until isColor(466,500,0x7ce5aa,85) or getColor(314,468) ~= 0xffffff
		
			tap(664,1244);	--点击输入框，获取焦点
			mSleep(1500);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(1000);
			tap(1300,414);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(764,1890);	--点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(764,1890);	--点击提交评价
					times = 0;
				end
			until isColor(546, 1884,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			--repeat
				mSleep(1000);
			--until isColor(916,994,0xffffff,95) or isColor(918,780,0xffffff,95)
		end
		index = index + 1;
	until false
	
end



function doTheWork_pingjia_ipadair(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_ipadair(userName,passWord);
		mSleep(1500)
		
		gotoPingjiaPage_ipadair();
		
		sum_num = 0;
		num1 = startToPingjia_ipadair(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(640,1800,-1600)
			mSleep(1500)
			num1 = startToPingjia_ipadair(1);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack_ipadair();
		
		logout_ipadair();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage_ipadair()
	tap(1248,1876); --点击我的tab 
	mSleep(200)
	pull_the_screen(320,560,1000)	

	mSleep(1000)
	
	tap(766,724);	--点击关注

	repeat
		mSleep(500)
	until getColor(700,1064) == 0xffffff
	
	sucess = false;
	repeat
		mSleep(500);
		tap(300,456);	--点击第一个关注的头像
		repeat
			mSleep(500)
		until isColor( 1080,  1886, 0x5cd390, 85)
		
		mSleep(1000)
		pull_the_screen(640,1120,-800)
		mSleep(1500)
		step = 0;
		repeat
			-- body
			tap(1270,1000+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(100)
			step = step + 1;
		until getColor(1080,1886) ~= 0x5cd390
		
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(1000)
			nLog("waiting...")
		until isColor(952,460,0xffffff,85) or isColor( 558,  946, 0xffffff, 85)
		
		mSleep(500);
		if isColor(952,460, 0xffffff, 85) and isColor( 1106,  508, 0xffffff, 85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack_ipadair();
			goBack_ipadair();
		end
		mSleep(1000);
	until sucess == true
	
	mSleep(1000);
	nLog("成功进入课程详情页");
	return 0; 
end

function startToXiadan_ipadair(begin)
	mSleep(1000);
	for index = begin,5 do	
		nLog("index = "..index.."   y  = "..tostring(234+160*(index-1)));
		y = 468+320*(index-1);
		
		tap(858,468+320*(index-1));
		repeat
			mSleep(1000)
			nLog("loading..1")
		until isColor(742,1010,0xffffff,80)  --加载完毕
		
		mSleep(500);
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if getColor(1096, 1860) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack_ipadair();
		elseif getColor(1096, 1860) == 0xffffff then
			--还在当前页面，什么都不做
		else
			mSleep(500);
			tap(1096, 1860); --点击报名
			repeat
				mSleep(1000)
				nLog("loading..2")
			until isColor(1096, 1860,0x5cd390,95) == false  --加载完毕
			
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if isColor(1096, 1860,0x459e6c,95) or isColor(1356,978,0xbfbfbf,95) or isColor(1096, 1860,0x33744f,95) or isColor(1356,978,0x8c8c8c,95)  then
				nLog("已经选过课了，返回进行下一个")
				tap(766,1350);
				mSleep(500);
				goBack_ipadair();
			elseif getColor(1216,  1176) == 0x999999 then
				nLog("课程已撤销，返回点击好的------待定")
				tap(634, 1256);
				mSleep(1000);
				goBack_ipadair();
			elseif getColor(926,1880) == 0x33c774 then
				nLog("可以选课")
				repeat
					-- body
					tap(1072,1880);  --点击稍后支付
					mSleep(1000)
					m,n = findColorInRegionFuzzy(0x007aff, 90, 332,1148, 992,1288); 
					nLog("m = "..m.."   n = "..n);
					mSleep(1000);
				until m ~= -1 and n ~= -1

				mSleep(500);
				tap(776,1224);   --选课成功，点击我知道了
				mSleep(1000);
				goBack_ipadair();

			else
				--进入空白页面
				mSleep(1000);
				goBack_ipadair();
				goBack_ipadair();
			end
		end
	end
end

function doTheWork_xiadan_ipadair(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login_ipadair(userName,passWord);
		mSleep(500)
		
		geToAllCourcesPage_ipadair();
		
		mSleep(1500);
		
		startToXiadan_ipadair(1)
		if pull_count == nil then
			pull_count = 1;
		end
		
		for k = 1,pull_count do
			pull_the_screen(640,1800,-1600)
			mSleep(2000)
			startToXiadan_ipadair(1);
		end
		mSleep(1000);
		
		
		if yueke_mode == nil then
			--需要约两个号的课程
			nLog("开始约第二个号的课程")
			mSleep(1000);
			goBack_ipadair();
			goBack_ipadair();
			
			--回到关注列表页
			mSleep(1000);
			if (isColor(1160,688,0xc4c4c4, 85)) then
				--有第二个关注的人
				--toast("有第二个关注的人",1);
				sucess = false;
				repeat
					mSleep(500);
					tap(300,700);	--点击第2个关注的头像
					repeat
						mSleep(500)
					until isColor( 1080,  1886, 0x5cd390, 85)
					
					mSleep(1000)
					pull_the_screen(640,1120,-800)
					mSleep(1500)
					step = 0;
					repeat
						-- body
						tap(1270,1000+step*20); --每次下滑20px，尝试点击改点坐标
						mSleep(100)
						step = step + 1;
					until getColor(1080,1886) ~= 0x5cd390
					
					--可能进入动力秀 或者 团课界面
					repeat
						mSleep(1000)
						nLog("waiting...")
					until isColor(952,460,0xffffff,85) or isColor( 558,  946, 0xffffff, 85)
					
					mSleep(500);
					if isColor(952,460, 0xffffff, 85) and isColor( 1106,  508, 0xffffff, 85) then
						--进入团课界面
						sucess = true;
					else
						--进入动力秀界面
						sucess = false;
						goBack_ipadair();
						goBack_ipadair();
					end
					mSleep(1000);
				until sucess == true
				
				mSleep(1000);
				nLog("成功进入第二个私教课程详情页");
				
				startToXiadan_ipadair(1)
				if pull_count == nil then
					pull_count = 1;
				end
				
				for k = 1,pull_count do
					pull_the_screen(640,1800,-1600)
					mSleep(2000)
					startToXiadan_ipadair(1);
				end
				mSleep(1000);
				
				goBack_ipadair();
				goBack_ipadair();
				goBack_ipadair();
				logout_ipadair();
				mSleep(1000);
			else
				--没有第二个关注的人
				nLog("没有第二个关注的人")
				--toast("没有第二个关注的人",1);
				goBack_ipadair();
				logout_ipadair();
				mSleep(1000);
			end
		else
			--不需要约两个号的课程
			goBack_ipadair();
			goBack_ipadair();
			goBack_ipadair();
			
			logout_ipadair();
			mSleep(1000);
		end
		
		--goBack_ipadair();
		--goBack_ipadair();
		--goBack_ipadair();
		
		--logout_ipadair();
		--mSleep(1000);
	end
end


function main_ipadair_real(...)
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
	
	UINew({titles="脚本配置ipad9.7",okname="开始",cancelname="取消",config="UIconfig.dat"})
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
			
			doTheWork_pingjia_ipadair();
			
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
			
			doTheWork_xiadan_ipadair();
	
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
			
			login_ipadair(userName,passWord);
			
			tap(1248,1876);	 --点击我的tab，拉起登陆界面 
			mSleep(500)
			
			pull_the_screen(320,560,1000)	--滑动
			mSleep(1000)
	
			tap(776,1250);
			repeat
				-- body
				mSleep(1000);
			until isColor( 900, 422,0xf2f2f2 , 85) or isColor( 900,  422, 0xffffff, 85)
			mSleep(500);
			tap(218,1882);
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

function main_ipadair(...)
	-- body
	--setScreenScale(true, 768, 1024)  --以768,1024分辨率为基准坐标进行缩放
	
	main_ipadair_real();

	--setScreenScale(false)  --关闭缩放
end