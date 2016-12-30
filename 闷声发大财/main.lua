require "TSLib"
local sz = require("sz")
local cjson = sz.json
local http = sz.i82.http

local name;
local token;

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
	mSleep(1000);
end


function login(userName, passWord)
	--http://api.9mli.com/http.aspx?action=loginIn&uid=用户名&pwd=密码   --get
	status_resp, headers_resp, body_resp = http.get("http://api.9mli.com/http.aspx?action=loginIn&uid="..userName.."&pwd="..passWord);	--获取百度首页网页数据

	data = strSplit(body_resp,"|");
	name = data[1];
	token = data[2];
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
		
		if y >= 1135 then
			return flag_count;
		end
		
		tap(x,y);
		
		mSleep(1000);
		
		if isColor(232, 1080,0x5cd390,85) then  --可以评价
			tap(280,600);	--点击输入框，获取焦点
			mSleep(1000);
			
			math.randomseed(getRndNum()) -- 随机种子初始化真随机数
			num = math.random(1, words_count) -- 随机获取一个1-100之间的数字
			inputText(words[num]);
			
			mSleep(500);
			tap(525,190);	--点击空白，取消输入法键盘
			mSleep(500);
			
			repeat
				tap(320,1080);	--点击提交评价
				mSleep(2000);
			until isColor(232, 1080,0x5cd390,85) == false
			
			nLog("评价成功。");
			flag_count = flag_count + 1;
			
			mSleep(500);
		end
		index = index + 1;
	until false
	
end


function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	
	--startToPingjia(1)
	pull_the_screen(320,560,-220)
	

	closeLog("脚本宣传记录");  --关闭日志
end

main()