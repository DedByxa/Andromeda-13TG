// Admin Verbs in this file are special and cannot use the AVD system for some reason or another.

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = ADMIN_CATEGORY_MAIN

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, span_interface("All of your adminverbs are now visible."), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Show Adminverbs")

/client/proc/readmin()
	set name = "ВКЛ. АДМИН"
	set category = "Админ"
	set desc = "Восстановите свои административные полномочия. Если они у вас есть.."

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("Теперь вы являетесь администратором."), confidential = TRUE)
	message_admins("[src] вернул себе права администратора.")
	log_admin("[src] вернул себе права администратора.")
	BLACKBOX_LOG_ADMIN_VERB("ВКЛ АДМИН ПРАВА")

/client/proc/admin_2fa_verify()
	set name = "Verify Admin"
	set category = "Админ"

	var/datum/admins/admin = GLOB.admin_datums[ckey]
	admin?.associate(src)
