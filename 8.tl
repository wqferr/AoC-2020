local Set = require 'set'

local record State
    pc: number
    acc: number
end

local record Instruction
    code: string
    arg: number
end

local instruction_func: {string: function} = {
    acc = function(state: State, arg: number)
        state.acc = state.acc + arg
        state.pc = state.pc + 1
    end,
    jmp = function(state: State, arg: number)
        state.pc = state.pc + arg
    end,
    nop = function(state: State, arg: number)
        state.pc = state.pc + 1
    end
}

local instructions: {Instruction} = {}
for line in io.lines() do
    local instr_code, arg = line:match '(%a+) ([%+%-]%d+)'
    local arg = tonumber(arg)
    local instr: Instruction = {
        code = instr_code,
        arg = arg
    }
    table.insert(instructions, instr)
end

local reachable = Set.new()

local function compute(instructions: {Instruction}, state: State): boolean
    local visited_instr = Set.new()
    while 1 <= state.pc and state.pc <= #instructions do
        if visited_instr:contains(state.pc) then
            return false
        end
        visited_instr:add(state.pc)
        reachable:add(state.pc)
        local instr = instructions[state.pc]
        instruction_func[instr.code](state, instr.arg)
    end
    return state.pc == #instructions + 1
end

local state: State = {pc = 1, acc = 0}
assert(not compute(instructions, state))
print('PC', 'ACC')
print(state.pc, state.acc)

-- TODO change 1 jmp to nop or nop to jmp
local cf_meta = {
    __index = function(t: {any: table}, idx): table
        t[idx] = {}
        return t[idx]
    end
}
 
local goes_to: {number: number} = {}
local can_come_from: {number: {number}} = setmetatable({}, cf_meta)
local could_go_to: {number: number} = {}
local could_come_from: {number: {number}} = setmetatable({}, cf_meta)

for instr_n, instr in ipairs(instructions) do
    local next_instr_n, alt_next_instr_n: number, number
    if instr.code == 'jmp' then
        next_instr_n = instr_n + instr.arg
        alt_next_instr_n = instr_n + 1
    elseif instr.code == 'nop' then
        next_instr_n = instr_n + 1
        alt_next_instr_n = instr_n + instr.arg
    else
        next_instr_n = instr_n + 1
        alt_next_instr_n = nil
    end

    goes_to[instr_n] = next_instr_n
    table.insert(can_come_from[next_instr_n], instr_n)

    if alt_next_instr_n ~= nil then
        could_go_to[instr_n] = alt_next_instr_n
        table.insert(could_come_from[alt_next_instr_n], instr_n)
    end
end


print('--------')

local target = #instructions+1
local function find_all_halting_starting_instructions(instructions: {Instruction}): Set
    local open = Set.new()
    local closed = Set.new()

    open:add(target)
    while not open:empty() do
        local n = open:pop() as number
        closed:add(n)

        for _, comes_from in ipairs(can_come_from[n]) do
            if not closed:contains(comes_from) then
                open:add(comes_from)
            end
        end
    end

    return closed
end

local function fix(instructions: {Instruction})
    local s = find_all_halting_starting_instructions(instructions)
    for n in s:iter() do
        local n = n as number
        for _, switch_instr_n in ipairs(could_come_from[n]) do
            if reachable:contains(switch_instr_n) then
                local instr = instructions[switch_instr_n]
                if instr.code == 'jmp' then
                    instr.code = 'nop'
                else
                    instr.code = 'jmp'
                end
                return
            end
        end
    end
end

fix(instructions)

state.pc = 1
state.acc = 0
print('PC', 'ACC')
assert(compute(instructions, state))
print(state.pc, state.acc)
