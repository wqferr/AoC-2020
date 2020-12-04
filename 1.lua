function read_numbers(filename)
    local num_set = {}
    for line in io.lines(filename) do
        local n = tonumber(line)
        num_set[n] = true
    end
    return num_set
end

num_set = read_numbers("1.input")

-- %%

for n, _ in pairs(num_set) do
    local complement = 2020 - n
    if num_set[complement] then
        print("Found pair!")
        print(("The numbers are %d and %d"):format(n, complement))
        print(("Their product is %d"):format(n * complement))
        break
    end
end

-- %%

for i, _ in pairs(num_set) do
    for j, _ in pairs(num_set) do
        local complement = 2020 - i - j
        if i ~= j and num_set[complement] then
            print("Found triplet!!")
            print(("The numbers are %d, %d and %d"):format(i, j, complement))
            print(("Their product is %d"):format(i * j * complement))
            return
        end
    end
end
