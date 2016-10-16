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
		--[[for var = 1,15 do
			inputText("\b")       --删除输入框中的文字（假设输入框中已存在文字）
		end]]
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");

		mSleep(1000);
		inputText(userName);
	
		mSleep(1000);
		tap(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			--[[for var = 1,15 do
				inputText("\b");     --删除输入框中的文字(假设输入框中已存在文字)
			end]]
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

function main(...)
	-- body
	nLog("hello ui test");
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
	
	nLog("name = "..name);
	
	index = strSplit(name)[1];
	nLog("index = "..index);
	
	info = strSplit(data[tonumber(index)],",");
	
	userName = info[1];
	passWord = info[2];
	
	nLog("userName = "..userName.."   passWord = "..passWord);
	
	mSleep(1000)
	login(userName,passWord);
	
	toast("登陆成功",1)
	
end

main()