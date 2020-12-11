local Graph = require 'graph'

local g = Graph.new {acyclic = true} as Graph<number>

local max_adapter = -math.huge
for line in io.lines() do
    local adapter = tonumber(line)
    g:add_vertex(adapter)
    if adapter > max_adapter then
        max_adapter = adapter
    end
end
local target_joltage = 3 + max_adapter
g:add_vertex(target_joltage)

for v in g:iter_vertices() do
    for _, d in ipairs {1, 2, 3} do
        if g:has_vertex(v + d) then
            g:add_edge(v, v + d)
        end
    end
end

-- NORMALLY a simple toposort wouldn't solve this
-- BUT since the input is guaranteed to have only 1 solution,
-- the only topologically sorted graph is ALSO the only
-- hamiltonian path, not just one of them
local sorted = g:toposort()
local diff_1 = 0
local diff_3 = 0
local prev = 0
for _, v in ipairs(sorted) do
    print(v)
    local d = v - prev
    if d == 1 then
        diff_1 = diff_1 + 1
    elseif d == 3 then
        diff_3 = diff_3 + 1
    end
    prev = v
end

print()
print(diff_1, diff_3, diff_1 * diff_3)

--

print()

local num_of_ways: {number: number} = {}
for _, v in ipairs {1, 2, 3} do
    num_of_ways[v] = 1
end
for _, v in ipairs(sorted) do
    num_of_ways[v] = num_of_ways[v] or 0
    for _, d in ipairs {1, 2, 3} do
        print(v, d, v-d)
        if g:has_vertex(v - d) then
            num_of_ways[v] = num_of_ways[v] + num_of_ways[v - d]
        end
    end
end

print(num_of_ways[target_joltage])
