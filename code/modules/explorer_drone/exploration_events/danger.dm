/// Danger event - unskippable, if you have appriopriate tool you can mitigate damage.
/datum/exploration_event/simple/danger
	root_abstract_type = /datum/exploration_event/simple/danger
	description = "Вы столкнулись с гигантской ошибкой."
	var/required_tool = EXODRONE_TOOL_LASER
	var/has_tool_action_text = "Бой"
	var/no_tool_action_text = "Терпеть"
	var/has_tool_description = ""
	var/no_tool_description = ""
	var/avoid_log = "Спасся невредимым от опасности."
	var/damage = 30
	skippable = FALSE

/datum/exploration_event/simple/danger/get_description(obj/item/exodrone/drone)
	. = ..()
	var/list/desc_parts = list(.)
	desc_parts += can_escape_danger(drone) ? has_tool_description : no_tool_description
	return desc_parts.Join("\n")

/datum/exploration_event/simple/danger/get_action_text(obj/item/exodrone/drone)
	return can_escape_danger(drone) ? has_tool_action_text : no_tool_action_text

/datum/exploration_event/simple/danger/proc/can_escape_danger(obj/item/exodrone/drone)
	return !required_tool || drone.has_tool(required_tool)

/datum/exploration_event/simple/danger/fire(obj/item/exodrone/drone)
	if(can_escape_danger(drone))
		drone.drone_log(avoid_log)
	else
		drone.damage(damage)
	end(drone)

/// Danger events
/datum/exploration_event/simple/danger/carp
	name = "атака космического карпа"
	required_site_traits = list(EXPLORATION_SITE_SPACE)
	blacklisted_site_traits = list(EXPLORATION_SITE_CIVILIZED)
	deep_scan_description = "Вы обнаруживаете повреждения на участке, указывающие на присутствие космического карпа."
	description = "Вы попали в засаду, устроенную одиноким космическим карпом!"
	has_tool_action_text = "Бой"
	no_tool_action_text = "Побег!"
	has_tool_description = "Вы заряжаете свой лазер."
	no_tool_description = "Без какого-либо оружия вы можете только попытаться поспешно сбежать!"
	avoid_log = "Победил космического карпа."

/// They get everywhere
/datum/exploration_event/simple/danger/carp/surface_variety
	required_site_traits = list(EXPLORATION_SITE_SURFACE)

/datum/exploration_event/simple/danger/assistant
	name = "ассистентская атака"
	required_site_traits = list(EXPLORATION_SITE_STATION)
	deep_scan_description = "Обнаруженный коэффициент использования маски указывает на наличие на сайте большого количества пользователей с низким уровнем дохода."
	description = "Вы встречаете лохматое существо, одетое в серое! Это ненормальный ассистент!"
	has_tool_action_text = "Бой"
	no_tool_action_text = "Побег!"
	has_tool_description = "Вы заряжаете свой лазер."
	no_tool_description = "Без какого-либо оружия вы можете только попытаться поспешно сбежать!"
	avoid_log = "Победил ассистента."

/datum/exploration_event/simple/danger/collapse
	name = "коллапс"
	required_site_traits = list(EXPLORATION_SITE_RUINS)
	required_tool = EXODRONE_TOOL_DRILL
	deep_scan_description = "Сканирование показывает, что структура устарела; рекомендуется соблюдать осторожность."
	description = "Поврежденный потолок обрушивается, когда вы исследуете неизведанный проход! Вы оказались в ловушке из-за обломков."
	has_tool_action_text = "Выкапывать"
	no_tool_action_text = "Сжать."
	has_tool_description = "Ты можешь воспользоваться своей дрелью, чтобы выбраться наружу."
	no_tool_description = "Вам придется соскрести несколько деталей, чтобы вытащить их без каких-либо инструментов."
	avoid_log = "Выкопанный из обрушившегося прохода."

/datum/exploration_event/simple/danger/loose_wires
	name = "незакрепленные провода"
	required_site_traits = list(EXPLORATION_SITE_TECHNOLOGY)
	required_tool = EXODRONE_TOOL_MULTITOOL
	deep_scan_description = "Сканирование показало, что на месте было обнаружено огромное количество поврежденных проводов."
	description = "Вы слышите громкий щелчок позади себя! Куча искрящихся высоковольтных проводов преграждает вам путь к выходу."
	has_tool_action_text = "Отключить питание"
	no_tool_action_text = "Поджариться."
	has_tool_description = "Вы можете попробовать использовать свой мультитул, чтобы отключить питание и сбежать."
	no_tool_description = "Вам придется рискнуть поджарить свою электронику, чтобы выйти из строя."
	avoid_log = "Уцелел незакрепленный провод."

/datum/exploration_event/simple/danger/cosmic_rays
	name = "вспышка космического луча"
	required_site_traits = list(EXPLORATION_SITE_SURFACE)
	required_tool = EXODRONE_TOOL_MULTITOOL
	deep_scan_description = "Объект подвержен воздействию космической радиации. Рекомендуется использовать мультиинструмент для самодиагностики."
	description = "Связь с дроном внезапно прервалась! Похоже, что в беспилотник попала вспышка космических лучей! Вам придется подождать, пока сигнал восстановится."
	has_tool_description = "Ваш мультитул должен позволять самостоятельно устранять значительную часть повреждений." //wait, what?
	no_tool_description = "Ничего больше не оставалось, как ждать и оценивать ущерб."
	has_tool_action_text = "Подождите"
	no_tool_action_text = "Подождите"
	avoid_log = "Предотвратил повреждение космическими лучами с помощью мультитула."

/datum/exploration_event/simple/danger/alien_sentry
	name = "меры безопасности для иностранцев"
	required_site_traits = list(EXPLORATION_SITE_ALIEN)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	deep_scan_description = "На объекте обнаружены автоматизированные средства безопасности неизвестного происхождения."
	description = "Опасного вида машина выдвигается из-под пола и начинает высвечивать странные символы, издавая пронзительный звук!"
	has_tool_description = "Ваш переводчик распознает символы как приветствие службы безопасности и предлагает идентифицировать себя как гостя."
	no_tool_description = "Вскоре после этого машина начнет снимать."
	has_tool_action_text = "Назовите себя"
	no_tool_action_text = "Побег"
	avoid_log = "Избегал инопланетной охраны."

/datum/exploration_event/simple/danger/beast
	name = "встреча с инопланетянином"
	required_site_traits = list(EXPLORATION_SITE_HABITABLE)
	blacklisted_site_traits = list(EXPLORATION_SITE_CIVILIZED)
	required_tool = EXODRONE_TOOL_LASER
	deep_scan_description = "На месте была обнаружена опасная фауна."
	description = "Вы столкнулись с необычным зверем! Он готовится нанести удар."
	has_tool_action_text = "Бой"
	no_tool_action_text = "Побег"
	has_tool_description = "Ты готовишь свой лазер."
	no_tool_description = "Без какого-либо оружия вы можете только попытаться поспешно сбежать!"
	avoid_log = "Победил зверя."

/datum/exploration_event/simple/danger/beast/New()
	. = ..()
	var/beast_name = pick_list(EXODRONE_FILE,"alien_fauna")
	description = replacetext(description,"BEAST",beast_name)
	avoid_log = replacetext(avoid_log,"BEAST",beast_name)

/datum/exploration_event/simple/danger/rad
	name = "облученный участок"
	required_site_traits = list(EXPLORATION_SITE_SHIP)
	required_tool = EXODRONE_TOOL_MULTITOOL
	deep_scan_description = "Сканирование указывает на опасное радиоактивное присутствие."
	description = "Вы входите в ничем не примечательный раздел корабля."
	has_tool_action_text = "Объезд"
	no_tool_action_text = "Спастись и уменьшить ущерб."
	has_tool_description = "Ваш мультитул внезапно начнет предупреждающе мигать! Участок впереди освещен, вам придется обойти его, чтобы избежать повреждений."
	no_tool_description = "Внезапно беспилотник сообщает о значительных повреждениях, похоже, что этот участок был сильно облучен."
	avoid_log = "Избегать облученного участка."
