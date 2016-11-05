require "TSLib"

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
	
		index = strSplit(name)[1];
		nLog("index = "..index);
		
		info = strSplit(data[tonumber(index)],",");
		
		userName = info[1];
		passWord = info[2];
		
		nLog("userName = "..userName.."   passWord = "..passWord);
		
		mSleep(1000)
		
		setScreenScale(true, 640, 1136) 
		
		login(userName,passWord);
			
		setScreenScale(false)
	end
end 

function main(...)
	-- body
	init("0", 0);  --竖屏
	showFloatButton(false);
	
	width,height = getScreenSize();
	nLog("[DATE]"..width.."---"..height);
	if width == 640 and height == 1136 then
		main_iphone5();
	else
		main_iphone6();
	end
end
main()