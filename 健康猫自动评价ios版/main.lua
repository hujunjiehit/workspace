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
	m,n = findColorInRegionFuzzy(0x33c774,80,448,133,629,1084);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		return flag_count;
	end
	
	for index = begin,6 do	
		nLog("index = "..index.."   y  = "..tostring(195+154*(index-1)));
		y = 195+154*(index-1);
		tap(346,195+154*(index-1));	
		
		repeat
			mSleep(500)
			nLog("正在加载课程详情页 wait...");
		until getColor(262,570) ~= 0x333333
		--此处有可能网络出错
		
		mSleep(1000);
		
		if getColor(232, 1080) == 0x5cd390 then  --可以评价
			
			nLog("可以评价。");
			
			tap(232, 1080)
			mSleep(1000);
			
			tap(280,600);	--点击输入框，获取焦点
			mSleep(500);
			inputText("很好非常好");
			mSleep(500);
			
			tap(525,190);	--点击空白，取消输入法键盘
			mSleep(500);
			
			tap(320,1080);	--点击提交评价
			repeat
				mSleep(500)
			until getColor(262,570) ~= 0x333333
			--根据color_next判断下一步动作
			--1.color_next == 0x33c774 未跳转，还在当前页面，表示网络出错
			--2.color_next == 0xf2f2f2 跳转成功，表示评价成功
			
			mSleep(1000)
			if getColor(210,1080) == 0x5cd390 then
				--评价失败
				nLog("评价失败。");
				goBack();
				goBack();
			else
				--评价成功
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


function doTheWork(...)
	-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		
		login(userName,passWord);
		mSleep(2000)
		
		gotoPingjiaPage();
		
		num1 = startToPingjia(1);
		nLog("num1 = "..num1);
		
		pull_the_screen(320,560,-508)
		mSleep(1000)
		
		num2 = startToPingjia(1);
		nLog("num2 = "..num2);
		
		wLog("脚本评价记录","帐号"..userName.."成功进行了"..num1+num2.."条评价");
		
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