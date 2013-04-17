---
-- Dump tool
-- Copyright (C) 2013 Zhiqiang Lan (Lindowx)
-- @module resty.dump

module(..., package.seeall)

_VERSION = '0.1.0'

html = false

local header_sent = false
local function test_html()
	if html and not header_sent then
		ngx.header["Content-Type"] = "text/html;charset=utf-8"
		local styles = {
			"<style type=\"text/css\">",
			".dump_info_div{line-height:18px;}",
			".t_str{color:black;}",
			".v_str{color:green;}",
			".v_num{color:red;}",
			".t_tab{font-weight:bold;}",
			".ts{color:#009;font-weight:bold}",
			"</style>\n"
		}
		ngx.print(table.concat(styles))
		header_sent = true
	end
end

local function s(str, class, n)
	if html then
		str = '<span class="' .. class .. '">' .. str .. '</span>'
		if n then
			str = str .. "<br />"
		end
	else
		if n then
			str = str .. "\n"
		end
	end
	
	return str
end

local function idt(n)
	local indent = ""
	local placeholder = "    "
	if html then
		placeholder = "<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
	end
	
	for j =1,n do
		indent = indent .. placeholder
	end 
	
	return indent
end

function print_table(t, i)
	test_html()
	
	local indent = ""
	if not i then i=0 end

	for k, v in pairs(t) do
		local v_type = type(v)
		local k_type = type(k)
		
		if k_type == "string" then
			ngx.print(idt(i) .. "[" .. s("\"" .. k .. "\"", "v_str") .. "] => ")
		else
			ngx.print(idt(i) .. "[" .. s(k, "v_num") .. "] => ")
		end
		
		if v_type == "table" then
			ngx.print(s("table", "t_tab") .. s(" {", "ts", 1))
			
			if v == {} then
				
			else
				print_table(v, i + 1)
			end
			ngx.print(idt(i) .. s("}", "ts", 1))
		else
			var_dump(v)
		end
	end
	
end

function var_dump(var)
	test_html()
	
	local var_type = type(var)
	if var_type == "string" then
		ngx.print( s(var_type, "t_str") .. "(" .. s(#var, "v_num") .. ")" .. s("\"" .. var .. "\"", "v_str", 1) )
		
	elseif var_type == "table" then
		ngx.print(s("table", "t_tab") .. s("  {", "ts", 1))
		print_table(var, 1)
		ngx.print(s("}", "ts", 1))
	
	elseif var_type == "userdata" then	
		ngx.print(s("userdata [...]", "t_str", 1))
		
	elseif var == nil then
		ngx.print(s("nil", "nil", 1))
		
	else
		ngx.print(s(var_type, "t_str") .. "("  .. s(tostring(var), "v_num") .. ")" .. s("", "ts", 1))
	end
end

function debug(var)
	test_html()
	
	var_dump(var)
	ngx.exit(200)
end