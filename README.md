resty-dump
==========

PHP-Like var_dump for ngx_lua

# Uses #
    
    local d = require "resty.dump"
    -- d.html = true
    
    local var_to_dump = {"hello", "world", 2013}
    local var_to_debug = {num=1024, str="abc", bool=true, "test", 2013}
    
    d.var_dump(var_to_dump)
    d.debug(var_to_debug)
    

# Attrs #

 - *html [true|false]*
  
  Print the dump info as html string (or plain text).

# Methods #

 - *var_dump(var)*
 
  Print the dump info.

 - *debug(var)*
 
  Print the dump info and exit with HTTP status 200.
