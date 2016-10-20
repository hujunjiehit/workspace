 require "TSLib"

function login(userName,passWord)
	tap(626,1227); --点击我的tab，拉起登陆界面 
	switchTSInputMethod(true);
	mSleep(1000);
	
	target_color = getColor(400,211)	--获取健康猫logo的背景颜色
	nLog("target_color = 0x"..string.format("%X",target_color));
	
	isFirst = true;
	while  target_color ==  0x3aab47 do
		nLog("now begin to login");
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
		tap(450,629); --点击登陆按钮
		
		repeat
			mSleep(1000)
			nLog("loging now...")
		until getColor(450,629) ~= 0xf5f5f5   --正在登录的颜色
		mSleep(2000)
		isFirst = false;
		target_color = getColor(400,211) --获取健康猫logo的背景颜色
	end
	nLog("login sucess!");
	nLog(userName.."登录成功");
	switchTSInputMethod(false);
end

function main(...)
	-- body
	init(0)
	nLog("hello ui test");
	showFloatButton(false);
	
	path = getSDCardPath();
	data = readFile(path.."/info.txt") 	--读取文件内容，返回一个table
	str = "";
	for i = 1,#data do
		nLog(i..":"..data[i])
		result = strSplit(data[i],",")
		if result ~= nill then
			str = str..i.."@第"..i.."个帐号:"..result[1]..",";
		end
	end
	
	nLog("str = "..str);
	
	UINew({titles="我的脚本",okname="开始",cancelname="取消",config="UIconfig.dat"})
	UILabel("请选择需要登录的帐号：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	UIShow();
	
	if name == nil then
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
		
		setScreenScale(true, 720, 1280)
		
		login(userName,passWord);
		
		toast("登陆成功",1)
		
		setScreenScale(false, 720, 1280)
	end
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
	setScreenScale(false, 720, 1280)
end

main()