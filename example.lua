playersCount = 0
playersDb = dataBase.create("players", {
    ["id"] = "255", -- It's a VARCHAR(255) type with NILL default value
    ["staff"] = false, -- It's BOOLEAN with false default value (true define default value on true)
    ["age"] = 2, -- It's INT with 2 decimal maximum (99 max, if 4 it's 9999 max) with NULL default value
    ["inventory"] = {} -- it's a LONGTEXT type with NULL default value
}, "id")

playersDb:readAll(function(result) -- Lis toute la table
    for _, v in pairs(result) do
        usersCount = usersCount + 1
        if v.id then
            print(v.id)
        end
        if v.pseudo then
            print(v.pseudo)
        end
    end
    print("Handler has been correctly loaded with "..usersCount.." players loaded.")
end)
playersDb:read("id", "test", function(result) -- (callback, "collone", "valeur") Get une ligne de la table 
   print(json.encode(result))
end)
-- playersDb:truncate() -- Reset la table
-- playersDb:drop() -- Efface la table
playersDb:insert({ -- ({Donnée}, callback())insert des données dans la table !! Attention, reféret vous a la construction de votre table pour ne pas avoir d'erreur lors de l'insertion
    ["id"] = "test2",
    ["pseudo"] = "test Insert",
}, function()
    print("Callback Db:insert")
end)                            
playersDb:update("id", "test", { -- ("collone", "valeur", {données}, callback()) Modifie une ligne de la tables 
    ["pseudo"] = "Pseudo changer" -- Je peux changer une donnée comme plusieur suffit d'ajouter une ligne
    -- ["nomDeLaCollone"] = "IdModifier",
}, 
    print('test playerdb:update')
)
-- playerDb:delete("id", "test2") -- ("collone", "valeur") -- Supprime une ligne