ClothingSystem.Tools.Network.AddNetwork("ItemFolderDrawToText", function(len, data)
    local ent = ents.GetByIndex(data.index)
    ent.Class = data.class
end)