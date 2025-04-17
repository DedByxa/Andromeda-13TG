// Verb to toggle restart notifications
/client/verb/notify_restart()
	set category = "OOC"
	set name = "Уведомить о перезапуске"
	set desc = "Уведомляет вас в Discord о перезагрузке сервера."

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("Для использования этой функции требуется, чтобы серверная часть SQL была запущена."))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice("Сервер все еще запускается. Пожалуйста, подождите, прежде чем пытаться связать вашу учетную запись."))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning("Эта функция требует, чтобы сервер работал на инструментарии TGS."))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		to_chat(src, span_warning("Для этого вам нужно связать свой аккаунт Discord с помощью \"Связать аккаунт Discord\"."))
		return

	var/stored_mention = "<@[stored_id]>"
	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == stored_mention)
			SSdiscord.notify_members -= stored_mention
			to_chat(src, span_notice("Вы больше не будете получать уведомления о перезагрузке сервера."))
			return // This is necassary so it doesnt get added again, as it relies on the for loop being unsuccessful to tell us if they are in the list or not

	// If we got here, they arent in the list. Chuck 'em in!
	to_chat(src, span_notice("Теперь вы будете получать уведомления о перезапуске сервера."))
	SSdiscord.notify_members += "[stored_mention]"
