local Set = require 'set'

local record Graph<T>
    vertices: {T: Vertex}
    acyclic: boolean

    n_vertices: number

    record Vertex
        id: T
        edges: {T: number}
    end
end
local GraphMt = {__index = Graph}

function Graph.new<T>(attributes: {string: any} | nil): Graph<T>
    if attributes is nil then
        attributes = {}
    end

    attributes = attributes as {string: any}
    local acyclic = attributes.acyclic as boolean
    local g =  {
        vertices = {},
        n_vertices = 0,
        acyclic = acyclic
    }
    setmetatable(g, GraphMt)
    return g
end

function Graph:add_vertex<T>(id: T)
    if self.vertices[id] then
        error(('Vertex with ID %s has already been defined'):format(id), 2)
    end

    self.vertices[id] = {
        id = id,
        edges = {}
    }
    self.n_vertices = self.n_vertices + 1
end

function Graph:has_vertex<T>(id: T): boolean
    return self.vertices[id] ~= nil
end

function Graph:iter_vertices<T>(): (function(): T)
    local cur: T = nil
    local function _iter(): T
        cur = next(self.vertices, cur)
        return cur
    end

    return _iter
end

local function _get_vertex_or_error<T>(g: Graph<T>, id: T): Graph.Vertex
    local v = g.vertices[id]
    if v then
        return v
    else
        error(('Unknown vertex: %s'):format(id), 3)
    end
end

local function _reconstruct_cycle_err_msg<T>(cycle_parent: {T: T}, cycle_start: T, cycle_end: T): string
    local msg = 'CYCLE DETECTED!\n'
    local curr_id: T = cycle_end
    repeat
        local parent = cycle_parent[curr_id]
        msg = msg..tostring(parent)..' -> '..tostring(curr_id)..'\n'
        curr_id = parent
    until curr_id == cycle_start
    msg = msg..tostring(cycle_end)..' -> '..tostring(cycle_start)

    return msg
end

local function _error_if_cycles<T>(g: Graph<T>, newly_added_edge_src: T, newly_added_edge_dest: T)
    -- start a BFS at newly_added_edge_dest, try to reach newly_added_edge_src
    local open = Set.new() as Set<T>
    local cycle_parent: {T: T} = {}

    open:add(newly_added_edge_dest)
    while not open:empty() do
        local v_id = open:pop()

        local v = g.vertices[v_id]
        for neighbor_id, _ in pairs(v.edges) do
            if not cycle_parent[neighbor_id] then
                cycle_parent[neighbor_id] = v_id
                open:add(neighbor_id)
            end

            if neighbor_id == newly_added_edge_src then
                local err_msg = _reconstruct_cycle_err_msg(
                    cycle_parent,
                    newly_added_edge_dest,
                    newly_added_edge_src
                )
                error(err_msg)
            end
        end
    end
end

function Graph:add_edge<T>(id_src: T, id_dest: T, weight: number | nil)
    if weight is nil then
        weight = 1
    end
    local src, dest = _get_vertex_or_error(self as Graph<T>, id_src), _get_vertex_or_error(self as Graph<T>, id_dest)
    if src.edges[id_dest] then
        error(('There is already an edge between %s and %s'):format(id_src, id_dest), 2)
    end

    src.edges[id_dest] = weight as number
    if self.acyclic then
        _error_if_cycles(self as Graph<T>, id_src, id_dest)
    end
end

function Graph:toposort<T>(): {T}
    if not self.acyclic then
        error('Cannot topologically sort non-acyclic graph', 2)
    end

    local incoming_edges: {T: number} = {}
    for v_id, _ in pairs(self.vertices) do
        incoming_edges[v_id] = 0
    end
    for v_id, v in pairs(self.vertices) do
        for n_id, _ in pairs(v.edges) do
            incoming_edges[n_id] = incoming_edges[n_id] + 1
        end
    end

    local included = Set.new() as Set<T>
    local sorted: {T} = {}

    while included:size() < self.n_vertices do
        local curr_layer = Set.new() as Set<T>
        for v_id, inc_edges in pairs(incoming_edges) do
            if inc_edges == 0 and not included:contains(v_id) then
                curr_layer:add(v_id)
            end
        end
        for v_id in curr_layer:iter() do
            table.insert(sorted, v_id)
            included:add(v_id)

            local v = self.vertices[v_id]
            for n_id, _ in pairs(v.edges) do
                incoming_edges[n_id] = incoming_edges[n_id] - 1
            end
        end
    end

    return sorted
end

return Graph
