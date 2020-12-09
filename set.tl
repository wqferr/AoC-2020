local record Set
    values: {any: boolean}

    new: function(elements: {any}): Set
    add: function(Set, any)
    contains: function(Set, any): boolean
    union: function(Set, Set): Set
    intersection: function(Set, Set): Set
    size: function(Set): number
end
local SetMt = {__index = Set}

function Set.new(): Set
    local s: Set = setmetatable({}, SetMt)
    s.values = {}
    return s
end

function Set:add(e: any)
    self.values[e] = true
end

function Set:contains(e: any): boolean
    return self.values[e]
end

function Set:union(other: Set): Set
    local new = Set.new()
    for e, _ in pairs(self.values) do
        new:add(e)
    end
    for e, _ in pairs(other.values) do
        new:add(e)
    end
    return new
end

function Set:intersection(other: Set): Set
    local new = Set.new()
    for e, _ in pairs(self.values) do
        if other:contains(e) then
            new:add(e)
        end
    end
    return new
end

function Set:pop(): any
    for k, v in pairs(self.values) do
        if v then
            self.values[k] = nil
            return k
        end
    end
    error('No element to pop', 2)
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

function Set:iter(): function(), nil, nil
    local curr_key: any = nil
    local function _iter(): any
        curr_key = next(self.values, curr_key)
        return curr_key
    end

    return _iter, nil, nil
end

return Set
