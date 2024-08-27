# oxCollector

A oxMySql overlay for easier database handling

## Links
- [Dependencie](https://github.com/overextended/oxmysql/releases/latest/download/oxmysql.zip)
  - oxMySql

## Features

- Create, update, fetch and all MySql can do easier.

## How to start

- replace in your ```fxmanifest.lua```  ``'@oxmysql/lib/MySQL.lua'`` by ``'@oxCollector/collector.lua``
- ``ensure oxCollector`` after oxMySql in your ``server.cfg``

## How to use

- Create new table
    ```lua
    -- playersDb = collector.create(table, collumns, primary)
    playersDb = collector.create("players" -- Name of table must be string
        {   -- We create collumns and we define type
            ["id"] = "255", -- It's a VARCHAR(255) type with NILL default value
            ["staff"] = false, -- It's BOOLEAN with false default value (true define default value on true)
            ["age"] = 2, -- It's INT with 2 decimal maximum (99 max, if 4 it's 9999 max) with NULL default value
            ["inventory"] = {} -- it's a LONGTEXT type with NULL default value
        }
    , "id") -- We define primary key (Optional)
    ```
- Insert in table
    ```lua
      -- playersDb:insert(table, callback)
      playersDb:insert({ -- We will define what we want insert in table
          ["id"] = "id number 1",
          ["staff"] = true,
          ["age"] = 23,
          ["inventory"] = {
              "Banana", "Apple", "Bread"
          }
      }, function()
          print("Callback after insert in "..self.table)
      end)
      playersDb:insert({ -- All data are optional, we can insert what we want if primary key are not already taken in table
          ["id"] = "id number 2",
          ["age"] = 73,
      }, function()
          print("Callback after insert in "..self.table)
      end)
    ```
- Delete in table
    ```lua
    -- playersDb:delete(where, whereValue) where = collumns target, whereValue = value to target in collumns
    playersDb:delete("id", "id number 1")
    ```
- Updating table
    ```lua
    -- playersDb:update(where, whereValue, data, cb) where = collumns target, whereValue = value to target in collumns, data = table contain new data, callback was optional. We can update data by data or all data in one time, juste make you sure the array index is the same in your MySql
    playersDb:update("id", Id number 1, { 
      ["id"] = "Id changed",
      ["age"] = 3,
    }, 
    print('playersDb:update callback')
    )
    ```
- Reading table
    ```lua
    -- playersDb:readAll(cb) -- cb return array of all table
    playersDb:readAll( function(result)
        for k, v in pairs (result) do
            -- Do somethint woth result
            print(v.id, v.age)
        end
    end)
    ```
- Reading into table
    ```lua
    -- playersDb:read(where, whereValue, cb) where = collumns target, whereValue = value to target in collumns, cb return arrya contain all whereValue data
    playersDb:read("id", "Id number 1", function(result)
        print(json.encode(result))
    end)
    ```
- Reset table
    ```lua
    playersDb:truncate()
    ```
- Delete table
    ```lua
    playersDb:drop()
    ```
