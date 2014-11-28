---
-- Dump tool
-- Copyright (C) 2013 Zhiqiang Lan (Lindowx)
-- @module resty.dump

module(..., package.seeall)

_VERSION = '0.2.0'

html = false

local header_sent = false
local function test_html()
	if html and not header_sent then
		ngx.header["Content-Type"] = "text/html;charset=utf-8"
		local styles = {
			"<style type=\"text/css\">",
			".resty_dump_info_div{line-height:18px;}",
			".resty_dump_t_str{color:black;}",
			".resty_dump_v_str{color:green;}",
			".resty_dump_v_num{color:red;}",
			".resty_dump_t_tab{font-weight:bold;}",
			".resty_dump_ts{color:#009;font-weight:bold}",
			".resty_dump_t_nil{color:#aaa;font-style:italic;}",
			".resty_dump_t_global_data{color:#999; font-style:italic}",
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
	local placeholder = "    "
	if html then
		placeholder = "<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>"
	end

	return string.rep(placeholder, n)
end

function print_table(t, i)
	test_html()

	i = i or 0

	for k, v in pairs(t) do
		local v_type = type(v)
		local k_type = type(k)

		if k_type == "string" then
			ngx.print(idt(i) .. "[" .. s("\"" .. k .. "\"", "resty_dump_v_str") .. "] => ")
		else
			ngx.print(idt(i) .. "[" .. s(k, "resty_dump_v_num") .. "] => ")
		end

		if k == "_G" then
			ngx.print(s("Global Data {...}", "resty_dump_t_global_data", 1))

		elseif k == "_M" then
			ngx.print(s("Module Self {...}", "resty_dump_t_global_data", 1))

		elseif v_type == "table" then
			ngx.print(s("table", "resty_dump_t_tab") .. s(" {", "resty_dump_ts", 1))

			if v == {} then

			else
				print_table(v, i + 1)
			end
			ngx.print(idt(i) .. s("}", "resty_dump_ts", 1))
		else
			var_dump(v)
		end
	end

end

function var_dump(...)
	test_html()

	local argc = #{...}
	local argv = {...}
	local idx = 1

	if argc == 0 then
		ngx.print(s("nil", "resty_dump_t_nil", 1))
	end

	while idx <= argc do
		
		local var = argv[idx]
		local var_type = type(var)

		if var == nil then
			ngx.print(s("nil", "resty_dump_t_nil", 1))
			
		elseif var_type == "string" then
			ngx.print( s(var_type, "resty_dump_t_str") .. "(" .. s(#var, "resty_dump_v_num") .. ")" .. s("\"" .. var .. "\"", "resty_dump_v_str", 1) )
	
		elseif var_type == "table" then
			ngx.print(s("table", "resty_dump_t_tab") .. s("  {", "resty_dump_ts", 1))
			print_table(var, 1)
			ngx.print(s("}", "resty_dump_ts", 1))
	
		elseif var_type == "userdata" then	
			ngx.print(s("userdata [...]", "resty_dump_t_str", 1))
	
		else
			ngx.print(s(var_type, "resty_dump_t_str") .. "("  .. s(tostring(var), "resty_dump_v_num") .. ")" .. s("", "resty_dump_ts", 1))
		end

		idx = idx + 1
	end
	
    
end

function debug(...)
	test_html()

	var_dump(...)
	ngx.exit(200)
end
