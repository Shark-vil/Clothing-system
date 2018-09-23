ClothingSystem = ClothingSystem || {}

ClothingSystem.AddonVersion = "0.4.1"

local TEXT = [[
GitHub commits = https://github.com/Shark-vil/Clothing-system/commit/0281bdf4e76040337d9b6023f0c85cb448173d83 <br>
__________________________ <br>
Update: <br>
1 - Changed variables to create clothes, now they are shorter and simpler <br>
2 - Added cvar, which removes the effect of breathing through the mask - clothing_system_gasmask_sound_effect (1/0) <br>
3 - In the development there is a new menu that can be opened by send the chat /clothing, or by entering the console command - open_new_clothing_menu<br>
4 - Fixed a bug where the sheets could not load due to the large number of addons <br>
5 - Added a chat command that allows you to remove the last item - /lastdrop <br>
6 - Fixed the function of creating an arbitrary collision <br>
__________________________ <br>
This mod is developed on enthusiasm. I would be glad if you would support me, at least with a small amount of money. <br>
]]

if ( GetConVar("clothing_system_language"):GetString() == "ru" ) then
TEXT = [[
GitHub commits = https://github.com/Shark-vil/Clothing-system/commit/0281bdf4e76040337d9b6023f0c85cb448173d83 <br>
__________________________ <br>
Обновление: <br>
1 - Изменены переменные для создания одежды, теперь они не более короткие и простые <br>
2 - Добавлен квар, убирающий эффект дыхания через маску - clothing_system_gasmask_sound_effect (1/0) <br>
3 - В разработке находится новое меню, которое можно открыть введя в чат /clothing, или введя консольную команду - open_new_clothing_menu <br>
4 - Исправлена ошибка, когда листы не успевали загружаться из-за большого колличества аддонов <br>
5 - Добавлена чат-команда, позволяющая снять последний надетый предмет - /lastdrop <br>
6 - Исправлена функция создания произвольной коллизии <br>
__________________________ <br>
Этот мод разрабатывается на энтузиазме. Я был бы рад, если бы вы поддержали меня, хотя бы небольшой суммой денег. <br>
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