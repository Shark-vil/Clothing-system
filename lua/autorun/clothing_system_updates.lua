ClothingSystem = ClothingSystem || {}

ClothingSystem.AddonVersion = "0.3"

local TEXT = [[
GitHub commits = https://github.com/Shark-vil/Clothing-system/commits/master <br>
__________________________ <br>
Update: <br>
1 - Fixed an issue where the player could not change the model when equipping clothes. <br>
Details: in the addon "Enhanced PlayerModel Selector" was cvar (sv_playermodel_selector_force), which interfered with the normal change of the model, <br>
about the same as cvar in PAC3 (pac_modifier_model) <br>
2 - Fixed chat-command: /itemdrop <br>
<br>
Next updates: <br>
1 - Update reference materials <br>
2 - Create the English version of the wiki <br>
3 - Add more items <br>
4 - Add more hooks for interaction <br>
5 - Change the addition system of weapons and entities to inventory <br>
6 - Add Mechanics for Roleplaying <br>
7 - Add clothes for NPC <br>
]]

if ( GetConVar("clothing_system_language"):GetString() == "ru" ) then
TEXT = [[
GitHub commits = https://github.com/Shark-vil/Clothing-system/commits/master <br>
__________________________ <br>
Обновление: <br>
1 - Исправлена проблема, когда игрок не мог изменить модель при экипировке одежды. <br>
Подробнее: в аддоне "Enhanced PlayerModel Selector" был cvar (sv_playermodel_selector_force), который мешал нормальной смене моддели, <br>
примерно так же как cvar в PAC3 (pac_modifier_model) <br>
2 - Исправлена чат-команда: /itemdrop <br>
<br>
Будущие обновления: <br>
1 - Доработать wiki <br>
2 - Написать английскую версию wiki <br>
3 - Добавить больше предметов <br>
4 - Добавить больше крючков для взаимодействия <br>
5 - Переделать систему добавление оружия и энтити в инвентарь <br>
6 - Добавить механики для ролеплея <br>
7 - Добавить одежду для NPC <br>
]]
end

ClothingSystem.VersionDescription = [[
<html>
<head>
		<style>
			body {
				padding: 0;
				margin: 0;
				height: 100%;
				font-family: Arial;
				font-size: 14;
				font-weight: normal;
				background-color: #ffffff;
			}
			h1 {
				font-family: Arial;
				font-size: 14;
				font-weight: normal;
			}
			h2 {
				font-family: Arial;
				font-size: 16;
				font-weight: normal;
			}
			h3 {
				font-family: Arial;
				font-size: 18;
				font-weight: normal;
			}
			p {
				padding-left: 20px;
			}
			ul, ol {
				padding-left: 40px;
			}
			.container {
				min-height: 100%;
				position: relative;
			}
		</style>
	</head>
<body>
████─█───████─███─█──█─███─█──█─████────███─██─██─███─███─███─█───█ <br>
█──█─█───█──█──█──█──█──█──██─█─█───────█────███──█────█──█───██─██ <br>
█────█───█──█──█──████──█──█─██─█─██────███───█───███──█──███─█─█─█ <br>
█──█─█───█──█──█──█──█──█──█──█─█──█──────█───█─────█──█──█───█───█ <br>
████─███─████──█──█──█─███─█──█─████────███───█───███──█──███─█───█ <br>
<br>
<br>
]]..TEXT..[[ <br>
<br>
 ________________________________________________________ <br>                                  
| Support - https://steamcommunity.com/id/sharkvil1337/   <br>
| Site - http://flaminggaming.ru                          <br>
| Donate:                                                 <br>
| Yandex - 410011841936803                                <br>
| WebMoney WMZ - Z373459260747                            <br>
| WebMoney WMR - R144443188854                            <br>
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ <br>
 </body>
 </html>
]]

TEXT = nil