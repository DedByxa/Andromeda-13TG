// Server Tab - Server Verbs

ADMIN_VERB(toggle_random_events, R_SERVER, "Случайные ивенты", "Включает или выключает случайные события.", ADMIN_CATEGORY_SERVER)
	var/new_are = !CONFIG_GET(flag/allow_random_events)
	CONFIG_SET(flag/allow_random_events, new_are)
	message_admins("[key_name_admin(user)] изменил на [new_are ? "включено" : "отключено"] случайные события.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Случайные ивенты", "[new_are ? "Включить" : "Отключить"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_hub, R_SERVER, "Видимость в ХАБЕ", "Не трогать, сначало сломаю руки с ногами. После кину на растрерзание розовым вульпам.", ADMIN_CATEGORY_SERVER)
	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(user)] изменил статус сервера для раунда, теперь он находится [(GLOB.hub_visibility?"виден":"не виден")] в ХАБЕ.")
	message_admins("[key_name_admin(user)] изменил статус сервера для раунда, теперь он находится [(GLOB.hub_visibility?"виден":"виден")] в ХАБЕ.")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("ПРЕДУПРЕЖДЕНИЕ: Сервер не будет отображаться в ХАБЕ, поскольку byond обнаруживает, что файловая стена блокирует входящие подключения.")

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Включить" : "Отключить"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

#define REGULAR_RESTART "Перезапуск сервера"
#define REGULAR_RESTART_DELAYED "Перезапуск сервера (с задержкой)"
#define HARD_RESTART "Жесткий перезапуск сервера (Отсутствие причины задержки/обратной связи)"
#define HARDEST_RESTART "Самый сложный перезапуск (Никаких действий, просто перезагрузите компьютер)"
#define TGS_RESTART "Перезапуск сервера (Убить и перезапустить DD)"
ADMIN_VERB(restart, R_SERVER, "Перезапустить Сервер", "Раунд немедленно перезапускается.", ADMIN_CATEGORY_SERVER)
	var/list/options = list(REGULAR_RESTART, REGULAR_RESTART_DELAYED, HARD_RESTART)

	// this option runs a codepath that can leak db connections because it skips subsystem (specifically SSdbcore) shutdown
	if(!SSdbcore.IsConnected())
		options += HARDEST_RESTART

	if(world.TgsAvailable())
		options += TGS_RESTART;

	if(SSticker.admin_delay_notice)
		if(alert(user, "Вы уверены? Администратор уже отложил завершение раунда по следующей причине: [SSticker.admin_delay_notice]", "Подтверждение", "Да", "Нет") != "Да")
			return FALSE

	var/result = input(user, "Выберите метод перезагрузки", "Перезапустить Сервер", options[1]) as null|anything in options
	if(isnull(result))
		return

	BLACKBOX_LOG_ADMIN_VERB("Перезапустить Сервер")
	var/init_by = "Инициировано [user.holder.fakekey ? "Администратор" : user.key]."
	switch(result)
		if(REGULAR_RESTART)
			if(!user.is_localhost())
				if(alert(user, "Вы уверены, что хотите перезапустить сервер?","Этот сервер работает в режиме реального времени", "Рестарт", "Отмена") != "Рестарт")
					return FALSE
			SSticker.Reboot(init_by, "перезагрузка администратора - с помощью [user.key] [user.holder.fakekey ? "(stealth)" : ""]", 10)
		if(REGULAR_RESTART_DELAYED)
			var/delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
			if(!delay)
				return FALSE
			if(!user.is_localhost())
				if(alert(user,"Вы уверены, что хотите перезапустить сервер?","Этот сервер работает в режиме реального времени", "Рестарт", "Отмена") != "Рестарт")
					return FALSE
			SSticker.Reboot(init_by, "перезагрузка администратора - с помощью [user.key] [user.holder.fakekey ? "(stealth)" : ""]", delay * 10)
		if(HARD_RESTART)
			to_chat(world, "Перезапуск сервера - [init_by]")
			world.Reboot()
		if(HARDEST_RESTART)
			to_chat(world, "Жесткий перезапуск сервера - [init_by]")
			world.Reboot(fast_track = TRUE)
		if(TGS_RESTART)
			to_chat(world, "Перезапуск сервера - [init_by]")
			world.TgsEndProcess()

#undef REGULAR_RESTART
#undef REGULAR_RESTART_DELAYED
#undef HARD_RESTART
#undef HARDEST_RESTART
#undef TGS_RESTART

ADMIN_VERB(cancel_reboot, R_SERVER, "Отменить перезагрузку", "Отменяет ожидающую перезагрузку раунда.", ADMIN_CATEGORY_SERVER)
	if(!SSticker.cancel_reboot(user))
		return
	log_admin("[key_name(user)] отменил ожидаемую перезагрузку раунда.")
	message_admins("[key_name_admin(user)] отменил ожидаемую перезагрузку раунда.")

ADMIN_VERB(end_round, R_SERVER, "Закончить Рануд", "Принудительно завершает раунд и позволяет серверу перезагрузиться в обычном режиме.", ADMIN_CATEGORY_SERVER)
	var/confirm = tgui_alert(user, "Завершить раунд и перезапустить раунд?", "Закончить Рануд", list("Да", "Отменить"))
	if(confirm != "Да")
		return
	SSticker.force_ending = FORCE_END_ROUND
	BLACKBOX_LOG_ADMIN_VERB("Закончить Рануд")

ADMIN_VERB(toggle_ooc, R_ADMIN, "Переключить OOC", "Включите или выключите канал OOC.", ADMIN_CATEGORY_SERVER)
	toggle_ooc()
	log_admin("[key_name(user)] переключил OOC.")
	message_admins("[key_name_admin(user)] переключил OOC.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Переключить OOC", "[GLOB.ooc_allowed ? "Включить" : "Отключить"]"))

ADMIN_VERB(toggle_ooc_dead, R_ADMIN, "Переключить OOC Мёртвых", "Включите или выключите канал OOC для мертвых игроков.", ADMIN_CATEGORY_SERVER)
	toggle_dooc()
	log_admin("[key_name(user)] переключил OOC мёртвых.")
	message_admins("[key_name_admin(user)] переключил OOC мёртвых.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Переключить OOC мёртвых", "[GLOB.dooc_allowed ? "Включить" : "Отключить"]"))

ADMIN_VERB(toggle_vote_dead, R_ADMIN, "Переключить Голосование мёртвых", "Включите или выключите голосование погибших игроков.", ADMIN_CATEGORY_SERVER)
	SSvote.toggle_dead_voting(user)

ADMIN_VERB(start_now, R_SERVER, "Начать Раунд", "Начинайте раунд ПРЯМО СЕЙЧАС.", ADMIN_CATEGORY_SERVER)
	var/static/list/waiting_states = list(GAME_STATE_PREGAME, GAME_STATE_STARTUP)
	if(!(SSticker.current_state in waiting_states))
		to_chat(user, span_warning(span_red("Игра уже началась!")))
		return

	if(SSticker.start_immediately)
		SSticker.start_immediately = FALSE
		SSticker.SetTimeLeft(3 MINUTES)
		to_chat(world, span_big(span_notice("Игра начнется через 3 минуты.")))
		SEND_SOUND(world, sound('modular_andromeda/sound/announcer/classic/attention.ogg'))
		message_admins(span_adminnotice("[key_name_admin(user)] отменил немедленное начало игры. Игра начнется через 3 минуты.."))
		log_admin("[key_name(user)] отменил немедленный запуск игры.")
		return

	if(!user.is_localhost())
		var/response = tgui_alert(user, "Вы уверены, что хотите начать раунд?", "Начать Раунд", list("Да", "Отмена"))
		if(response != "Да")
			return
	SSticker.start_immediately = TRUE

	log_admin("[key_name(user)] запустил игру.")
	message_admins("[key_name_admin(user)] запустил игру.")
	if(SSticker.current_state == GAME_STATE_STARTUP)
		message_admins("Сервер все еще настраивается, но раунд будет запущен как можно скорее.")
	BLACKBOX_LOG_ADMIN_VERB("Начать Раунд")

ADMIN_VERB(delay_round_end, R_SERVER, "Задержать конец раунда", "Предотвратите перезапуск сервера.", ADMIN_CATEGORY_SERVER)
	if(SSticker.delay_end)
		tgui_alert(user, "Завершение раунда уже отложено. Причиной текущей задержки является: \"[SSticker.admin_delay_notice]\"", "Alert", list("Ok"))
		return

	var/delay_reason = input(user, "Укажите причину задержки завершения раунда", "Причина задержки раунда") as null|text

	if(isnull(delay_reason))
		return

	if(SSticker.delay_end)
		tgui_alert(user, "Завершение раунда уже отложено. Причиной текущей задержки является: \"[SSticker.admin_delay_notice]\"", "Alert", list("Ok"))
		return

	SSticker.delay_end = TRUE
	SSticker.admin_delay_notice = delay_reason
	if(SSticker.reboot_timer)
		SSticker.cancel_reboot(user)

	log_admin("[key_name(user)] завершение раунда отложено по причине: [SSticker.admin_delay_notice]")
	message_admins("[key_name_admin(user)] завершение раунда отложено по причине: [SSticker.admin_delay_notice]")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Задержка завершения раунда", "Причина: [delay_reason]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_enter, R_SERVER, "Переключить вход в игру", "Переключите возможность входа в игру.", ADMIN_CATEGORY_SERVER)
	if(!SSlag_switch.initialized)
		return
	SSlag_switch.set_measure(DISABLE_NON_OBSJOBS, !SSlag_switch.measures[DISABLE_NON_OBSJOBS])
	log_admin("[key_name(user)] изменило вход в игру для нового игрока. Переключение задержки при указании ([DISABLE_NON_OBSJOBS])")
	message_admins("[key_name_admin(user)] изменен вход в игру для нового игрока [SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "ВЫКЛ" : "ВКЛ"].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Переключить вход в игру", "[!SSlag_switch.measures[DISABLE_NON_OBSJOBS] ? "Включить" : "Отключить"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_ai, R_SERVER, "Переключить ИИ", "Включите возможность выбора профессии с использованием ИИ.", ADMIN_CATEGORY_SERVER)
	var/alai = CONFIG_GET(flag/allow_ai)
	CONFIG_SET(flag/allow_ai, !alai)
	if (alai)
		to_chat(world, span_bold("Должность с ИИ больше нельзя выбрать."), confidential = TRUE)
	else
		to_chat(world, "<B>Теперь можно выбрать должность с ИИ.</B>", confidential = TRUE)
	log_admin("[key_name(user)] разрешает выбор должности ИИ.")
	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Переключить ИИ", "[!alai ? "Отключить" : "Включить"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(toggle_respawn, R_SERVER, "Переключить Возрождения", "Переключите способность к возрождению.", ADMIN_CATEGORY_SERVER)
	var/respawn_state = CONFIG_GET(flag/allow_respawn)
	var/new_state = -1
	var/new_state_text = ""
	switch(respawn_state)
		if(RESPAWN_FLAG_DISABLED) // respawn currently disabled
			new_state = RESPAWN_FLAG_FREE
			new_state_text = "Включить"
			to_chat(world, span_bold("Теперь вы можете возродиться."), confidential = TRUE)

		if(RESPAWN_FLAG_FREE) // respawn currently enabled
			new_state = RESPAWN_FLAG_NEW_CHARACTER
			new_state_text = "Включить (Только за другого перса)"
			to_chat(world, span_bold("Теперь вы можете возродиться в качестве другого персонажа."), confidential = TRUE)

		if(RESPAWN_FLAG_NEW_CHARACTER) // respawn currently enabled for different slot characters only
			new_state = RESPAWN_FLAG_DISABLED
			new_state_text = "Отключить"
			to_chat(world, span_bold("Вы больше не можете возрождаться."), confidential = TRUE)

		else
			WARNING("Недопустимое состояние возрождения в конфигурации: [respawn_state]")

	if(new_state == -1)
		to_chat(user, span_warning("Конфигурация для respawn задана неправильно, пожалуйста, сообщите об этом на ближайший сервер (или исправьте это самостоятельно). \
			Тем временем для respawn установлено значение \"Выкл\"."))
		new_state = RESPAWN_FLAG_DISABLED
		new_state_text = "Отключить"

	CONFIG_SET(flag/allow_respawn, new_state)

	message_admins(span_adminnotice("[key_name_admin(user)] переключил респавн на \"[new_state_text]\"."))
	log_admin("[key_name(user)] переключил респавн на \"[new_state_text]\".")

	world.update_status()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Переключить режим возрождения", "[new_state_text]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(delay, R_SERVER, "Delay Pre-Game", "Delay the game start.", ADMIN_CATEGORY_SERVER)
	var/newtime = input(user, "Set a new time in seconds. Set -1 for indefinite delay.", "Set Delay", round(SSticker.GetTimeLeft()/10)) as num|null
	if(!newtime)
		return
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return tgui_alert(user, "Too late... The game has already started!")
	newtime = newtime*10
	SSticker.SetTimeLeft(newtime)
	SSticker.start_immediately = FALSE
	if(newtime < 0)
		to_chat(world, span_infoplain("<b>The game start has been delayed.</b>"), confidential = TRUE)
		log_admin("[key_name(user)] delayed the round start.")
	else
		to_chat(world, span_infoplain(span_bold("The game will start in [DisplayTimeText(newtime)].")), confidential = TRUE)
		SEND_SOUND(world, sound('modular_andromeda/sound/announcer/classic/attention.ogg'))
		log_admin("[key_name(user)] set the pre-game delay to [DisplayTimeText(newtime)].")
	BLACKBOX_LOG_ADMIN_VERB("Delay Game Start")

ADMIN_VERB(set_admin_notice, R_SERVER, "Set Admin Notice", "Set an announcement that appears to everyone who joins the server. Only lasts this round.", ADMIN_CATEGORY_SERVER)
	var/new_admin_notice = input(
		user,
		"Set a public notice for this round. Everyone who joins the server will see it.\n(Leaving it blank will delete the current notice):",
		"Set Notice",
		GLOB.admin_notice,
	) as message|null
	if(new_admin_notice == null)
		return
	if(new_admin_notice == GLOB.admin_notice)
		return
	if(new_admin_notice == "")
		message_admins("[key_name(user)] removed the admin notice.")
		log_admin("[key_name(user)] removed the admin notice:\n[GLOB.admin_notice]")
	else
		message_admins("[key_name(user)] set the admin notice.")
		log_admin("[key_name(user)] set the admin notice:\n[new_admin_notice]")
		to_chat(world, span_adminnotice("<b>Admin Notice:</b>\n \t [new_admin_notice]"), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Set Admin Notice")
	GLOB.admin_notice = new_admin_notice

ADMIN_VERB(toggle_guests, R_SERVER, "Toggle Guests", "Toggle the ability for guests to enter the game.", ADMIN_CATEGORY_SERVER)
	var/new_guest_ban = !CONFIG_GET(flag/guest_ban)
	CONFIG_SET(flag/guest_ban, new_guest_ban)
	if (new_guest_ban)
		to_chat(world, span_bold("Guests may no longer enter the game."), confidential = TRUE)
	else
		to_chat(world, "<B>Guests may now enter the game.</B>", confidential = TRUE)
	log_admin("[key_name(user)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed.")
	message_admins(span_adminnotice("[key_name_admin(user)] toggled guests game entering [!new_guest_ban ? "" : "dis"]allowed."))
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Guests", "[!new_guest_ban ? "Enabled" : "Disabled"]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
