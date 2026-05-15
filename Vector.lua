require "math"

Vector = {}
Vector.__index = Vector

Vector.__tostring = function (self)
    return self:tostring()
end

Vector.__add = function (self, other)
    local v = Vector:new(#self)
    for i=1, #self do
        v[i] = self[i] + other[i]
    end
    return v
end

Vector.__sub = function (self, other)
    local v = Vector:new(#self)
    for i=1, #self do
        v[i] = self[i] - other[i]
    end
    return v
end

Vector.__mul = function (self, c)
    local v = Vector:new(#self)
    for i=1, #self do
        v[i] = c * self[i]
    end
    return v
end

Vector.__div = function (self, d)
    return self * (1/d)
end

function Vector:new(size, val)
    local c = setmetatable({}, Vector)

    local val = val or 0
    for i=1,size do
        c[i] = val
    end
    return c
end

function Vector:from_table(table)
    if type(table) ~= "table" then
        error(string.format("Expected argument of type 'table', received '%s'", type(table)))
    end

    local v = Vector:new(#table)
    for i=1, #table do
        if type(table[i]) ~= "number" then
            error(string.format("Expected table with elements of 'number', received "))
        end
        v[i] = table[i]
    end
    return v
end

function Vector:tostring()
    local s = "("
    for i=1, #self-1 do
        s = s .. self[i] .. ", "
    end
    return s .. self[#self] .. ")"
end

function Vector:copy()
    local v = Vector:new(#self)
    for i=1, #self do
        v[i] = self[i]
    end
    return v
end

function Vector:dot(other)
    local d = 0
    for i=1, #self do
        d = d + self[i] * other[i]
    end
    return d
end

function Vector:mag()
    return math.sqrt(self:dot(self))
end

function Vector:norm()
    return self / self:mag()
end