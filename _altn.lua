--@section __lerp__
function lerp(a, b, t)
	return a + (b - a) * t
end
--@endsection
--@section __Txtbox__
function calculateTextOffset2d(width,height,ox,oy,text,threebyfive)
    local textWidth = #text * (threebyfive and 3 or 4) --Sw regular font is 4 wide, 3x5 from Txt is 3 wide.
    local textHeight = 5
    local offsetX = (((ox)*width/2) + (width / 2)) - (textWidth / 2)
    local offsetY = (((oy)*height/2) + (height / 2)) - (textHeight / 2)
    offsetX = clamp(offsetX, 0, width - textWidth)
    offsetY = clamp(offsetY, 0, height - textHeight)
    print(tostring(offsetX)..', '..tostring(offsetY)..', '..tostring(text))
    return offsetX, offsetY, text

end
function TxtBox(...)
    return calculateTextOffset2d(...)
end
--@endsection
--@section __clamp__
function clamp(var, mi, ma)
	return math.min(math.max(var, mi),ma)
end
--@endsection
--@section __circleSpin__
function circleSpin(sx, sy, l, r)
	screen.drawLine(sx, sy, sx+l*math.cos(r), sy+l*math.sin(r))
end
--@endsection
--@section __circle__
function circle(x, y, r, segments)
	local cos, sin = math.cos, math.sin
	local step = (math.pi * 2) / segments
	for i = 0, math.pi*2, step do
		screen.drawLine(x + cos(i) * r, y + sin(i) * r, x + cos(i+step) * r, y + sin(i+step) * r)
	end
end
--@endsection
--@section __circle2__
function circle2(x, y, r, segments)
	local cos, sin = math.cos, math.sin
	local step = (math.pi * 2) / segments
	for i = math.pi, math.pi*2, step do
		screen.drawLine(x + cos(i) * r, y + sin(i) * r, x + cos(i+step) * r, y + sin(i+step) * r)
	end
end
--@endsection
--@section __circleSpinC__
function circleSpinC(x, y, l, c, turns)
	turns = turns - .25
	local radians = 2 * math.pi * turns
	local newX = x + l * math.cos(radians)
	local newY = y + l * math.sin(radians)
	local newX1 = x + (c+l) * math.cos(radians)
	local newY1 = y + (c+l) * math.sin(radians)

	screen.drawLine(newX, newY, newX1, newY1)
end
--@endsection
--@section __circleF__
function circleF(x, y, r, segments)
	local cos, sin = math.cos, math.sin
	local step = (math.pi * 2) / segments
	for i = 0, math.pi*2-step, step do
		screen.drawTriangleF(x, y, x+cos(i)*r, y+sin(i)*r, x+cos(i+step)*r, y+sin(i+step)*r)
	end		
end
--@endsection
--@section __Txt__
function Txt(a,b,c,d)mo={0}c=tostring(c)for e=1,#c do local f=c:sub(e,e):upper():byte()*3-95;if f>193 then f=f-78 end;f="0x"..string.sub("0000B0101F6F5FAB6DEDA010096690A4A4E4048444080168F9F8FABDDDB9F47DBBDDF3D1FDFF570500580A4AAA4A0391B96E5E6DF99669F9DF15FD96F4F9F978496F88FF3FF1F69625F79FA5FDDA1F1F8F787FCFB4B3C3BFD09F861F902128880219F60F06F9426",f,f+2)for g=0,11 do if f=='0x000'then mo[1]=mo[1]+d end;if f&(1<<g)>0 then local h=a+g//4+e*4-4;screen.drawRectF(h-mo[1],b+g%4,1,1)end end end end
--@endsection
--@section __smooth__
function smooth(x, id, level)
	for i = 1, 500 do
		if last ~= nil then
			if last[id] == nil then
				last[id] = {}
				if last[id][1] == nil then
					last[id][1] = 0
					break
				end
			end
		else
		last = {}
		end
	end
	local v1 = 100-level
	new = (last[id][1]/100*v1)+(x/100*level)
	last[id][1] = new
	return new
end
--@endsection
--@section __crossheir__
function crossheir()
	sw = screen.getWidth()
	sh = screen.getHeight()
	screen.setColor(255, 0, 0, 50)
	screen.drawLine(0, sh/2, sw, sh/2)
	screen.drawLine(sw/2, 0, sw/2, sh)
	screen.drawLine(0, 0, sw, sh)
	screen.drawLine(sw, 0, 0, sh)
end
--@endsection
--@section __isBox__
function isBox(x, y, w, h, cx, cy, cl)
	return (cx > x and cx < x+w) and (cy > y and cy < y+h) and cl
end
--@endsection
--@section __convTable__
function convTable(tbl)
    local str = '{'
    if type(tbl) == 'table' then
        for i, v in pairs(tbl) do
            if type(v) == 'table' then
                str = str .. convTable(v)..'}, '
            else
                str = string.sub(str, 0, #str-2)
                str = str .. tostring(i)..'='..tostring(v)..', '
            end
        end
    end
    str = string.sub(str, 0, #str-2)..'}'
    return str
end
--@endsection
--@section __Perlin__
perm = {}
permSize = 2^20
permTable = {}

function init()
    -- init  permutation table
    for i = 0, permSize - 1 do
        perm[i] = i
    end

    -- shuffle permutation table
    for i = permSize - 1, 0, -1 do
        local j = math.random(0, i)
        perm[i], perm[j] = perm[j], perm[i]
    end

    -- duplicate permutation table
    for i = 0, permSize - 1 do
        permTable[i] = perm[i]
        permTable[permSize + i] = perm[i]
    end
end

function fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function lerp(t, a, b)
    return a + t * (b - a)
end

function grad(hash, x)
    local h = hash % 16
    local grad = 1 + (h % 8)
    if (h < 8) then
        return ((h % 2 == 0) and grad or -grad) * x
    else
        return ((h % 2 == 0) and grad or -grad) * x
    end
end

function noise(x)
    local xi = math.floor(x) % permSize
    local xf = x - math.floor(x)
    local u = fade(xf)

    local aa = permTable[xi]
    local ab = permTable[(xi + 1) % permSize]

    return lerp(u, grad(aa, xf), grad(ab, xf - 1))
end

function perlin(x, minValue, maxValue)
    local total = 0
    local frequency = 4
    local amplitude = 12
    local persistence = 2
    local octaves = 4

    for i = 1, octaves do
        total = total + noise(x * frequency) * amplitude
        frequency = frequency * 2
        amplitude = amplitude / persistence
    end

    -- Normalize
    local minValue = -1
    local maxValue = 1
    total = (total - minValue) / (maxValue - minValue)

    return total
end

init()
--@endsection
--@section __button__
function button(x, y, w, h, cx, cy, cl, offC, onC, toggle, id, offT, onT, beta)
    if x == 'help' then
        print('X and Y are the coordinates for top left and top right.\nThe w and h are width and height going bottom right.\nCx, cy, cl are click x, click y, clicking of your cursor.\noffC and onC are a table for the off and on colours. {r, g, b}\nToggle is a boolean to make it toggle or not.\nId is the unique ID of said button (such that you dont toggle two at once with one drawn button\noffT and onT are the off and on texts to display.)')
    end
	if type(isBox) ~= 'function' then
		print([[ERROR: REQUIRED FUNCTION: "isBox" NOT FOUND!]])
	end
	if offT ~= nil and onT ~= nil then
		if type(Txt) ~= 'function' then
			print([[ERROR: REQUIRED FUNCTION: "Txt" NOT FOUND!]])
		end
	end
	if buttonHelper == nil then
		buttonHelper = {}
	end
	if buttonHelper[id] == nil then
		buttonHelper[id] = {false, false}
	end
	if offT == nil or onT == nil then
		if buttonHelper[id][1] then
			screen.setColor(onC[1], onC[2], onC[3])
			screen.drawRectF(x, y, w+1, h+1)
		else
			screen.setColor(offC[1], offC[2], offC[3])
			screen.drawRect(x, y, w, h)
		end
	else
	if buttonHelper[id][1] then
			screen.setColor(onC[1], onC[2], onC[3])
			screen.drawRectF(x, y, w, h)
			screen.setColor(offC[1], offC[2], offC[3])
			Txt(x+1, y+1, tostring(onT), .1)
		else
			screen.setColor(offC[1], offC[2], offC[3])
			screen.drawRect(x, y, w, h)
			screen.setColor(onC[1], onC[2], onC[3])
			Txt(x+1, y+1, tostring(offT), .1)
		end
	end
    cl = isBox(x, y, w, h, cx, cy, cl)
    if toggle then
        if cl ~= buttonHelper[id][2] and cl then
            buttonHelper[id][1] = not buttonHelper[id][1]
        end
    else
        buttonHelper[id][1] = cl
    end
    buttonHelper[id][2] = cl
end
--endsection
--@section __clear__
for i = 1, 50 do
    print('')
end
--endsection
