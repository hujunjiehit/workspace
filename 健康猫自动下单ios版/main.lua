require "TSLib"

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
		
		--todo:  如果已经报名，直接返回
		
		tap(483,1085); --点击报名
		repeat
			mSleep(500)
			nLog("loading..2")
		until getColor(580,1084) == 0x459e6c or getColor(580,1084) == 0x33c774 --加载完毕
		--0x459e6c	 已经报过名了
		--0x33c774   可以报名
		if getColor(580,1084) == 0x459e6c then
			nLog("已经选过课了，返回进行下一个")
			tap(400,724);
			mSleep(500);
			goBack();
		else
			nLog("可以选课")
			repeat
				-- body
				tap(486,1086);  --点击稍后支付
				mSleep(1000)
			until getColor(580,1084) == 0x1f7746   --选课成功的颜色
			mSleep(500);
			
			tap(323,674);   --选课成功，点击我知道了
			mSleep(1000);
			goBack();
		end
	end
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


function doTheWork(...)
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


function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本评价记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("脚本评价记录","\n\n\n\n脚本开始时间:"..os.date("%c")); 
	
	showFloatButton(false);
	
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
	
	UINew({titles="我的脚本",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("请选择需要登录的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	
	if name == nil then
		nLog("user choose nothing,so exit the lua!");
		mSleep(1000)
		lua_exit();
	else
		nLog("name = "..name);
		
		index = tonumber(strSplit(name)[1]);
		nLog("index = "..index);

		setScreenScale(true, 640, 1136) 
		
		doTheWork();
		
		setScreenScale(false)
	end
	
	width,height = getScreenSize();
	nLog("[DATE]"..width.."---"..height);
	closeLog("脚本评价记录");  --关闭日志
end 
 
main()