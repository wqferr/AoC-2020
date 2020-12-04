-- %%
reqFields = {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}

function checkRecordHasFields(rec)
    for _, field in ipairs(reqFields) do
        if rec[field] == nil then
            return false
        end
    end
    return true
end

function yearInRange(year, min, max)
    year = tonumber(year)
    if year then
        return min <= year and year <= max
    else
        return false
    end
end

function validHeight(height)
    local m_cm = height:match "^(%d+)cm$"
    if m_cm then
        local h = tonumber(m_cm)
        return h and 150 <= h and h <= 193
    end

    local m_in = height:match "^(%d+)in$"
    if m_in then
        local h = tonumber(m_in)
        return h and 59 <= h and h <= 76
    end

    return false
end

function validHexColor(clr)
    return #clr == 7 and clr:match "^#[0-9a-f]+$"
end

validColors = {
    amb = true,
    blu = true,
    brn = true,
    gry = true,
    grn = true,
    hzl = true,
    oth = true
}
function validColorName(clr)
    return validColors[clr]
end

function validPassportId(pid)
    return #pid == 9 and pid:match "%d+"
end

function checkRecordIsValid(rec)
    if not checkRecordHasFields(rec) then
        return false
    end

    -- Start of first part
    if not yearInRange(rec.byr, 1920, 2002) then
        return false
    elseif not yearInRange(rec.iyr, 2010, 2020) then
        return false
    elseif not yearInRange(rec.eyr, 2020, 2030) then
        return false
    elseif not validHeight(rec.hgt) then
        return false
    elseif not validHexColor(rec.hcl) then
        return false
    elseif not validColorName(rec.ecl) then
        return false
    elseif not validPassportId(rec.pid) then
        return false
    end
    -- End of second part

    return true
end
-- %%

currentRec = {}
validCount = 0
for line in io.lines("4.input") do
    if line == "" then
        if checkRecordIsValid(currentRec) then
            validCount = validCount + 1
        end
        currentRec = {}
    else
        for k, v in (line):gmatch "(%w+):(%S+)" do
            currentRec[k] = v
        end
    end
end
if checkRecordIsValid(currentRec) then
    validCount = validCount + 1
end
print(validCount)

-- %%
