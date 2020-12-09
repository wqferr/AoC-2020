local record Node<T>
    next_node: Node<T>
    prev_node: Node<T>
    value: T
end

local record List<T>
    head: Node<T>
    size: number
end
local ListMt = {__index = List}

local function _create_node_between<T>(a: Node<T>, b: Node<T>, value: T)
    local n = {} as Node<T>
    n.value = value

    n.prev_node = a
    a.next_node = n

    n.next_node = b
    b.prev_node = n
end

local function _remove_node<T>(n: Node<T>): T
    n.prev_node.next_node = n.next_node
    n.next_node.prev_node = n.prev_node

    n.next_node = nil
    n.prev_node = nil
    return n.value
end

function List.new<T>(): List<T>
    local l: List<T> = setmetatable({}, ListMt)

    l.head = {} as Node<T>
    l.head.next_node = l.head
    l.head.prev_node = l.head
    l.head.value = nil
    l.size = 0

    return l
end

function List:push_back<T>(e: T)
    _create_node_between(self.head.prev_node, self.head, e)
    self.size = self.size + 1
end

function List:push_front<T>(e: T)
    _create_node_between(self.head, self.head.next_node, e)
    self.size = self.size + 1
end

function List:pop_back<T>(): T
    local v = _remove_node(self.head.prev_node) 
    self.size = self.size - 1
    return v
end

function List:pop_front<T>(): T
    local v = _remove_node(self.head.next_node)
    self.size = self.size - 1
    return v
end

function List:peek_back<T>(): T
    return self.head.prev_node.value
end

function List:peek_front<T>(): T
    return self.head.next_node.value
end

function List:empty(): boolean
    return self.size == 0
end

function List:iter<T>(): (function(): T)
    local cur_node = self.head
    local function _iter(): T
        cur_node = cur_node.next_node
        return cur_node.value
    end
    return _iter
end

function List:riter<T>(): (function(): T)
    local cur_node = self.head
    local function _iter(): T
        cur_node = cur_node.prev_node
        return cur_node.value
    end
    return _iter
end

return List
