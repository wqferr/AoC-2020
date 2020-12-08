local Set = require 'set'

local record Bag
    color: string
    has_children: boolean
    children: {string: number}
end

local function consume(str: string, pattern: string): string...
    pattern = '^('..pattern..')'
    local captures = {str:match(pattern)}
    if not captures[1] then
        return str
    end
    local remaining_start = #captures[1] + 1
    local remaining = str:sub(remaining_start)

    return remaining, select(2, table.unpack(captures))
end

local bag_name_pattern = '(%a+ %a+) bags?'
local function bag_from_line(line: string): Bag
    local line, color = consume(line, bag_name_pattern)
    local line = consume(line, ' contain ')
    local children: {string: number} = {}
    local has_children = false
    while true do
        local n, child: string, string
        line, n, child = consume(line, '(%d+) '..bag_name_pattern..'[,. ]*')
        if child == nil then
            break
        else
            has_children = true
            children[child] = tonumber(n)
            assert(children[child], 'child '..child..' has nil count')
        end
    end
    return {
        color = color,
        children = children,
        has_children = has_children
    } as Bag
end

local function can_be_inside(bags: {string: Bag}, larger_color: string, smaller_color: string): boolean
    local open = Set.new()
    local closed = Set.new()

    open:add(larger_color)
    while not open:empty() do
        local color = open:pop()
        closed:add(color)

        local bag = bags[color]
        for child_color, _ in pairs(bag.children) do
            if child_color == smaller_color then
                return true
            end
            if not closed:contains(child_color) then
                open:add(child_color)
            end
        end
    end
    return false
end

local bags: {string: Bag} = {}

for line in io.lines() do
    local b = bag_from_line(line)
    bags[b.color] = b
end

for color, bag in pairs(bags) do
    print(color)
    for child, count in pairs(bag.children) do
        print(child, count)
    end
    print()
end

local count = 0
for color, _ in pairs(bags) do
    if can_be_inside(bags, color, 'shiny gold') then
        count = count + 1
    end
end
print(count, 'different bags can contain shiny gold ones')

-- %

local function count_subbags(bags: {string: Bag}, color: string): number
    local count = 0
    local bag = bags[color]
    for child_color, child_count in pairs(bag.children) do
        count = count + child_count * (1+count_subbags(bags, child_color))
    end
    return count
end

print(count_subbags(bags, 'shiny gold'))
