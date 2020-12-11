local Graph = require 'graph'

local g = Graph.new {acyclic = true} as Graph<number>

for _, i in ipairs {5, 7, 3, 11, 8, 2, 9, 10} do
    g:add_vertex(i)
end

g:add_edge(11, 10)
g:add_edge(3, 10)
g:add_edge(5, 11)
g:add_edge(7, 8)
g:add_edge(7, 11)
g:add_edge(11, 2)
g:add_edge(3, 8)
g:add_edge(8, 9)
g:add_edge(11, 9)


local sorted = g:toposort()
for _, v in ipairs(sorted) do
    print(v)
end
