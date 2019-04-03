<html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/><title>requfiles/serpent.lua</title></head><body><p dir="ltr">requfiles/serpent.lua</p>
<p dir="ltr">local n, v = "serpent", 0.28 -- (C) 2012-15 Paul Kulchenko; MIT License</p>
<p dir="ltr">local c, d = "Paul Kulchenko", "Lua serializer and pretty printer"</p>
<p dir="ltr">local snum = {[tostring(1/0)]='1/0 --[[math.huge]]',[tostring(-1/0)]='-1/0 --[[-math.huge]]',[tostring(0/0)]='0/0'}</p>
<p dir="ltr">local badtype = {thread = true, userdata = true, cdata = true}</p>
<p dir="ltr">local keyword, globals, G = {}, {}, (_G or _ENV)</p>
<p dir="ltr">for _,k in ipairs({'and', 'break', 'do', 'else', 'elseif', 'end', 'false',</p>
<p dir="ltr">&#160;&#160;'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat',</p>
<p dir="ltr">&#160;&#160;'return', 'then', 'true', 'until', 'while'}) do keyword[k] = true end</p>
<p dir="ltr">for k,v in pairs(G) do globals[v] = k end -- build func to name mapping</p>
<p dir="ltr">for _,g in ipairs({'coroutine', 'debug', 'io', 'math', 'string', 'table', 'os'}) do</p>
<p dir="ltr">&#160;&#160;for k,v in pairs(G[g] or {}) do globals[v] = g..'.'..k end end<br></p>
<p dir="ltr">local function s(t, opts)</p>
<p dir="ltr">&#160;&#160;local name, indent, fatal, maxnum = opts.name, opts.indent, opts.fatal, opts.maxnum</p>
<p dir="ltr">&#160;&#160;local sparse, custom, huge = opts.sparse, opts.custom, not opts.nohuge</p>
<p dir="ltr">&#160;&#160;local space, maxl = (opts.compact and '' or ' '), (opts.maxlevel or math.huge)</p>
<p dir="ltr">&#160;&#160;local iname, comm = '_'..(name or ''), opts.comment and (tonumber(opts.comment) or math.huge)</p>
<p dir="ltr">&#160;&#160;local seen, sref, syms, symn = {}, {'local '..iname..'={}'}, {}, 0</p>
<p dir="ltr">&#160;&#160;local function gensym(val) return '_'..(tostring(tostring(val)):gsub("[^%w]",""):gsub("(%d%w+)",</p>
<p dir="ltr">&#160;&#160;&#160;&#160;-- tostring(val) is needed because __tostring may return a non-string value</p>
<p dir="ltr">&#160;&#160;&#160;&#160;function(s) if not syms[s] then symn = symn+1; syms[s] = symn end return tostring(syms[s]) end)) end</p>
<p dir="ltr">&#160;&#160;local function safestr(s) return type(s) == "number" and tostring(huge and snum[tostring(s)] or s)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;or type(s) ~= "string" and tostring(s) -- escape NEWLINE/010 and EOF/026</p>
<p dir="ltr">&#160;&#160;&#160;&#160;or ("%q"):format(s):gsub("\010","n"):gsub("\026","\\026") end</p>
<p dir="ltr">&#160;&#160;local function comment(s,l) return comm and (l or 0) &lt; comm and ' --[['..tostring(s)..']]' or '' end</p>
<p dir="ltr">&#160;&#160;local function globerr(s,l) return globals[s] and globals[s]..comment(s,l) or not fatal</p>
<p dir="ltr">&#160;&#160;&#160;&#160;and safestr(select(2, pcall(tostring, s))) or error("Can't serialize "..tostring(s)) end</p>
<p dir="ltr">&#160;&#160;local function safename(path, name) -- generates foo.bar, foo[3], or foo['b a r']</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local n = name == nil and '' or name</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local plain = type(n) == "string" and n:match("^[%l%u_][%w_]*$") and not keyword[n]</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local safe = plain and n or '['..safestr(n)..']'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;return (path or '')..(plain and path and '.' or '')..safe, safe end</p>
<p dir="ltr">&#160;&#160;local alphanumsort = type(opts.sortkeys) == 'function' and opts.sortkeys or function(k, o, n) -- k=keys, o=originaltable, n=padding</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local maxn, to = tonumber(n) or 12, {number = 'a', string = 'b'}</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local function padnum(d) return ("%0"..tostring(maxn).."d"):format(tonumber(d)) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;table.sort(k, function(a,b)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;-- sort numeric keys first: k[key] is not nil for numerical keys</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return (k[a] ~= nil and 0 or to[type(a)] or 'z')..(tostring(a):gsub("%d+",padnum))</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&lt; (k[b] ~= nil and 0 or to[type(b)] or 'z')..(tostring(b):gsub("%d+",padnum)) end) end</p>
<p dir="ltr">&#160;&#160;local function val2str(t, name, indent, insref, path, plainindex, level)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local ttype, level, mt = type(t), (level or 0), getmetatable(t)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local spath, sname = safename(path, name)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;local tag = plainindex and</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;((type(name) == "number") and '' or name..space..'='..space) or</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;(name ~= nil and sname..space..'='..space or '')</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if seen[t] then -- already seen this element</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;sref[#sref+1] = spath..space..'='..space..seen[t]</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return tag..'nil'..comment('ref', level) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if type(mt) == 'table' and (mt.__serialize or mt.__tostring) then -- knows how to serialize itself</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;seen[t] = insref or spath</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if mt.__serialize then t = mt.__serialize(t) else t = tostring(t) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;ttype = type(t) end -- new value falls through to be serialized</p>
<p dir="ltr">&#160;&#160;&#160;&#160;if ttype == "table" then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if level &gt;= maxl then return tag..'{}'..comment('max', level) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;seen[t] = insref or spath</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if next(t) == nil then return tag..'{}'..comment(t, level) end -- table empty</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local maxn, o, out = math.min(#t, maxnum or #t), {}, {}</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;for key = 1, maxn do o[key] = key end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if not maxnum or #o &lt; maxnum then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;local n = #o -- n = n + 1; o[n] is much faster than o[#o+1] on large tables</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;for key in pairs(t) do if o[key] ~= key then n = n + 1; o[n] = key end end end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if maxnum and #o &gt; maxnum then o[maxnum+1] = nil end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;if opts.sortkeys and #o &gt; maxn then alphanumsort(o, t, opts.sortkeys) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local sparse = sparse and #o &gt; maxn -- disable sparsness if only numeric keys (shorter output)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;for n, key in ipairs(o) do</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;local value, ktype, plainindex = t[key], type(key), n &lt;= maxn and not sparse</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if opts.valignore and opts.valignore[value] -- skip ignored values; do nothing</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;or opts.keyallow and not opts.keyallow[key]</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;or opts.valtypeignore and opts.valtypeignore[type(value)] -- skipping ignored value types</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;or sparse and value == nil then -- skipping nils; do nothing</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;elseif ktype == 'table' or ktype == 'function' or badtype[ktype] then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if not seen[key] and not globals[key] then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;sref[#sref+1] = 'placeholder'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;local sname = safename(iname, gensym(key)) -- iname is table for local variables</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;sref[#sref] = val2str(key,sname,indent,sname,iname,true) end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;sref[#sref+1] = 'placeholder'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;local path = seen[t]..'['..tostring(seen[key] or globals[key] or gensym(key))..']'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;sref[#sref] = path..space..'='..space..tostring(seen[value] or val2str(value,nil,indent,path))</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;out[#out+1] = val2str(value,key,indent,insref,seen[t],plainindex,level+1)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local prefix = string.rep(indent or '', level)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local head = indent and '{\n'..prefix..indent or '{'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local body = table.concat(out, ','..(indent and '\n'..prefix..indent or space))</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local tail = indent and "\n"..prefix..'}' or '}'</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return (custom and custom(tag,head,body,tail) or tag..head..body..tail)..comment(t, level)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;elseif badtype[ttype] then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;seen[t] = insref or spath</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return tag..globerr(t, level)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;elseif ttype == 'function' then</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;seen[t] = insref or spath</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local ok, res = pcall(string.dump, t)</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;local func = ok and ((opts.nocode and "function() --[[..skipped..]] end" or</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;"((loadstring or load)("..safestr(res)..",'@serialized'))")..comment(t, level))</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;return tag..(func or globerr(t, level))</p>
<p dir="ltr">&#160;&#160;&#160;&#160;else return tag..safestr(t) end -- handle all other types</p>
<p dir="ltr">&#160;&#160;end</p>
<p dir="ltr">&#160;&#160;local sepr = indent and "\n" or ";"..space</p>
<p dir="ltr">&#160;&#160;local body = val2str(t, name, indent) -- this call also populates sref</p>
<p dir="ltr">&#160;&#160;local tail = #sref&gt;1 and table.concat(sref, sepr)..sepr or ''</p>
<p dir="ltr">&#160;&#160;local warn = opts.comment and #sref&gt;1 and space.."--[[incomplete output with shared/self-references skipped]]" or ''</p>
<p dir="ltr">&#160;&#160;return not name and body..warn or "do local "..body..sepr..tail.."return "..name..sepr.."end"</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function deserialize(data, opts)</p>
<p dir="ltr">&#160;&#160;local env = (opts and opts.safe == false) and G</p>
<p dir="ltr">&#160;&#160;&#160;&#160;or setmetatable({}, {</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;__index = function(t,k) return t end,</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;__call = function(t,...) error("cannot call functions") end</p>
<p dir="ltr">&#160;&#160;&#160;&#160;&#160;&#160;})</p>
<p dir="ltr">&#160;&#160;local f, res = (loadstring or load)('return '..data, nil, nil, env)</p>
<p dir="ltr">&#160;&#160;if not f then f, res = (loadstring or load)(data, nil, nil, env) end</p>
<p dir="ltr">&#160;&#160;if not f then return f, res end</p>
<p dir="ltr">&#160;&#160;if setfenv then setfenv(f, env) end</p>
<p dir="ltr">&#160;&#160;return pcall(f)</p>
<p dir="ltr">end<br></p>
<p dir="ltr">local function merge(a, b) if b then for k,v in pairs(b) do a[k] = v end end; return a; end</p>
<p dir="ltr">return { _NAME = n, _COPYRIGHT = c, _DESCRIPTION = d, _VERSION = v, serialize = s,</p>
<p dir="ltr">&#160;&#160;load = deserialize,</p>
<p dir="ltr">&#160;&#160;dump = function(a, opts) return s(a, merge({name = '_', compact = true, sparse = true}, opts)) end,</p>
<p dir="ltr">&#160;&#160;line = function(a, opts) return s(a, merge({sortkeys = true, comment = true}, opts)) end,</p>
<p dir="ltr">&#160;&#160;block = function(a, opts) return s(a, merge({indent = ' ', sortkeys = true, comment = true}, opts)) end }</p>
</body></html>