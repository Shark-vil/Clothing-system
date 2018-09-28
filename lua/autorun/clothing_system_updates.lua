ClothingSystem = ClothingSystem || {}

ClothingSystem.AddonVersion = "0.4.4"

local TEXT = [[
GitHub commits - https://github.com/Shark-vil/Clothing-system/commits <br>
Open the update menu (Console command) - clothing_system_updates <br>
__________________________ <br>
Update: <br>
1 - Added developer functions - <a href="https://github.com/Shark-vil/Clothing-system/wiki/Developer-functions">https://github.com/Shark-vil/Clothing-system/wiki/Developer-functions</a>

<h1>Old updates.</h1>
<h1>!!! >> WARNING << !!! </h1><br>
1 - All models have been removed from the packs, and now they are not present in the collection. To re-display the models, subscribe to all the mods in the assembly! <br>
<a href="https://steamcommunity.com/workshop/filedetails/?id=1515299286">https://steamcommunity.com/workshop/filedetails/?id=1515299286</a> <br>
2 - The system of protection of the network channel is improved. Now the private key is generated not only on the server, but also on the client, but access to it is still impossible. <br>
3 - All sounds are reduced by 50 percent. <br>
4 - Added a new pack of things (PayDay 2) - <a href="https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=1522907995">https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=1522907995</a> <br>
Errors: <br>
1 - Accidentally deleted all the covers of objects. I'll fix it in the next update. <br>
__________________________ <br>
This mod is developed on enthusiasm. I would be glad if you would support me, at least with a small amount of money. <br>
]]

if ( GetConVar("clothing_system_language"):GetString() == "ru" ) then
TEXT = [[
GitHub commits - https://github.com/Shark-vil/Clothing-system/commits <br>
Открыть меню обновлений (Консольная команда) - clothing_system_updates <br>
__________________________ <br>
Обновление: <br>
1 - Добавлены функции разработчика - <a href="https://github.com/Shark-vil/Clothing-system/wiki/Developer-functions">https://github.com/Shark-vil/Clothing-system/wiki/Developer-functions</a>

<h1>Старые обновления.</h1>
<h1>!!! >> ВНИМАНИЕ << !!! </h1><br>
1 - Все модели были удалены из паков, и теперь они не вшиты в коллекцию. Чтобы вновь отображались модели, подпишитесь на все моды в сборке! <br>
<a href="https://steamcommunity.com/workshop/filedetails/?id=1515299286">https://steamcommunity.com/workshop/filedetails/?id=1515299286</a> <br>
2 - Улучшена система защиты сетевого канала. Теперь приватный ключ формируется не только на сервере, но и на клиенте, однако доступ к нему всё так же невозможен. <br>
3 - Все звуки уменьшены на 50 процентов. <br>
4 - Добавлен новый пак вещей (PayDay 2) - <a href="https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=1522907995">https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=1522907995</a> <br>
Ошибки: <br>
1 - Случайно удалил все обложки объектов. Починю в следующем обновлении. <br>
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