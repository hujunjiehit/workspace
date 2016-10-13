function split(str, pat)
     local t = {}
     local fpat = "(.-)" .. pat
     local last_end = 1
     local s, e, cap = str:find(fpat, 1)
     while s do
          if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
          end
          last_end = e+1
          s, e, cap = str:find(fpat, last_end)
     end
     if last_end <= #str then
          cap = str:sub(last_end)
          table.insert(t, cap)
     end
     return t
end

function getRecord()
	record_file = io.open(path.."/record.txt","r");
	if record_file ~= nil then
		r = record_file:read("*l");  --读取一行，但是不保存
		record_file:close();
		if r == nil or r == "" then
			r = 0;
		end
	else
		r = 0;
	end
	return r;
end

function  save_record(value)
	record_file = io.open(path.."/record.txt","w");
	record_file:write(value.."\n");
	record_file:close();
end

function getUserInfo(record)
	-- body
	file = io.open(path.."/info.txt","r");
	index = tonumber(record);
	data = {};
	for line in file:lines() do
		table.insert(data,line);
	end
	
	if index >= #data then
		nLog("no more data");
		result = nil;
	else
		--str = split(data[record],",");
		nLog("data:"..data[index+1]);
		result = split(data[index+1],",");
	end
	
	file:close();
	if result == nil then
		return "","";
	else
		return result[1],result[2];
	end
end
function login(userName,passWord)
	touchClick(626,1227); --点击我的tab，拉起登陆界面 
	switchTSInputMethod(true);
	
	m,n = findColorInRegionFuzzy(0xff6bac,80,3,403,710,506);
	nLog(m.."----"..n)
	isFirst = true;
	while m == -1 and n == -1 do
		nLog("flag is false");
		mSleep(500);
		touchClick(400,429);  --点击帐号输入框
		mSleep(1000);
		--[[for var = 1,15 do
			inputText("\b")       --删除输入框中的文字（假设输入框中已存在文字）
		end]]
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");

		mSleep(2000);
		inputText(userName);
	
		mSleep(1000);
		touchClick(400,507);   --点击密码输入框
		mSleep(1000);
		if isFirst == false then
			--[[for var = 1,15 do
				inputText("\b");     --删除输入框中的文字(假设输入框中已存在文字)
			end]]
			inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		end
		
		mSleep(2000);
		inputText(passWord);
	
		mSleep(1000)
		touchClick(529,629); 
		
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

function touchClick(x,y)
	nLog("点击坐标  x = "..x.." y = "..y)
	wLog("test","点击坐标  x = "..x.." y = "..y); 
	touchDown(x, y);
	mSleep(30);
	touchUp(x, y);
end

function pull_the_screen(x,y,dy)
	nLog("下拉屏幕")
	touchDown(x, y);    --在 (150, 550) 按下
	mSleep(50);
	touchMove(x, y+dy);   --移动到 (150, 600)
	mSleep(50);
	touchUp(x, y+dy);
end

--跳转到所有团课界面
function geToAllCourcesPage()
	touchClick(626,1131); --点击我的tab
	mSleep(2000);
	touchClick(362,334);	--点击关注
	mSleep(2000);
	touchClick(303,203);
	mSleep(2000);
	
	pull_the_screen(100,150,-120);
	mSleep(3000)
	
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
		touchClick(x+38,y+22);			--那么单击该图片
		
		return 0;
	else                               --如果找不到符合条件的图片
		os.execute("input keyevent 4");
		mSleep(1000)
		os.execute("input keyevent 4");
		mSleep(1000)
		wLog("test","没找到更多的按钮，返回到我的界面"); 
		return -1;
	end
end

function logout()
	touchClick(626,1131); --登录状态下，点击我的tab，进入个人资料界面
	mSleep(1000)
	touchClick(320,1020);	--进入设置
	mSleep(500)
	touchClick(350,799);	--点击退出登录
	mSleep(500)
	touchClick(513,675);	--点击确定
	repeat
		mSleep(1000)
	until getColor(501,798) ~= 0x663434  --健康猫logo color
end

function startToXiadan()
	for index = 1,7 do	
		nLog("index = "..index.."   y  = "..tostring(207+142*(index-1)));
		y = 207+142*(index-1);
		
		color_current = getColor(510,1230)   --点击之前，该点的颜色
		
		touchClick(363,207+142*(index-1));
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
			touchClick(510,1230);
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
				touchClick(510,1230); --点击稍后支付，然后循环等待，直到付款成功
				repeat
					-- body
					mSleep(1000);
					nLog("please whait...")
				until getColor(166, 1136) == 0xffffff 
				nLog("选课成功")
				mSleep(2000)
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
	
	--[[local sz = require("sz")
	local json = sz.json
	local w,h = getScreenSize();
	MyTable = {
		["style"] = "default",
		["width"] = w,
		["height"] = h,
		["timer"] = 100,
		views = {
			{
				["type"] = "Edit",        --输入框，input1
				["prompt"] = "请输入帐号",--编辑框中无任何内容时显示的底色文本
				["text"] = "",        --界面载入时已经存在于编辑框中的文本
			},
			{
				["type"] = "Edit",        --输入框，input2
				["prompt"] = "请输入密码",--编辑框中无任何内容时显示的底色文本
				["text"] = "",        --界面载入时已经存在于编辑框中的文本
			},
		}
	}
	
	local MyJsonString = json.encode(MyTable);
	ret, input1, input2 = showUI(MyJsonString);	--返回值ret, input1, input2, input3, input4


	if input2 == nil or input2 == "" then
		input2 = input1
	end

	mSleep(2000)
	wLog("test",ret.."  input1="..input1.."  input2="..input2)
	login(input1,input2);]]
	
	record = getRecord();
	choice = dialogRet("当前进度:"..record..",   是否继续执行 ？","从头开始", "继续执行","",0);
	nLog("choice = "..choice);
	if choice == 0 then
		--从头开始
		record = 0;
	end
	nLog("record = "..record);
	userName,passWord = getUserInfo(record);
	
	if userName == nil or passWord == nil then
		--没有更多帐号
		dialog("没有更多帐号了！", 2)
		lua_exit();
	end
	
		
	wLog("test","userName="..userName.."  passWord="..passWord);
	
	nLog("userName="..userName.."  passWord="..passWord);
	mSleep(2000)
	
	login(userName,passWord)
	
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

	mSleep(2000)
	startToXiadan(363,207)

	pull_the_screen(100,150,-150);
	mSleep(3000)
	startToXiadan(363,207)
	
	--[[
	pull_the_screen(100,150,-100);
	mSleep(2000)
	startToXiadan(363,207)
	
	pull_the_screen(100,150,-100);
	mSleep(2000)
	startToXiadan(363,207)
	
	pull_the_screen(100,150,-100);
	mSleep(2000)
	startToXiadan(363,207)
	]]
	
	os.execute("input keyevent 4");
	mSleep(1000)
	os.execute("input keyevent 4");
	mSleep(1000)
	os.execute("input keyevent 4");
	mSleep(1000)
	
	if userName ~= "" and passWord ~= "" then
		save_record(record+1);
	end
	
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