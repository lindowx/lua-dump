lua-dump
==========

PHP-like var_dump for ngx_lua

Tags: Lua Nginx dump var_dump debug

# Uses #
    
    local d = require "resty.dump"
    
    local str = "hello, world"
    local num = 1024
    local var_to_dump = {"hello", "world", 2013}
    local var_to_debug = {num=1024, str="abc", bool=true, "test", 2013}
    
    d.var_dump(var_to_dump)
    d.debug(var_to_debug, str, num)
    
Output:
 
    table  {
        [1] => string(5)"hello"
        [2] => string(5)"world"
        [3] => number(2013)
    }
    table  {
        [1] => string(4)"test"
        [2] => number(2013)
        ["bool"] => boolean(true)
        ["num"] => number(1024)
        ["str"] => string(3)"abc"
    }
    string(12)"hello, world"
    number(1024)
    
If "d.html = true" is set, it looks more pretty.

    d.html = true
    -- dump some vars
    
Output:
    
  ![pretty output](https://raw.github.com/lindowx/lua-dump/master/pretty_output.png)

# Attrs #

 - *html [true|false]*
  
  Print the dump info as html string (or else plain text).

# Methods #

 - *var_dump(...)*
 
  Print the dump info.

 - *debug(...)*
 
  Print the dump info then stop the code execution.
