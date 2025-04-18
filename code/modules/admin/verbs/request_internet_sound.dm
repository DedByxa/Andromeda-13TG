/mob/verb/request_internet_sound()
	set category = "OOC"
	set name = "Запросите интернет-звук"

	if(GLOB.say_disabled) //This is here to try to identify lag problems
		to_chat(usr, span_danger("Общение было заблокировано администрацией."), confidential = TRUE)
		return

	if (!CONFIG_GET(flag/request_internet_sound))
		to_chat(usr, span_danger("This server has disabled internet sound requests."), confidential = TRUE)
		return

	var/request_url = tgui_input_text(usr, "Пожалуйста, введите URL-адрес", "Разрешены только определенные сайты, такие как YouTube, SoundCloud и Bandcamp.", "")
	if(!request_url)
		return

	//regex filter
	var/regex/allowed_regex = regex(replacetext(CONFIG_GET(string/request_internet_allowed), ",", "|"), "i")
	if(!allowed_regex.Find(request_url))
		to_chat(usr, span_danger("Неверный URL. Пожалуйста, используйте URL с одного из следующих сайтов: [replacetext(CONFIG_GET(string/request_internet_allowed), "\\", "")]"), confidential = TRUE)
		return

	var/credit = tgui_alert(usr, "Показать, что именно вы заказали этот звук? (будет отображаться как [usr.ckey])", "Доверяете себе?", list("Нет", "Да", "Отмена"))

	if(credit == "Отмена" || isnull(credit))
		return
	else if (credit == "Да")
		credit = "[usr.ckey] запросил этот трек."
	else
		credit = "Кто-то запросил этот трек."

	log_internet_request("[src.key]/([src.name]): [request_url]")
	if(usr.client)
		if(usr.client.prefs.muted & MUTE_INTERNET_REQUEST)
			to_chat(usr, span_danger("В данный момент вы не можете запросить музыку. (мут)."), confidential = TRUE)
			return
		if(src.client.handle_spam_prevention(request_url,MUTE_INTERNET_REQUEST))
			return

	GLOB.requests.music_request(usr.client, request_url, credit)
	to_chat(usr, span_info("Вы запросили: \"[request_url]\" чтобы быть воспроизведенным."), confidential = TRUE)
	request_url = span_adminnotice("<b><font color='cyan'>МУЗЫКАЛЬНЫЙ ЗАПРОС: </font>[ADMIN_FULLMONTY(src)] [ADMIN_SC(src)]:</b> [span_linkify(request_url)] [ADMIN_PLAY_INTERNET(request_url, credit)]")
	for(var/client/admin_client in GLOB.admins)
		if(get_chat_toggles(admin_client) & CHAT_PRAYER)
			to_chat(admin_client, request_url, type = MESSAGE_TYPE_PRAYER, confidential = TRUE)

	SSblackbox.record_feedback("tally", "music_request", 1, "Music Request") // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
