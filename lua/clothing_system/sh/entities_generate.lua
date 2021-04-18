hook.Add('PreGamemodeLoaded', 'ClothingSystem.GenerateEntities', function()
   local clothing_list = list.Get( "clothing_system" )
   for class_name, v in pairs(clothing_list) do
      local ENT = {}
      ENT.Base = 'clothing_prop'
      ENT.PrintName = v.Name or class_name
      scripted_ents.Register(ENT, 'clothing_' .. class_name)
   end
end)