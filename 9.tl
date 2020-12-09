local List = require 'list'
local Set = require 'set'
local arg = (...)
local preamble_size = assert(
    tonumber(arg),
    'no preamble size given'
)

local numbers: {number} = {}
local recent_numbers = Set.new() as Set<number>
local function add_number(n: number)
    table.insert(numbers, n)
    recent_numbers:add(n)
    if #numbers > preamble_size then
        local oldest = numbers[#numbers - preamble_size]
        recent_numbers:remove(oldest)
    end
end

local function check_number(n: number): boolean
    if #numbers < preamble_size then
        return true
    end

    for recent_n in recent_numbers:iter() do
        if recent_numbers:contains(n - recent_n) then
            return true
        end
    end
    return false
end

local weakness_idx: number | nil
for line in io.lines() do
    local new_number = assert(tonumber(line))
    if weakness_idx is nil and not check_number(new_number) then
        weakness_idx = #numbers+1
    end
    add_number(new_number)
end
assert(weakness_idx is number)
weakness_idx = weakness_idx as number
print('weakness:', numbers[weakness_idx])


local function find_subseq(target_idx: number): (number, number)
    local _subsum_row_mt = {
        __ipairs = function() error('NO IPAIRS!') end
    }
    local subsums = setmetatable(
        {} as {any: {number}},
        {
            __index = function(t: {any: table}, k): table
                t[k] = setmetatable({}, _subsum_row_mt as METATABLE)
                return t[k]
            end
        }
    )

    local target = numbers[target_idx]
    for a = 1, target_idx do
        subsums[a][a] = numbers[a]
        if subsums[a][a] == target then
            return a, a
        end

        for b = a+1, target_idx do
            subsums[a][b] = subsums[a][b-1] + numbers[b]
            if subsums[a][b] == target then
                return a, b
            end
        end
    end
    return nil, nil
end

local subseq_start, subseq_end = find_subseq(weakness_idx)
local s = 0
local min, max = math.huge, -math.huge
for i = subseq_start, subseq_end do
    if numbers[i] < min then
        min = numbers[i]
    end
    if numbers[i] > max then
        max = numbers[i]
    end
end

print('====')
print(min + max)
