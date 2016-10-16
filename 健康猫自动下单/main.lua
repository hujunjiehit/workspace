 require "TSLib"

function login(userName,passWord)
	tap(626,1227); --点击我的tab，拉起登陆界面 
	switchTSInputMethod(true);
	
	mSleep(1000);
	m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
	nLog(m.."----"..n)
	isFirst = true;
	while m == -1 and n == -1 do
		nLog("flag is false");
		mSleep(500);
		tap(400,429);  --点击帐号输入框
		mSleep(1000);
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");

		mSleep(1000);
		inputText(userName);
	
		mSleep(1000);
		tap(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		end
		
		mSleep(1000);
		inputText(passWord);
	
		mSleep(1000)
		tap(529,629); 
		
		repeat
		mSleep(1000)
		until getColor(408,205) ~= 0x17441c   --健康猫logo color
		mSleep(2000)
		m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
		isFirst = false;
	end
	nLog(m.."----"..n)
	nLog(userName.."登录成功");
	switchTSInputMethod(false);
end

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end

--跳转到所有团课界面
function geToAllCourcesPage()
	tap(626,1131); --点击我的tab
	mSleep(1000);
	tap(362,334);	--点击关注
	mSleep(1000);
	tap(303,203);
	mSleep(2000);
	
	pull_the_screen(320,800,-600)
	mSleep(1000)
	
	deviceBrand = getDeviceBrand();
	deviceModel = getDeviceModel(); 
	nLog("deviceBrand = "..deviceBrand.."   deviceModel = "..deviceModel);
	if deviceModel == "Micromax AO5510" then
		x, y = findImageInRegionFuzzy("more_info_大神f2.png", 90, 471,  149,  717, 1180, 0xffffff);
	else
		x, y = findImageInRegionFuzzy("more_info.png", 90, 471,  149,  717, 1180, 0xffffff);
	end
	
	nLog("x = "..x.." y = "..y)
	if x ~= -1 and y ~= -1 then        --如果在指定区域找到某图片符合条件          
		tap(x+38,y+22);			--那么单击该图片
		return 0;
	else                               --如果找不到符合条件的图片
		os.execute("input keyevent 4");
		mSleep(2000)
		os.execute("input keyevent 4");
		mSleep(2000)
		wLog("test","没找到更多的按钮，返回到我的界面"); 
		return -1;
	end
end

function logout()
	tap(626,1131); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	tap(320,1020);	--进入设置
	mSleep(500)
	tap(350,799);	--点击退出登录
	mSleep(500)
	tap(513,675);	--点击确定
	repeat
		mSleep(1000)
	until getColor(501,798) ~= 0x663434  --健康猫logo color
end

function startToXiadan(begin)
	for index = begin,8 do	
		nLog("index = "..index.."   y  = "..tostring(207+142*(index-1)));
		y = 207+142*(index-1);
		
		color_current = getColor(510,1230)   --点击之前，该点的颜色
		
		tap(363,207+142*(index-1));
		mSleep(1000)
		
		repeat
			nLog("wait for---loading the detail course page");
			mSleep(1000)
			color_next = getColor(510,1230)		--点击之后，该点的颜色
		until color_next == color_current or color_next == 0x33c774 or color_next == 0xd8d8d8
		
		nLog("color_next:"..string.format("%X",color_next));
		
		--根据color_next判断下一步动作
		--1.color_next == color_current 未跳转，还在当前页面，表示没有更多课程
		--2.color_next == 0x33c774 绿色按钮，表示可以报名
		--3.color_next == 0xd8d8d8 灰色按钮，表示已经报名了
	
		if color_next == 0x33c774 then
			--color_next == 0x33c774 绿色按钮，表示可以报名
			tap(510,1230);
			mSleep(2000)
			color = getColor(540, 1033);
			if color == 0x666666 then
				--灰色，表示有弹窗，已经下过单了，直接返回
				nLog("已经选过课了，返回进行下一个")
				os.execute("input keyevent 4");
				mSleep(2000)
				os.execute("input keyevent 4");
				mSleep(2000)
			else
				--可以选课
				tap(510,1230); --点击稍后支付，然后循环等待，直到付款成功
				repeat
					-- body
					mSleep(2000);
					nLog("please whait...")
				until getColor(166, 1136) == 0xffffff 
				nLog("选课成功")
				mSleep(4000)
				os.execute("input keyevent 4");
				mSleep(2000)
			end
		elseif color_next == 0xd8d8d8 then
			--color_next == 0xd8d8d8 灰色按钮，表示已经报名了
			os.execute("input keyevent 4");
			mSleep(2000)
			nLog("按钮灰色,已经报名了")
		else
			nLog("no more course")
		end
	end
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
	UILabel("请选择需要下单的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("choice_name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	nLog("choice_name = "..choice_name)  --choice_name是UICombo返回的，用户选择的字符串
	
	index = tonumber(strSplit(choice_name)[1]);
	
	info = strSplit(data[index],",");
	userName = info[1];
	passWord = info[2];
	
	nLog("index = "..index.."   userName = "..userName.."   passWord = "..passWord);
	
	mSleep(500)
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
	startToXiadan(5)
	
	os.execute("input keyevent 4");
	mSleep(2000)
	os.execute("input keyevent 4");
	mSleep(2000)
	os.execute("input keyevent 4");
	mSleep(2000)
	
	for var = 1,5 do
		--playAudio("alert.mp3"); --播放警报铃声
		vibrator();             --振动
		mSleep(1000);           --延迟 1 秒
	end
	
	closeLog("test");  --关闭日志
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

main()