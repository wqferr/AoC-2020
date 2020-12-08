local record Set
    values: {string: boolean}

    new: function(elements: {string}): Set
    add: function(Set, string)
    contains: function(Set, string): boolean
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

function Set:add(e: string)
    self.values[e] = true
end

function Set:contains(e: string): boolean
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

function Set:pop(): string
    for k, v in pairs(self.values) do
        if v then
            self.values[k] = false
            return k
        end
    end
    error('No element to pop', 2)
end

function Set:size(): number
    local size = 0
    for k, v in pairs(self.values) do
        if v then
            size = size + 1
        end
    end
    return size
end

function Set:empty(): boolean
    for k, v in pairs(self.values) do
        if v then
            return false
        end
    end
    return true
end

return Set
