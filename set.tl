local record Set<T>
    values: {T: boolean}
end
local SetMt = {__index = Set}

function Set.new<T>(): Set<T>
    local s: Set<T> = setmetatable({}, SetMt)
    s.values = {}
    return s
end

function Set:add<T>(e: T)
    self.values[e] = true
end

function Set:remove<T>(e: T)
    self.values[e] = nil
end

function Set:contains<T>(e: T): boolean
    return self.values[e]
end

function Set:union<T>(other: Set<T>): Set<T>
    local new = Set.new()
    for e, _ in pairs(self.values) do
        new:add(e)
    end
    for e, _ in pairs(other.values) do
        new:add(e)
    end
    return new
end

function Set:intersection<T>(other: Set<T>): Set<T>
    local new = Set.new()
    for e, _ in pairs(self.values) do
        if other:contains(e) then
            new:add(e)
        end
    end
    return new
end

function Set:pop<T>(): T
    for k, v in pairs(self.values) do
        if v then
            self.values[k] = nil
            return k
        end
    end
    return nil
end

function Set:size(): number
    local size = 0
    for k, v in pairs(self.values) do
        size = size + 1
    end
    return size
end

function Set:empty(): boolean
    return next(self.values) == nil
end

function Set:iter<T>(): (function(): T)
    local curr_key: T = nil
    local function _iter(): T
        curr_key = next(self.values, curr_key)
        return curr_key
    end

    return _iter
end

return Set
