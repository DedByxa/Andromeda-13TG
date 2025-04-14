///Data holder for the announcers that can be used in a game, this can be used to have alternative announcements outside of the default e.g.the intern
///Держатель данных для дикторов, которые могут быть использованы в игре, это может быть использовано для получения альтернативных объявлений, отличных от стандартных, например, для стажера
/datum/centcom_announcer
	///Раундстарт анонс
	var/welcome_sounds = list()
	///Звуки, издаваемые при получении объявления.
	var/alert_sounds = list()
	///Звуки, издаваемые при получении командного объявления.
	var/command_report_sounds = list()
	///Звук, издаваемые при получении событии. Если звук не найден, используется звук по умолчанию.
	var/event_sounds = list()
	///Кастомные анонсы
	var/custom_alert_message


/datum/centcom_announcer/proc/get_rand_welcome_sound()
	return pick(welcome_sounds)


/datum/centcom_announcer/proc/get_rand_alert_sound()
	return pick(alert_sounds)

/datum/centcom_announcer/proc/get_rand_report_sound()
	return pick(command_report_sounds)
