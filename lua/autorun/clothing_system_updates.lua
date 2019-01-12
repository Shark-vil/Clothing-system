ClothingSystem = ClothingSystem || {}

ClothingSystem.AddonVersion = "0.4.6"

local TEXT = [[
GitHub commits - <a href="https://github.com/Shark-vil/Clothing-system/commits">https://github.com/Shark-vil/Clothing-system/commits</a> <br>
Open the update menu (Console command) - clothing_system_updates <br>
__________________________ <br>
<h3>What's new?</h3>
1 - Now you can create a base for clothing. This will make it easier for other users to edit the code.<br>
<h2>Example:</h2>
<h1>Before:</h1>
<img src="https://dl.dropboxusercontent.com/s/t3kxwww36ep3xro/2019-01-12%20%282%29.png" width="650" height="450" /><br>
<h1>After:</h1>
<img src="https://dl.dropbox.com/s/drun53hdyxosl2d/2019-01-12%20%283%29.png" width="650" height="450" /><br>
2 - Minor fixes were made<br>
__________________________ <br>
This mod is developed on enthusiasm. I would be glad if you would support me, at least with a small amount of money. <br>
]]

if ( GetConVar("clothing_system_language"):GetString() == "ru" ) then
TEXT = [[
GitHub commits - <a href="https://github.com/Shark-vil/Clothing-system/commits">https://github.com/Shark-vil/Clothing-system/commits</a> <br>
Открыть меню обновлений (Консольная команда) - clothing_system_updates <br>
__________________________ <br>
<h3>Что нового?</h3>
1 - Появилась возможность создания базы для одежды. Это позволит другим пользователям проще редактировать код.<br>
<h2>Пример:</h2>
<h1>Было:</h1>
<img src="https://dl.dropboxusercontent.com/s/t3kxwww36ep3xro/2019-01-12%20%282%29.png" width="650" height="450" /><br>
<h1>Стало:</h1>
<img src="https://dl.dropbox.com/s/drun53hdyxosl2d/2019-01-12%20%283%29.png" width="650" height="450" /><br>
2 - Были внесены мелкие исправления<br>
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
| Support - <a href="https://steamcommunity.com/id/sharkvil1337/">https://steamcommunity.com/id/sharkvil1337/</a>   <br>
| Site - <a href="http://flaminggaming.ru">http://flaminggaming.ru</a>                          <br>
| Donate:                                                 <br>
| Yandex - 410011841936803                                <br>
| WebMoney WMZ - Z373459260747                            <br>
| WebMoney WMR - R144443188854                            <br>
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾ <br>
 </body>
 </html>
]]

TEXT = nil