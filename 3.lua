tree_count = 0
col = 1
for line in io.lines("3.input") do
    if line:sub(col, col) == "#" then
        tree_count = tree_count + 1
    end
    col = col + 3
    if col > #line then
        col = col - #line
    end
end
print(tree_count)
-- %%

grid = {}

for line in io.lines("3.input") do
-- for line in io.lines("3.example.input") do
    table.insert(grid, line)
end

-- %%

function get_count(grid, col_inc, row_inc)
    local tree_count = 0
    local col = 1
    for row = 1, #grid, row_inc do
        if grid[row]:sub(col, col) == "#" then
            tree_count = tree_count + 1
        end
        col = col + col_inc
        if col > #grid[row] then
            col = col - #grid[row]
        end
    end

    return tree_count
end

-- %%

angles = {
    -- {right, down}
    {1, 1},
    {3, 1},
    {5, 1},
    {7, 1},
    {1, 2}
}
total_prod = 1
for _, angle in ipairs(angles) do
    total_prod = total_prod * get_count(grid, angle[1], angle[2])
end

total_prod
