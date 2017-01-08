 require "TSLib"
 
function goBack(str_to_write)
	-- body
	tap(40,98);
	mSleep(1000);
end

function write_to_log(str_to_write)
	-- body
	path = getSDCardPath();
	log_file = io.open(path.."/log.txt","a");
	log_file:write(str_to_write.."\n");
	log_file:close();
end

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

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy,20,50)
end

function touchClick(x,y)
	touchDown(x, y);
	mSleep(30);
	touchUp(x, y);
end

function login(userName,passWord)
	tap(626,1227); --点击我的tab，拉起登陆界面 
	mSleep(500);
	
	while isColor(400,211,0x3aab47,85) do
		nLog("now begin to login");
		mSleep(1000);
		tap(400,429);  --点击帐号输入框
		mSleep(1000);
		
		inputText("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		mSleep(1000);
		
		inputText(userName);
		mSleep(1000);
		
		tap(400,507);   --点击密码输入框
		mSleep(1000);
		
		inputText(passWord);
		mSleep(1000)
		repeat
			if isColor(457,622, 0x59cf8d, 85) then
				tap(450,629); --点击登陆按钮
			end
			mSleep(1000)
			nLog("loging now...")
		until isColor(100,457,0xff6bac,85) and isColor(100,566,0xff5555, 85) and isColor( 103,  685, 0xff852a, 85)
		mSleep(1000)
	end
	tap(626,1227); --点击我的tab
	mSleep(500)
	nLog("login sucess!");
	nLog(userName.."登录成功");
end

function gotoPingjiaPage()
	tap(236,456); --点击我的订单
	mSleep(1000)

	tap(351,86); 	 --点击上面的私教订单，展开选项
	mSleep(1000)
	
	tap(357,268); 	 --选择私教团购订单
	
	repeat
		mSleep(1000);
	until isColor(84,232,0xffffff,85) == false or isColor(595,220,0xffffff,85) == false
	mSleep(500)
	nLog("loading finish");   --here may be fail, so we need to record the progress
end

function logout()
	tap(320,1020);	--进入设置
	repeat
		mSleep(500);
	until getColor(267, 834) ~= 0xffffff
	mSleep(500);

	tap(353,836);	--点击退出登录

	deviceModel = getDeviceModel();
	if deviceModel == "Meitu M4" then  
		mSleep(1000)
		tap(610,806);	--点击确定
	else
		mSleep(1000)
		tap(610,720);	--点击确定
	end
	
	repeat
		mSleep(1000)
	until isColor(592,103,0x22ac39,85)
	mSleep(1000)
	nLog(userName.."退出登录");
end

function beforeUserExit()
    nLog("before user exit");
	switchTSInputMethod(false);
end

function pingjia_the_course(x,y)
	-- body
	nLog("start to pingjia the course, x = "..x.."  y = "..y);
	
	mSleep(500)
	
	tap(x,y);

	repeat
		mSleep(500)
		nLog("loading class..")
	until (isColor(367,629,0xf2f2f2,85) and isColor(177,1229,0x33c774,85)) or 
	(isColor(101,171,0xffffff,85) == false and isColor(102,266,0xffffff,85) == false and isColor(219,1230,0x1f6d41,85) == false and isColor(219,1230,0x33c774,85) == false)
	
	mSleep(500)
	
	if (isColor(367,629,0xf2f2f2,85) and isColor(177,1229,0x33c774,85)) then
		
		nLog("可以评价");
		
		math.randomseed(getRndNum()) -- 随机种子初始化随机数
		num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
		inputText(words[num]);
		mSleep(500);

		local times = 1;
		repeat
			if (isColor( 235, 1231, 0x33c774, 85)) then
				tap(351,1231);	--点击提交评价
				times = times + 1;
			end
			mSleep(1000);
		until (isColor(492,403,0xffffff,85) and isColor( 495,  475, 0xffffff, 85)) or times > 5
		
		if times > 5 then
			nLog("已经评价过了  尝试过5次");
			goBack();
		end
	elseif (isColor(101,171,0xffffff,85) == false and isColor( 102,266,0xffffff,85) == false) then
		nLog("不需要评价");
		goBack();
	end
end

--m,n是第一个绿色点的坐标
function pingjia_one_page(m,n)
	mSleep(500)
	index = 1;
	x = m + 50;
	y = n + 20
	repeat
		nLog(" index = "..index);
		
		if isColor(591,y,0x33c774,85) then
			mSleep(500)
			pingjia_the_course(x,y)
		else
			mSleep(500)
			nLog("按钮不是绿色下一个");
		end
		mSleep(500)
		index = index + 1;
		y = n + 20 + 154*(index-1);
	until y > 1279
end


function startToPingjia_special()
	
	mSleep(1000)
	m,n = findColorInRegionFuzzy(0x33c774,80,0,50,720,1270);
	nLog(m.."----"..n)
	if m == -1 and n == -1 then
		--当前页面没有需要评价的
		mSleep(500);
		return
	end
	
	mSleep(1000);
	
	--开始评价one page
	pingjia_one_page(m,n)
end

function doTheWork_pingjia_special(...)
		-- body
	for i = index,#data do
		info = strSplit(data[i],",");
		userName = info[1];
		passWord = info[2];
		nLog("i = "..i.."   userName = "..userName.."   passWord = "..passWord);
		mSleep(500)
		
		login(userName,passWord);
		
		mSleep(1000);
		
		gotoPingjiaPage();  --跳转到评价页面
		
		startToPingjia_special();
		
		tap(351,86); 	 --点击上面的私教订单，展开选项
		mSleep(1000)
	
		tap(357,268); 	 --选择私教团购订单
	
		repeat
			mSleep(1000);
		until isColor(84,232,0xffffff,85) == false or isColor(595,220,0xffffff,85) == false
		mSleep(500)
		
		pull_the_screen(380,1150,-550);
		mSleep(1000)
		
		startToPingjia_special();
		
		mSleep(1000)
		goBack();
		logout();
	end
end

function write_info(str)
	-- body
	path = getSDCardPath();
	return writeFile(path.."/info.txt",{str});
end

function write_new_pingjia(new_word)
	-- body
	path = getSDCardPath();
	return writeFile(path.."/TouchSprite/res/评价语.txt",{new_word});
end

function manage_the_pingjia_words(...)
	-- body
	path = getSDCardPath();
	if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
		writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
	end

	repeat
		words = readFile(path.."/TouchSprite/res/评价语.txt");
		local pingjia_words = "";
		local check_string = "";
		local int counts = #words;
		for i = 1,#words do
			--nLog(i..":"..data[i])
			pingjia_words = pingjia_words..words[i]..",";
			check_string = check_string.."check"..i..",";
		end
		UINew({titles="管理评价语",okname="添加",cancelname="取消"})
		UILabel("管理评价语",22,"center","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UILabel("\n当前评价语如下：",18,"left","0,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UICheck(check_string,pingjia_words,"");
		
		UILabel("\n\n输入您要添加的评价语(不少于五个字)：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
		UIEdit("new_word","此处输入要添加的评价语","",18,"center","0,0,255")
		
		UILabel("\n评价时会从所有的评价语里面随机选择一个",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
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


function main()
	init(0)
	initLog("test", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 
	wLog("test","[DATE] init log OK!!!"); 
	toast("正在准备界面，请稍候",1)
	switchTSInputMethod(true);
	mSleep(1000)
	write_to_log("\n\n\n\n脚本开始时间:"..os.date("%c"))
	
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
	UILabel("脚本功能选择：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UIRadio("mode","新版本自动评价,管理评价语,手动添加帐号")
	UILabel("请选择从哪一个帐号开始依次往下评价：",15,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
	UICombo("choice_name",str)--可选参数如果写部分的话，该参数前的所有参数都必须需要填写，否则会
	
	UIShow();
	
	index = tonumber(strSplit(choice_name)[1]);
	--nLog("index = "..index);

	mSleep(1000)
	
	setScreenScale(true, 720, 1280);
	
	if mode == "手动添加帐号" then
		repeat
			UINew({titles="添加帐号界面",okname="添加",cancelname="取消"})
			UILabel("输入帐号：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_username","此处输入您的帐号","",15,"center","0,0,255")
			UILabel("输入密码：",22,"left","255,0,0",-1,0) --宽度写-1为一行，自定义宽度可写其他数值
			UIEdit("input_password","此处输入您的密码","",15,"center","0,0,255")
			UIShow();
	
			nLog("input_username:"..input_username);
			nLog("input_password:"..input_password);
			choice = dialogRet("请确认您要添加的帐号和密码：\n 帐号："..input_username.."\n".."密码："..input_password,"重新输入","确认添加","", 0);
			if choice == 1 then
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
	elseif mode == "新版本自动评价" then
		if isFileExist(path.."/TouchSprite/res/评价语.txt") == false then --存在返回true，不存在返回false
			writeFileString(path.."/TouchSprite/res/评价语.txt","很好非常好\n");
		end
		words = readFile(path.."/TouchSprite/res/评价语.txt");
		words_count = #words;
				
		doTheWork_pingjia_special();
		
	elseif mode == "管理评价语" then
		manage_the_pingjia_words();
	end
	switchTSInputMethod(false);
	setScreenScale(false, 720, 1280)
	closeLog("test");  --关闭日志
end

main()
