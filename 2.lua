valid_pw_count = 0
for line in io.lines("2.input") do
    local range_min, range_max, char, password = line:match "(%d+)%-(%d+) (%a): (%a+)"
    range_min = tonumber(range_min)
    range_max = tonumber(range_max)
    local _, count = password:gsub(char, char)
    if range_min <= count and count <= range_max then
        valid_pw_count = valid_pw_count + 1
    end
end
print(valid_pw_count)

-- %%

-- second half
valid_pw_count = 0
for line in io.lines("2.input") do
    local pos1, pos2, char, password = line:match "(%d+)%-(%d+) (%a): (%a+)"
    pos1, pos2 = tonumber(pos1), tonumber(pos2)
    local char1 = password:sub(pos1, pos1)
    local char2 = password:sub(pos2, pos2)
    if (char1 == char) ~= (char2 == char) then
        valid_pw_count = valid_pw_count + 1
    end
end
print(valid_pw_count)
