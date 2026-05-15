require "Vector"

Matrix = {}
Matrix.__index = Matrix

Matrix.__tostring = function (self)
    return self:to_string()
end

function Matrix:new(rows, cols, val)
    local c = setmetatable({}, Matrix)

    local val = val or 0
    for i=1, rows do
        c[i] = {}
        for j=1, cols do
            c[i][j] = val
        end
    end
    return c
end

function Matrix:to_string()
    local s = ""
    for i=1, #self do
        s = s .. "| "
        for j=1, #self[1] do
            s = s .. self[i][j] .. " "
        end
        s = s .. "\n"
    end
    return s
end

function Matrix:ident(size)
    local c = Matrix:new(size, size)
    for i=1, size do
        c[i][i] = 1
    end
    return c
end

function Matrix:_size_str()
    return string.format("(%d, %d)", #self, #self[1])
end

function Matrix:get_column(i)
    local s = #(self[i])
    local c = Vector:new(s)

    for j=1, s do
        c[j] = self[j][i]
    end
    return c
end

function Matrix:get(i, j)
    if self[i] and self[i][j] then
        return self[i][j]
    end
    error(string.format("Invalid get() at (%d, %d) for matrix of size %s", i, j, self:size_str()))
end

function Matrix:set(i, j, val)
    if self[i] and self[i][j] then
        self[i][j] = val
    end
    error(string.format("Invalid set() at (%d, %d) for matrix of size %s", i, j, self:_size_str()))
end

function Matrix:copy()
    local m = Matrix:new(#self, #self[1])
    for i=1, #self do
        for j=1, #self[1] do
            m[i][j] = self[i][j]
        end
    end
    return m
end

function Matrix:mul(other)
    if #self[1] ~= #other then
        error(string.format("Invalid matrix multiplication between sizes %s and %s", self:_size_str(), other:_size_str()))
    end

    local m = Matrix:new(#other[1], #self)
    for i=1, #self do
        for j=1, #other[1] do
            local s = self[i][1] * other[1][j]
            for k=2, #other do
                s = s + self[i][k] * other[k][j]
            end
            m[i][j] = s
        end
    end
    return m
end

function Matrix:mul_vec(v)
    if #self[1] ~= #v then
        error(string.format("Invalid matrix multiplication of vector between sizes %s and %d", self:_size_str(), #v))
    end

    local rv = Vector:new(#self)
    for i=1, #rv do
        rv[i] = v:dot(self[i])
    end
    return rv
end

function Matrix:from_table(table)
    if type(table) ~= "table" or type(table[1]) ~= "table" then
        error("Input must be a table of tables of numbers")
    end

    local m = Matrix:new(#table, #table[1])
    for i=1, #table do
        for j=1, #table[1] do
            if type(table[i][j]) ~= "number" then
                error("Elements of table must be numbers")
            end
            m[i][j] = table[i][j]
        end
    end
    return m
end