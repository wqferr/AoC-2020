-- %%

function partition_to_number(partition, upper_half_indicator)
    local n = 0
    for char in partition:gmatch(".") do
        local curr_half
        if char == upper_half_indicator then
            curr_half = 1
        else
            curr_half = 0
        end

        n = (n << 1) + curr_half
    end
    return n
end

-- %%

do
    local test = "FBFBBFFRLR"

    local row = partition_to_number(test:sub(1, 7), "B")
    local col = partition_to_number(test:sub(8), "R")
    print(row, col)
end

-- %%

function pass_to_rc(pass)
    row = partition_to_number(pass:sub(1, 7), "B")
    col = partition_to_number(pass:sub(8), 'R')
    return row, col
end

function rc_to_id(row, col)
    return row * 8 + col
end

-- %%

largest_id = -1
existing_ids = {}
for pass in io.lines("5.input") do
    local row, col = pass_to_rc(pass)
    local id = rc_to_id(row, col)
    existing_ids[id] = true
    if id > largest_id then
        largest_id = id
    end
end
print(largest_id)

-- %%

for i = 1, largest_id do
    if not existing_ids[i] then
        -- missing id
        if existing_ids[i-1] and existing_ids[i+1] then
            print('Found it!')
            print(('My seat is %d'):format(i))
            break
        end
    end
end
