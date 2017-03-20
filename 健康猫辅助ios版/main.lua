require "TSLib"
require "iphone6"
require "iphone6p"
require "ipad"
require "iphone4"
require "ipadair"

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy);
	mSleep(1000);
end

function goBack(delaytime)
	-- body
	delaytime = delaytime or 1000
	tap(23,84);
	mSleep(delaytime);
end

function login(userName,passWord)
	
	--r = runApp("com.AHdzrjk.healthmall");    --启动健康猫应用
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	repeat
		mSleep(500)
	until isColor(322,570,0xf2f2f2,95)
	
	tap(524,206) --收起输入法键盘
	mSleep(500)
	
	tap(295,404);	 --点击帐号输入框
	mSleep(500)
	
	inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
	mSleep(500)
	
	inputText(userName);
	mSleep(1000);
		
	tap(400,484);   --点击密码输入框
	mSleep(1000);
	
	inputText(passWord);
	mSleep(1000);
	
	tap(458,598); --点击登陆按钮
	repeat
		mSleep(2000);
    until isColor(355,200,0x3aab47,95) == false
	
	mSleep(1000);
	
	nLog(userName.."登录成功");

	tap(560,1083);	 --点击我的tab，去掉帐号第一次登录时出现的引导蒙板
	mSleep(500)
end

function logout()
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	toast(sysint,1);
	if sysint >= 700 and sysint <= 710  then
		pull_the_screen(320,560,-100)	--滑动，露出设置按钮
		mSleep(2000)

		tap(341,855);	--进入设置
		mSleep(1000)
	else
		pull_the_screen(320,560,-100)	--滑动，露出设置按钮
		mSleep(2000)

		tap(300,956);	--进入设置
		mSleep(1000)
	end


	repeat
		mSleep(200);
		tap(300,892);	--点击退出登录
		mSleep(1000);
	until isColor(392,612,0x65d096,85) or isColor(392,612,0x62cd93,85)
	
	mSleep(1000)
	tap(450,617);	--点击确定按钮
	
	mSleep(2000)
	nLog(userName.."退出登录");
end

function gotoPingjiaPage()
	
	tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(500)
	
	pull_the_screen(320,560,100)	--滑动到顶，方便定坐标
	mSleep(1000)
	
	tap(327,461); --点击我的订单
	repeat
		mSleep(1000)
	until getColor(264,582) ~= 0x333333	and getColor(264,582) ~= 0x3a3a3a		--加载进度判断
	
	tap(323,82); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	tap(322,249); 	 --选择私教团购订单

	repeat
		mSleep(1000);
	until isColor( 316,511,0xffffff,95) or isColor( 374,437,0xffffff, 85) or isColor(390,582,0xffffff, 95)
	mSleep(1000);
	pull_the_screen(320,560,400);	--滑动到顶,避免漏掉第一个
	mSleep(1000);
	nLog("成功进入评价详情页");
end


function startToPingjia(begin)
	
	flag_count = 0;  --计数器，记录当前成功评价的个数 
	
	--先判断需不需要评价，通过找颜色，如果不需要直接返回
	m,n = findColorInRegionFuzzy(0x33c774,80,448,133,625,1022);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	mSleep(1500);
	
	--开始评价
	index = 1;
	repeat
		x = m + 50;
		y = n + 20 + 154*(index-1);
		
		nLog(" index = "..index);
		
		if y >= 1130 then
			return flag_count;
		end
		
		mSleep(1000);
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(232, 1080,0x5cd390,85) then  --可以评价
			
			repeat
				mSleep(1000); --加载数据
			until isColor(194,218,0x7ce5aa,85) or getColor(97,201) ~= 0xffffff
		
			tap(280,600);	--点击输入框，获取焦点
			mSleep(1000);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(500);
			tap(525,190);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(320,1080);	--点击提交评价
			times = 0;
			repeat
				mSleep(1000);
				times = times + 1;
				if times == 20 then
					tap(320,1080);	--点击提交评价
					times = 0;
				end
			until isColor(232, 1080,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			--repeat
			mSleep(1000);
			--until isColor(396,455,0xffffff,95) or isColor(391,517,0xffffff,95)
		end
		index = index + 1;
	until false
	
end



function doTheWork_pingjia(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		mSleep(1000)
		
		gotoPingjiaPage();
		
		sum_num = 0;
		num1 = startToPingjia(1);
		sum_num = sum_num + num1;
		if pull_count == nil then
			pull_count = 1;
		end
		for k = 1,pull_count do
			pull_the_screen(320,560,-408)
			mSleep(1500)
			num1 = startToPingjia(2);
			sum_num = sum_num + num1;
		end
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..sum_num.."条评价");
		
		goBack();
		
		logout();
		mSleep(1000);
	end
end

--跳转到所有团课界面
function geToAllCourcesPage(position)
	--[[tap(560,1083);	 --点击我的tab，拉起登陆界面 
	mSleep(200)

	pull_the_screen(320,560,100)	--滑动，方便定坐标
	mSleep(1000)

	repeat
		tap(336,330);	--点击关注
		mSleep(1000)
	until isColor(512,189, 0xc4c4c4,90) and isColor(321, 190,0xffffff, 90) and isColor( 320,512,0xffffff,95)
	]]
	
	sucess = false;
	repeat
		mSleep(500);
		repeat
			tap(80,311 + 123*(position-1));	--点击第一个关注的头像
			mSleep(1000)
		until isColor(478, 1085,0x5cd390,90)
		
		mSleep(2000)
		pull_the_screen(320,560,-80)
		mSleep(1000)
		step = 0;
		repeat
			-- body
			tap(575,550+step*20); --每次下滑20px，尝试点击改点坐标
			mSleep(200)
			step = step + 1;
		until isColor(478, 1085,0x5cd390,85) == false
		
		--可能进入动力秀 或者 团课界面
		repeat
			mSleep(1000)
			nLog("waiting...")
		until isColor(447,192,0xffffff,85) or (isColor( 319,  550, 0xffffff, 85) and isColor( 425,  549, 0xffffff, 85))
		
		mSleep(500);
		if isColor( 464,  210, 0xffffff, 85) and isColor( 459,356, 0xffffff, 85) then
			--进入团课界面
			sucess = true;
		else
			--进入动力秀界面
			sucess = false;
			goBack();
			goBack();
		end
		mSleep(1000);
	until sucess == true
	
	mSleep(200);
	nLog("成功进入课程详情页");
	return 0; 
end


function doTheWork_fukuan(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		
		tap(560,1083);	 --点击我的tab，拉起登陆界面 
		mSleep(500)
		pull_the_screen(320,560,500)	--滑动，露出设置按钮
		mSleep(1000)
	
		tap(300,600);
		repeat
			-- body
			mSleep(500);
		until  getColor(481, 1090) == 0xcecece or getColor(481, 1090) == 0xf2f2f2
		tap(46,1086);
		mSleep(1000);
		
		toast("付款之后，请进入设置界面",2)
		
		repeat
			mSleep(1000);
			nLog("waiting for fukuan...")
		until isColor( 526,  321, 0x4cd964, 85) and isColor( 201,  888, 0xfc8080, 85) and isColor( 355, 1035, 0xf2f2f2, 85)
		
		nLog("进入设置界面");
		
		choice = dialogRet("是否继续付款下一个？", "继续付款", "结束付款", "", 0);
		if choice == 0 then
			nLog("继续付款下一个");
			mSleep(1000);
			repeat
				mSleep(200);
				tap(300,892);	--点击退出登录
				mSleep(1000);
			until isColor(392,612,0x65d096,90)
			mSleep(1000)
			tap(450,617);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
		else
			nLog("结束付款");
			mSleep(1000);
			repeat
				mSleep(200);
				tap(300,892);	--点击退出登录
				mSleep(1000);
			until isColor(392,612,0x65d096,90)
			mSleep(1000)
			tap(450,617);	--点击确定按钮
			mSleep(2000)
			nLog(userName.."退出登录");
			return lua_exit();
		end
	end
end

function startToXiadan_new(begin)
	mSleep(200);
	for index = begin,6 do	
		nLog("index = "..index.."   y  = "..tostring(208+160*(index-1)));
		y = 208+160*(index-1);
		
		mSleep(500)
		times = 0;
		repeat
			tap(344,208+160*(index-1));
			mSleep(1000)
			times = times + 1;
			nLog("loading..1  times == "..times.."   index = "..index)
			wLog("脚本评价记录","loading..1  times == "..times.."   index = "..index)
		until (isColor(325,510,0xffffff,95) and (isColor(469, 1085,0xaaaaaa,95) or isColor(469,1085,0x5cd390,95))) or times == 10  --加载完毕
		
		if times == 10 then
			--没有更多课程了
			nLog("times is 10,times == "..times.."   index = "..index)
			mSleep(500);
			break;
		end
		--课程详情加载完毕
		nLog("课程详情加载完毕")
		
		
		if getColor(469, 1085) == 0xaaaaaa then   --灰色按钮
			--如果已经报名，直接返回
			mSleep(500);
			goBack();
		elseif getColor(469, 1085) == 0xffffff then
			--还在当前页面，什么都不做
		else
			repeat
				if isColor(469, 1085,0x5cd390,95) then
					tap(483,1085); --点击报名
				end
				mSleep(1000)
				nLog("loading..2")
			until isColor(580,1084,0x33744f,95) or isColor(580,1084,0x33c774,95) --加载完毕
			
			mSleep(1000)
			
			--0x459e6c	 已经报过名了
			--0x33c774   可以报名
			if isColor(580,1084,0x33744f,95) or isColor(608,588,0x8c8c8c,95) then
				nLog("已经选过课了，返回进行下一个")
				mSleep(1000)
				tap(400,724);
				mSleep(500);
				goBack(500);
			elseif getColor(608,  588) == 0x999999 then
				nLog("课程已撤销，返回点击好的")
				tap(317, 626);
				mSleep(500);
				goBack(500);
			elseif isColor(580,1084,0x33c774,95) then
				nLog("可以选课")
				mSleep(500)
				repeat
					-- body
					tap(486,1086);  --点击稍后支付
					mSleep(2000)
				until isColor(580,1084,0x33c774,95) == false or isColor(621,451,0x999999,95)
				
				mSleep(2000);
				repeat
					tap(312,671);   --选课成功，点击我知道了
					mSleep(1000)
				until isColor(580,1084,0x5cd390,95) or isColor(469,1085,0xaaaaaa,95)
				
				mSleep(2000);
				
				goBack(1000);
			else
				--进入空白页面
				nLog("进入空白页面")
				mSleep(1000);
				goBack(1000);
				goBack(1000);
			end
		end
	end
end

function doTheWork_xiadan_new(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		mSleep(500)
		
		tap(560,1083);	 --点击我的tab，拉起登陆界面 
		mSleep(200)

		pull_the_screen(320,560,100)	--滑动，方便定坐标
		mSleep(500)

		repeat
			tap(336,330);	--点击关注
			mSleep(500)
		until isColor(512,320, 0xc4c4c4,90) and isColor(321, 200,0xffffff, 90) and isColor(320,512,0xffffff,95)
		
		--进入关注列表页
		
		if yueke_mode == nil then
			nLog("需要约多个号")
			
			mSleep(500)
			position = 1;
			repeat
				nLog("开始约第"..position.."个号")
				
				geToAllCourcesPage(position);
				
				mSleep(500)
				
				startToXiadan_new(1)
				if pull_count == nil then
					pull_count = 1;
				end
				
				for k = 1,pull_count do
					mSleep(1000)
					pull_the_screen(320,560,-370)
					mSleep(2000)
					startToXiadan_new(2);
				end
				
				mSleep(1000);
				goBack(1000);
				goBack(1000);
				position = position + 1;
				mSleep(1000)
			until isColor(514,311+123*(position-1),0xc4c4c4,90) == false
			
			nLog("没有更多关注的私教了。。end")
		else
			nLog("不需要约多个号，只约第一个关注的号即可")
			
			geToAllCourcesPage(1);
			
			mSleep(500);
		
			startToXiadan_new(1)
			if pull_count == nil then
				pull_count = 1;
			end
			
			for k = 1,pull_count do
				mSleep(1000)
				pull_the_screen(320,560,-370)
				mSleep(2000)
				startToXiadan_new(2);
			end
			
			mSleep(1000);
			goBack(1000);
			goBack(1000);
			mSleep(1000)
		end
		
		goBack(1000);
		logout();
		mSleep(1000)
	end
end

function write_info(str)
	return writeFile("/var/mobile/Media/TouchSprite/res/info.txt",{str});
end

function write_new_pingjia(new_word)
	return writeFile("/var/mobile/Media/TouchSprite/res/评价语.txt",{new_word});
end

function manage_the_pingjia_words(...)
	-- body
	if isFileExist("/var/mobile/Media/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
		writeFileString("/var/mobile/Media/TouchSprite/res/评价语.txt","很好非常好\n");
	end

	repeat
		words = readFile("/var/mobile/Media/TouchSprite/res/评价语.txt");
		local pingjia_words = "";
		local check_string = "";
		local int counts = #words;
		for i = 1,#words do
			--nLog(i..":"..data[i])
			if words[i] ~= nil and getStrNum(words[i]) >= 5 then
				pingjia_words = pingjia_words..words[i]..",";
				check_string = check_string.."check"..i..",";
			end
		end
		UINew({titles="管理评价语",okname="添加",cancelname="取消"})
		UILabel("管理评价语",22,"center","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UILabel("\n当前评价语如下：",18,"left","0,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UICheck(string.sub(check_string,1,getStrNum(check_string)-1),string.sub(pingjia_words,1,string.len(pingjia_words)-1),"");
		
		UILabel("\n\n输入您要添加的评价语(不少于五个字)：",18,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UIEdit("new_word","此处输入要添加的评价语","",18,"center","0,0,255")
		
		UILabel("\n评价时会从所有的评价语里面随机选择一个",13,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
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
	
	sysver = getOSVer();    --获取系统版本
	sysint = tonumber(string.sub(sysver, 1, 1)..string.sub(sysver, 3,3)..string.sub(sysver, 5, 5));
	--nLog("str = "..str);
	
	UINew({titles="脚本配置iphone5",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio({id="mode",list="自动评价,自动约课,登录付款,管理评价语,添加帐号"})
	UILabel("评价或者约课时下滑次数：",15,"left","255,0,0") --宽度写-1为一行，自定义宽度可写其他数值
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
			
			doTheWork_xiadan_new();
	
		end
	elseif mode == "登录付款" then
		if name == nil then
			nLog("user choose nothing,so exit the lua!");
			mSleep(1000)
			lua_exit();
		else
			index = tonumber(strSplit(name)[1]);
			
			doTheWork_fukuan();
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

function beforeUserExit(...)
	-- body
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	
	if isFileExist("/var/mobile/Media/TouchSprite/res/info.txt") == false then --存在返回true，不存在返回false
		writeFileString("/var/mobile/Media/TouchSprite/res/info.txt","");
	end
			
	width,height = getScreenSize();
	nLog("[DATE]"..width.."---"..height);
	if width == 640 and height == 1136 then
		main_iphone5();
	elseif width == 640 and height == 960 then
		main_iphone4();
	elseif width == 750 and height == 1334 then
		main_iphone6();
	elseif width == 1242 and height == 2208 then
		main_iphone6p();
	elseif (width == 768 and height == 1024) then
		main_ipad();
	elseif (width == 1536 and height == 2048)  then
		main_ipadair();
	else
		dialog("暂不支持的分辨率，请联系脚本作者", 0);
	end
	
	closeLog("脚本评价记录");  --关闭日志
end

main()




