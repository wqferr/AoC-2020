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

function Set:size(): number
    local size = 0
    for k, _ in pairs(self.values) do
        size = size + 1
    end
    return size
end

function line_to_set(line: string): Set
    local set = Set.new()
    for char in line:gmatch '.' do
        set:add(char)
    end
    return set
end

local type Group = {Set}

function get_group_distinct_count(group: Group): number
    local set = Set.new()
    for _, answers in ipairs(group) do
        set = set:union(answers)
    end
    return set:size()
end

function get_group_common_count(group: Group): number
    local set = group[1]
    for i = 2, #group do
        set = set:intersection(group[i])
    end
    return set:size()
end

function read_group(): Group, boolean
    local done = false
    local group: Group = {}

    while true do
        local line = io.read()
        if line == nil then
            return group, true
        elseif line == '' then
            return group, false
        else
            table.insert(group, line_to_set(line))
        end
    end
end

function main()
    local done = false
    local total_count = 0
    repeat
        local group, done = read_group()
        -- total_count = total_count + get_group_distinct_count(group) 
        total_count = total_count + get_group_common_count(group) 
    until done
    print(total_count)
end

main()
