collector = {}
collector.__index = collector

function collector.create(table, collumns, primary)
    local self = {}
    local canExec = false

    self.table = table
    local str = "CREATE TABLE IF NOT EXISTS %s (%s)"
    local types = {
        ["string"] = "VARCHAR(%s) NULL",
        ["number"] = "INT(%s) NULL",
        ["boolean"] = "TINYINT(1) NOT NULL DEFAULT %s",
        ["table"] = "LONGTEXT DEFAULT NULL",
    }
    local bool = {
        [true] = 1,
        [false] = 0,
    }
    self.primary = primary or nil
    if collumns and type(collumns) == "table" then
        local values = "%s, "
        local newStr = ""
        for _, v in pairs(collumns) do
            if type(v) == "boolean" then
                v = bool[v]
            end
            newStr = newStr .. _.." "..string.format(values, string.format(types[type(v)], v))
        end
        local toExec = string.format(str, self.table, newStr)
        local start, finish = string.find(toExec, ", )")
        toExec = string.sub(toExec, 1, start-1) .. ")"
        MySQL.rawExecute(toExec, {}, function()
            print(self.table.." table has been initialized.")
        end)
    else
        print(self.table.." table don't have collumns.")
    end
    return setmetatable(self, collector)
end

function collector:readAll(cb)
    Citizen.CreateThread( function()

        local data = nil

        local toExec = string.format("SELECT * FROM %s", self.table)
        MySQL.query(toExec, {}, function(result)
            if result then
                data = result
            else
                data = {}
            end
        end)
        while data == nil do
            Wait(0)
        end
        cb(data)
    end)
end

function collector:read(where, whereValue, cb)
    Citizen.CreateThread( function()
        local data = nil
        if where and whereValue then
            local toExec = string.format("SELECT * FROM %s WHERE %s=@%s", self.table, where, where)
            MySQL.query(toExec, {
                ["@"..where] = whereValue
            }, function(result)
                if result then
                    data = result
                else
                    data = {}
                end
            end)
            while data == nil do
                Wait(0)
            end
            cb(data)
        else
            print("Args where or whereValue are missing for read ".. self.table..".")
        end
    end)
end

function collector:truncate()
    Citizen.CreateThread( function()
        local toExec = string.format("TRUNCATE TABLE %s", self.table) 
        MySQL.rawExecute(toExec, {}, function()
            print(self.table.." table has been truncated.")
        end)
    end)
end

function collector:drop()
    Citizen.CreateThread( function()
        local toExec = string.format("DROP TABLE IF EXISTS %s", self.table)
        MySQL.rawExecute(toExec, {}, function()
            print(self.table.." table has been dropped.")
        end)
    end)
end

function collector:insert(data, cb)
    Citizen.CreateThread( function()
        local toExec = "INSERT INTO "..self.table.." (%s) VALUES (%s)"
        local toInsert = {}
        local values = "%s, "
        local valuez = "%s = %s, "
        local collumnsName = ""
        local valuesName = ""
        local valueRes = ""
        local firstData = nil
        for _,v in pairs (data) do
            toInsert["@".._] = v
            collumnsName = collumnsName .. string.format(values, _)
            valuesName = valuesName .. string.format(values, "@".._)
            valueRes = valueRes .. string.format(valuez, _, v)
        end
        collumnsName = collumnsName..")"
        local start, finish = string.find(collumnsName, ", )")
        collumnsName = string.sub(collumnsName, 1, start-1)
        valuesName = valuesName..")"
        local start, finish = string.find(valuesName, ", )")
        valuesName = string.sub(valuesName, 1, start-1)
        toExec = string.format(toExec, collumnsName, valuesName)
        if self.primary then
            self:read(function(result)
                if result[1] then
                    if not result[1][self.primary] then
                        MySQL.insert(toExec, toInsert, function()
                            if cb then
                                cb()
                            end
                        end)
                    else
                        print("Data already exist for "..self.primary.."in "..self.table)
                    end
                else
                    MySQL.insert(toExec, toInsert, function()
                        if cb then
                            cb()
                        end
                    end)
                end
            end, self.primary, toInsert["@"..self.primary])
        else
            MySQL.insert(toExec, toInsert, function()
                if cb then
                    cb()
                end
            end)
        end
    end)
end

function collector:update(where, whereValue, data, cb)
    Citizen.CreateThread( function()
        if where and whereValue then
            local toExec = "UPDATE "..self.table.." SET %s WHERE "..where.."=@"..where
            local values = "%s = @%s, "
            local valuez = "%s = %s, "
            local collumnsName = ""
            local valueRes = ""
            local toInsert = {}
            for _,v in pairs (data) do
                toInsert["@".._] = v
                collumnsName = collumnsName .. string.format(values, _, _)
                valueRes = valueRes .. string.format(valuez, _, v)
            end
            toInsert['@'..where] = whereValue
            collumnsName = collumnsName..")"
            local start, finish = string.find(collumnsName, ", )")
            collumnsName = string.sub(collumnsName, 1, start-1)
            toExec = string.format(toExec, collumnsName)
            MySQL.rawExecute(toExec, toInsert, function()
                if cb then
                    cb()
                end
            end)
        else
            print("Args where or whereValue are missing for update ".. self.table..".")
        end
    end)
end

function collector:delete(where, whereValue)
    Citizen.CreateThread( function()
        if where and whereValue then
            local toExec = string.format("DELETE FROM %s WHERE %s=@%s", self.table, where, where)
            MySQL.rawExecute(toExec,
            {
                ['@'..where] = whereValue
            }, function()
                print(whereValue.." has been deleted.")
            end)
        else
            print("Args where or whereValue are missing for delete value in ".. self.table..".")
        end
    end)
end