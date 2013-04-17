resty-dump
==========

PHP-Like var_dump for ngx_lua

# Uses #
    
    local d = require "resty.dump"
    
    local var_to_dump = {"hello", "world", 2013}
    local var_to_debug = {num=1024, str="abc", bool=true, "test", 2013}
    
    d.var_dump(var_to_dump)
    d.debug(var_to_debug)
    
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
    
If "d.html = true" is set.
    
  ![pretty output](https://raw.github.com/lindowx/resty-dump/master/pretty_output.png)

# Attrs #

 - *html [true|false]*
  
  Print the dump info as html string (or plain text).

# Methods #

 - *var_dump(var)*
 
  Print the dump info.

 - *debug(var)*
 
  Print the dump info and exit with HTTP status 200.
