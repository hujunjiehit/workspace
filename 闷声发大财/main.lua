require "TSLib"
local sz = require("sz")
local cjson = sz.json
local http = sz.i82.http

local name;
local token;

function pull_the_screen(x,y,dy)
	moveTo(x,y,x,y+dy)
end


function login(userName, passWord)
	--http://api.9mli.com/http.aspx?action=loginIn&uid=用户名&pwd=密码   --get
	status_resp, headers_resp, body_resp = http.get("http://api.9mli.com/http.aspx?action=loginIn&uid="..userName.."&pwd="..passWord);	--获取百度首页网页数据

	data = strSplit(body_resp,"|");
	name = data[1];
	token = data[2];
end

function main(...)
	-- body
	init("0", 0);  --竖屏
	initLog("脚本宣传记录", 0);	--把 0 换成 1 即生成形似 test_1397679553.log 的日志文件 

	
	login("笃信好学","13135688723lzg");
	
	toast(name.."--"..token,1)
	
	

	closeLog("脚本宣传记录");  --关闭日志
end

main()