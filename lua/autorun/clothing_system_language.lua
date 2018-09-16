AddCSLuaFile()

ClothingSystem = ClothingSystem || {}
ClothingSystem.Language = {}

local eng_pack = {}
eng_pack.initial = "The clothing system is loaded"
eng_pack.equip = "Equipped clothing"
eng_pack.noFreeSlot = "There is not enough space for this"
eng_pack.badArray = "Warning: Bad array clothing system"
eng_pack.unsuitableClothes = "These clothes do not suit you"
eng_pack.unsuitableClothesRank = "Your rank does not allow you to equip this item"
eng_pack.adminOnly = "This clothing is for admin only"
eng_pack.noFreeBonesFound = "WARNING: No bone was found for attachment"
eng_pack.spawnMenuCopy = "Copy to Clipboard"

eng_pack.vguiInDevelopment = "Function in development"

eng_pack.vguiMenu_Storage_EntityDestroyed = "This object was destroyed or picked up by another player"
eng_pack.vguiMenu_Storage_noFreeSlot = "There is not enough room in the pocket"
eng_pack.vguiMenu_Storage_PocketsName = "Pockets"
eng_pack.vguiMenu_Storage_ItemUse = "Use"
eng_pack.vguiMenu_Storage_List = "Storage"
eng_pack.vguiMenu_Storage_List_Object = "Object"
eng_pack.vguiMenu_Storage_List_Weight = "Weight"
eng_pack.vguiMenu_Storage_List_Class = "Class"
eng_pack.vguiMenu_Storage_List_Type = "Type"
eng_pack.vguiMenu_Storage_Clothing = "Clothing"
eng_pack.vguiMenu_Storage_noClothes = "You do not have any clothing"
eng_pack.vguiMenu_Storage_notPickUp = "You can not pick up this object"

eng_pack.vguiMenu_2_Title = "Actions"
eng_pack.vguiMenu_2_Drop = "Drop"
eng_pack.vguiMenu_2_Inventory = "View inventory"
eng_pack.vguiMenu_2_Worn = "Worn of clothes"

eng_pack.vguiMenu_1_Title = "Your clothes"
eng_pack.vguiMenu_1_Class = "Class"
eng_pack.vguiMenu_1_Name = "Name"

local rus_pack = {}
rus_pack.initial = "Система одежды загружена"
rus_pack.equip = "Одето"
rus_pack.noFreeSlot = "Недостаточно места для этой вещи"
rus_pack.badArray = "Ошибка: неправильный массив для системы одежды"
rus_pack.unsuitableClothes = "Эта одежда вам не подходит"
rus_pack.unsuitableClothesRank = "Ваш ранг не позволяет вам экипировать эту вещь"
rus_pack.adminOnly = "Эта одежда предназначена только для администратора"
rus_pack.noFreeBonesFound = "Предупреждение: не найдено подходящих костей для крепления"
rus_pack.spawnMenuCopy = "Скопировать в буфер обмена"

rus_pack.vguiInDevelopment = "Функция в разработке"

rus_pack.vguiMenu_Storage_EntityDestroyed = "Этот объект был уничтожен или поднят другим игроком"
rus_pack.vguiMenu_Storage_noFreeSlot = "В кармане не хватает места"
rus_pack.vguiMenu_Storage_PocketsName = "Карманы"
rus_pack.vguiMenu_Storage_ItemUse = "Использовать"
rus_pack.vguiMenu_Storage_List = "Хранилище"
rus_pack.vguiMenu_Storage_List_Object = "Объект"
rus_pack.vguiMenu_Storage_List_Weight = "Вес"
rus_pack.vguiMenu_Storage_List_Class = "Класс"
rus_pack.vguiMenu_Storage_List_Type = "Тип"
rus_pack.vguiMenu_Storage_Clothing = "Одежда"
rus_pack.vguiMenu_Storage_noClothes = "У вас нет одежды"
rus_pack.vguiMenu_Storage_notPickUp = "Вы не можете подобрать этот объект"

rus_pack.vguiMenu_2_Title = "Действия"
rus_pack.vguiMenu_2_Drop = "Выбросить"
rus_pack.vguiMenu_2_Inventory = "Посмотреть инвентарь"
rus_pack.vguiMenu_2_Worn = "Износ одежды"

rus_pack.vguiMenu_1_Title = "Ваша одежда"
rus_pack.vguiMenu_1_Class = "Класс"
rus_pack.vguiMenu_1_Name = "Название"

-- Setup language pack
ClothingSystem.Language = eng_pack