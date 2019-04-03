<html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/><title>requfiles/dkjson.lua</title></head><body><p dir="ltr">&#160;&#160;-- Module options:</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local always_try_using_lpeg = true</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local register_global_module_table = false</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local global_module_name = 'json'<br></p>
<p dir="ltr">&#160;&#160;&#160;&#160;--[==[</p>
<p dir="ltr">David Kolf's JSON module for Lua 5.1/5.2</p>
<p dir="ltr">========================================</p>
<p dir="ltr">*Version 2.4*</p>
<p dir="ltr">In the default configuration this module writes no global values, not even</p>
<p dir="ltr">the module table. Import it using</p>
<p dir="ltr">json = require ("dkjson")</p>
<p dir="ltr">In environments where `require` or a similiar function are not available</p>
<p dir="ltr">and you cannot receive the return value of the module, you can set the</p>
<p dir="ltr">option `register_global_module_table` to `true`. The module table will</p>
<p dir="ltr">then be saved in the global variable with the name given by the option</p>
<p dir="ltr">`global_module_name`.</p>
<p dir="ltr">Exported functions and values:</p>
<p dir="ltr">`json.encode (object [, state])`</p>
<p dir="ltr">--------------------------------</p>
<p dir="ltr">Create a string representing the object. `Object` can be a table,</p>
<p dir="ltr">a string, a number, a boolean, `nil`, `json.null` or any object with</p>
<p dir="ltr">a function `__tojson` in its metatable. A table can only use strings</p>
<p dir="ltr">and numbers as keys and its values have to be valid objects as</p>
<p dir="ltr">well. It raises an error for any invalid data types or reference</p>
<p dir="ltr">cycles.</p>
<p dir="ltr">`state` is an optional table with the following fields:</p>
<p dir="ltr">- `indent` </p>
<p dir="ltr">When `indent` (a boolean) is set, the created string will contain</p>
<p dir="ltr">newlines and indentations. Otherwise it will be one long line.</p>
<p dir="ltr">- `keyorder` </p>
<p dir="ltr">`keyorder` is an array to specify the ordering of keys in the</p>
<p dir="ltr">encoded output. If an object has keys which are not in this array</p>
<p dir="ltr">they are written after the sorted keys.</p>
<p dir="ltr">- `level` </p>
<p dir="ltr">This is the initial level of indentation used when `indent` is</p>
<p dir="ltr">set. For each level two spaces are added. When absent it is set</p>
<p dir="ltr">to 0.</p>
<p dir="ltr">- `buffer` </p>
<p dir="ltr">`buffer` is an array to store the strings for the result so they</p>
<p dir="ltr">can be concatenated at once. When it isn't given, the encode</p>
<p dir="ltr">function will create it temporary and will return the</p>
<p dir="ltr">concatenated result.</p>
<p dir="ltr">- `bufferlen` </p>
<p dir="ltr">When `bufferlen` is set, it has to be the index of the last</p>
<p dir="ltr">element of `buffer`.</p>
<p dir="ltr">- `tables` </p>
<p dir="ltr">`tables` is a set to detect reference cycles. It is created</p>
<p dir="ltr">temporary when absent. Every table that is currently processed</p>
<p dir="ltr">is used as key, the value is `true`.</p>
<p dir="ltr">When `state.buffer` was set, the return value will be `true` on</p>
<p dir="ltr">success. Without `state.buffer` the return value will be a string.</p>
<p dir="ltr">`json.decode (string [, position [, null]])`</p>
<p dir="ltr">--------------------------------------------</p>
<p dir="ltr">Decode `string` starting at `position` or at 1 if `position` was</p>
<p dir="ltr">omitted.</p>
<p dir="ltr">`null` is an optional value to be returned for null values. The</p>
<p dir="ltr">default is `nil`, but you could set it to `json.null` or any other</p>
<p dir="ltr">value.</p>
<p dir="ltr">The return values are the object or `nil`, the position of the next</p>
<p dir="ltr">character that doesn't belong to the object, and in case of errors</p>
<p dir="ltr">an error message.</p>
<p dir="ltr">Two metatables are created. Every array or object that is decoded gets</p>
<p dir="ltr">a metatable with the `__jsontype` field set to either `array` or</p>
<p dir="ltr">`object`. If you want to provide your own metatables use the syntax</p>
<p dir="ltr">json.decode (string, position, null, objectmeta, arraymeta)</p>
<p dir="ltr">To prevent the assigning of metatables pass `nil`:</p>
<p dir="ltr">json.decode (string, position, null, nil)</p>
<p dir="ltr">`&lt;metatable&gt;.__jsonorder`</p>
<p dir="ltr">-------------------------</p>
<p dir="ltr">`__jsonorder` can overwrite the `keyorder` for a specific table.</p>
<p dir="ltr">`&lt;metatable&gt;.__jsontype`</p>
<p dir="ltr">------------------------</p>
<p dir="ltr">`__jsontype` can be either `"array"` or `"object"`. This value is only</p>
<p dir="ltr">checked for empty tables. (The default for empty tables is `"array"`).</p>
<p dir="ltr">`&lt;metatable&gt;.__tojson (self, state)`</p>
<p dir="ltr">------------------------------------</p>
<p dir="ltr">You can provide your own `__tojson` function in a metatable. In this</p>
<p dir="ltr">function you can either add directly to the buffer and return true,</p>
<p dir="ltr">or you can return a string. On errors nil and a message should be</p>
<p dir="ltr">returned.</p>
<p dir="ltr">`json.null`</p>
<p dir="ltr">-----------</p>
<p dir="ltr">You can use this value for setting explicit `null` values.</p>
<p dir="ltr">`json.version`</p>
<p dir="ltr">--------------</p>
<p dir="ltr">Set to `"dkjson 2.4"`.</p>
<p dir="ltr">`json.quotestring (string)`</p>
<p dir="ltr">---------------------------</p>
<p dir="ltr">Quote a UTF-8 string and escape critical characters using JSON</p>
<p dir="ltr">escape sequences. This function is only necessary when you build</p>
<p dir="ltr">your own `__tojson` functions.</p>
<p dir="ltr">`json.addnewline (state)`</p>
<p dir="ltr">-------------------------</p>
<p dir="ltr">When `state.indent` is set, add a newline to `state.buffer` and spaces</p>
<p dir="ltr">according to `state.level`.</p>
<p dir="ltr">LPeg support</p>
<p dir="ltr">------------</p>
<p dir="ltr">When the local configuration variable `always_try_using_lpeg` is set,</p>
<p dir="ltr">this module tries to load LPeg to replace the `decode` function. The</p>
<p dir="ltr">speed increase is significant. You can get the LPeg module at</p>
<p dir="ltr">&lt;http://www.inf.puc-rio.br/~roberto/lpeg/&gt;.</p>
<p dir="ltr">When LPeg couldn't be loaded, the pure Lua functions stay active.</p>
<p dir="ltr">In case you don't want this module to require LPeg on its own,</p>
<p dir="ltr">disable the option `always_try_using_lpeg` in the options section at</p>
<p dir="ltr">the top of the module.</p>
<p dir="ltr">In this case you can later load LPeg support using</p>
<p dir="ltr">### `json.use_lpeg ()`</p>
<p dir="ltr">Require the LPeg module and replace the functions `quotestring` and</p>
<p dir="ltr">and `decode` with functions that use LPeg patterns.</p>
<p dir="ltr">This function returns the module table, so you can load the module</p>
<p dir="ltr">using:</p>
<p dir="ltr">json = require "dkjson".use_lpeg()</p>
<p dir="ltr">Alternatively you can use `pcall` so the JSON module still works when</p>
<p dir="ltr">LPeg isn't found.</p>
<p dir="ltr">json = require "dkjson"</p>
<p dir="ltr">pcall (json.use_lpeg)</p>
<p dir="ltr">### `json.using_lpeg`</p>
<p dir="ltr">This variable is set to `true` when LPeg was loaded successfully.</p>
<p dir="ltr">---------------------------------------------------------------------</p>
<p dir="ltr">Contact</p>
<p dir="ltr">-------</p>
<p dir="ltr">You can contact the author by sending an e-mail to 'david' at the</p>
<p dir="ltr">domain 'dkolf.de'.</p>
<p dir="ltr">---------------------------------------------------------------------</p>
<p dir="ltr">*Copyright (C) 2010-2013 David Heiko Kolf*</p>
<p dir="ltr">Permission is hereby granted, free of charge, to any person obtaining</p>
<p dir="ltr">a copy of this software and associated documentation files (the</p>
<p dir="ltr">"Software"), to deal in the Software without restriction, including</p>
<p dir="ltr">without limitation the rights to use, copy, modify, merge, publish,</p>
<p dir="ltr">distribute, sublicense, and/or sell copies of the Software, and to</p>
<p dir="ltr">permit persons to whom the Software is furnished to do so, subject to</p>
<p dir="ltr">the following conditions:</p>
<p dir="ltr">The above copyright notice and this permission notice shall be</p>
<p dir="ltr">included in all copies or substantial portions of the Software.</p>
<p dir="ltr">THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,</p>
<p dir="ltr">EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF</p>
<p dir="ltr">MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND</p>
<p dir="ltr">NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS</p>
<p dir="ltr">BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN</p>
<p dir="ltr">ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN</p>
<p dir="ltr">CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE</p>
<p dir="ltr">SOFTWARE.</p>
<p dir="ltr">&lt;!-- This documentation can be parsed using Markdown to generate HTML.</p>
<p dir="ltr">The source code is enclosed in a HTML comment so it won't be displayed</p>
<p dir="ltr">by browsers, but it should be removed from the final HTML file as</p>
<p dir="ltr">it isn't a valid HTML comment (and wastes space).</p>
<p dir="ltr">--&gt;</p>
<p dir="ltr">&lt;!--]==]<br></p>
<p dir="ltr">-- global dependencies:</p>
<p dir="ltr">local pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset =</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset</p>
<p dir="ltr">local error, require, pcall, select = error, require, pcall, select</p>
<p dir="ltr">local floor, huge = math.floor, math.huge</p>
<p dir="ltr">local strrep, gsub, strsub, strbyte, strchar, strfind, strlen, strformat =</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;string.rep, string.gsub, string.sub, string.byte, string.char,</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;string.find, string.len, string.format</p>
<p dir="ltr">local strmatch = string.match</p>
<p dir="ltr">local concat = table.concat<br></p>
<p dir="ltr">local json = { version = "dkjson 2.4" }<br></p>
<p dir="ltr">if register_global_module_table then</p>
<p dir="ltr">&#160;&#160;_G[global_module_name] = json</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local _ENV = nil -- blocking globals in Lua 5.2<br></p>
<p dir="ltr">pcall (function()</p>
<p dir="ltr">&#160;&#160;-- Enable access to blocked metatables.</p>
<p dir="ltr">&#160;&#160;-- Don't worry, this module doesn't change anything in them.</p>
<p dir="ltr">&#160;&#160;local debmeta = require "debug".getmetatable</p>
<p dir="ltr">&#160;&#160;if debmeta then getmetatable = debmeta end</p>
<p dir="ltr">end)<br></p>
<p dir="ltr">json.null = setmetatable ({}, {</p>
<p dir="ltr">&#160;&#160;__tojson = function () return "null" end</p>
<p dir="ltr">})<br></p>
<p dir="ltr">local function isarray (tbl)</p>
<p dir="ltr">&#160;&#160;local max, n, arraylen = 0, 0, 0</p>
<p dir="ltr">&#160;&#160;for k,v in pairs (tbl) do</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if k == 'n' and type(v) == 'number' then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;arraylen = v</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if v &gt; max then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;max = v</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if type(k) ~= 'number' or k &lt; 1 or floor(k) ~= k then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;return false</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if k &gt; max then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;max = k</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;n = n + 1</p>
<p dir="ltr">&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;if max &gt; 10 and max &gt; arraylen and max &gt; n * 2 then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return false -- don't create an array with too many holes</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;return true, max</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local escapecodes = {</p>
<p dir="ltr">&#160;&#160;["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f",</p>
<p dir="ltr">&#160;&#160;["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t"</p>
<p dir="ltr">}<br></p>
<p dir="ltr">local function escapeutf8 (uchar)</p>
<p dir="ltr">&#160;&#160;local value = escapecodes[uchar]</p>
<p dir="ltr">&#160;&#160;if value then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return value</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;local a, b, c, d = strbyte (uchar, 1, 4)</p>
<p dir="ltr">&#160;&#160;a, b, c, d = a or 0, b or 0, c or 0, d or 0</p>
<p dir="ltr">&#160;&#160;if a &lt;= 0x7f then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = a</p>
<p dir="ltr">&#160;&#160;elseif 0xc0 &lt;= a and a &lt;= 0xdf and b &gt;= 0x80 then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = (a - 0xc0) * 0x40 + b - 0x80</p>
<p dir="ltr">&#160;&#160;elseif 0xe0 &lt;= a and a &lt;= 0xef and b &gt;= 0x80 and c &gt;= 0x80 then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = ((a - 0xe0) * 0x40 + b - 0x80) * 0x40 + c - 0x80</p>
<p dir="ltr">&#160;&#160;elseif 0xf0 &lt;= a and a &lt;= 0xf7 and b &gt;= 0x80 and c &gt;= 0x80 and d &gt;= 0x80 then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = (((a - 0xf0) * 0x40 + b - 0x80) * 0x40 + c - 0x80) * 0x40 + d - 0x80</p>
<p dir="ltr">&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return ""</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;if value &lt;= 0xffff then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return strformat ("\\u%.4x", value)</p>
<p dir="ltr">&#160;&#160;elseif value &lt;= 0x10ffff then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;-- encode as UTF-16 surrogate pair</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = value - 0x10000</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local highsur, lowsur = 0xD800 + floor (value/0x400), 0xDC00 + (value % 0x400)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return strformat ("\\u%.4x\\u%.4x", highsur, lowsur)</p>
<p dir="ltr">&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return ""</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function fsub (str, pattern, repl)</p>
<p dir="ltr">&#160;&#160;-- gsub always builds a new string in a buffer, even when no match</p>
<p dir="ltr">&#160;&#160;-- exists. First using find should be more efficient when most strings</p>
<p dir="ltr">&#160;&#160;-- don't contain the pattern.</p>
<p dir="ltr">&#160;&#160;if strfind (str, pattern) then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return gsub (str, pattern, repl)</p>
<p dir="ltr">&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return str</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function quotestring (value)</p>
<p dir="ltr">&#160;&#160;-- based on the regexp "escapable" in https://github.com/douglascrockford/JSON-js</p>
<p dir="ltr">&#160;&#160;value = fsub (value, "[%z\1-\31\"\\\127]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;if strfind (value, "[\194\216\220\225\226\239]") then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\194[\128-\159\173]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\216[\128-\132]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\220\143", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\225\158[\180\181]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\226\128[\140-\143\168-\175]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\226\129[\160-\175]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\239\187\191", escapeutf8)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;value = fsub (value, "\239\191[\176-\191]", escapeutf8)</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;return "\"" .. value .. "\""</p>
<p dir="ltr">end</p>
<p dir="ltr">json.quotestring = quotestring<br></p>
<p dir="ltr">local function replace(str, o, n)</p>
<p dir="ltr">&#160;&#160;local i, j = strfind (str, o, 1, true)</p>
<p dir="ltr">&#160;&#160;if i then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return strsub(str, 1, i-1) .. n .. strsub(str, j+1, -1)</p>
<p dir="ltr">&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return str</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">end<br></p>
<p dir="ltr">-- locale independent num2str and str2num functions</p>
<p dir="ltr">local decpoint, numfilter<br></p>
<p dir="ltr">local function updatedecpoint ()</p>
<p dir="ltr">&#160;&#160;decpoint = strmatch(tostring(0.5), "([^05+])")</p>
<p dir="ltr">&#160;&#160;-- build a filter that can be used to remove group separators</p>
<p dir="ltr">&#160;&#160;numfilter = "[^0-9%-%+eE" .. gsub(decpoint, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"</p>
<p dir="ltr">end<br></p>
<p dir="ltr">updatedecpoint()<br></p>
<p dir="ltr">local function num2str (num)</p>
<p dir="ltr">&#160;&#160;return replace(fsub(tostring(num), numfilter, ""), decpoint, ".")</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function str2num (str)</p>
<p dir="ltr">&#160;&#160;local num = tonumber(replace(str, ".", decpoint))</p>
<p dir="ltr">&#160;&#160;if not num then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;updatedecpoint()</p>
<p dir="ltr">&#160;&#160;&#160;&#160;num = tonumber(replace(str, ".", decpoint))</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;return num</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function addnewline2 (level, buffer, buflen)</p>
<p dir="ltr">&#160;&#160;buffer[buflen+1] = "\n"</p>
<p dir="ltr">&#160;&#160;buffer[buflen+2] = strrep (" ", level)</p>
<p dir="ltr">&#160;&#160;buflen = buflen + 2</p>
<p dir="ltr">&#160;&#160;return buflen</p>
<p dir="ltr">end<br></p>
<p dir="ltr">function json.addnewline (state)</p>
<p dir="ltr">&#160;&#160;if state.indent then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;state.bufferlen = addnewline2 (state.level or 0,</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;state.buffer, state.bufferlen or #(state.buffer))</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local encode2 -- forward declaration<br></p>
<p dir="ltr">local function addpair (key, value, prev, indent, level, buffer, buflen, tables, globalorder)</p>
<p dir="ltr">&#160;&#160;local kt = type (key)</p>
<p dir="ltr">&#160;&#160;if kt ~= 'string' and kt ~= 'number' then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return nil, "type '" .. kt .. "' is not supported as a key by JSON."</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;if prev then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buflen = buflen + 1</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buffer[buflen] = ","</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;if indent then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buflen = addnewline2 (level, buffer, buflen)</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;buffer[buflen+1] = quotestring (key)</p>
<p dir="ltr">&#160;&#160;buffer[buflen+2] = ":"</p>
<p dir="ltr">&#160;&#160;return encode2 (value, indent, level, buffer, buflen + 2, tables, globalorder)</p>
<p dir="ltr">end<br></p>
<p dir="ltr">encode2 = function (value, indent, level, buffer, buflen, tables, globalorder)</p>
<p dir="ltr">&#160;&#160;local valtype = type (value)</p>
<p dir="ltr">&#160;&#160;local valmeta = getmetatable (value)</p>
<p dir="ltr">&#160;&#160;valmeta = type (valmeta) == 'table' and valmeta -- only tables</p>
<p dir="ltr">&#160;&#160;local valtojson = valmeta and valmeta.__tojson</p>
<p dir="ltr">&#160;&#160;if valtojson then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if tables[value] then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return nil, "reference cycle"</p>
<p dir="ltr">&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;tables[value] = true</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local state = {</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;indent = indent, level = level, buffer = buffer,</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;bufferlen = buflen, tables = tables, keyorder = globalorder</p>
<p dir="ltr">&#160;&#160;&#160;&#160;}</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local ret, msg = valtojson (value, state)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if not ret then return nil, msg end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;tables[value] = nil</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buflen = state.bufferlen</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if type (ret) == 'string' then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;buflen = buflen + 1</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;buffer[buflen] = ret</p>
<p dir="ltr">&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;elseif value == nil then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buflen = buflen + 1</p>
<p dir="ltr">&#160;&#160;&#160;&#160;buffer[buflen] = "null"</p>
</body></html>