#define CHOICE_INITIATE_CREW_TRANSFER "Initiate Crew Transfer"
#define CHOICE_CONTINUE "Continue Playing"

/datum/vote/crew_transfer
	name = "Вызвать шаттл"
	default_choices = list(
		CHOICE_INITIATE_CREW_TRANSFER,
		CHOICE_CONTINUE,
	)
	default_message = "Голосование за вызов шаттла"

/datum/vote/crew_transfer/toggle_votable()
	CONFIG_SET(flag/allow_crew_transfer_vote, !CONFIG_GET(flag/allow_crew_transfer_vote))

/datum/vote/crew_transfer/is_config_enabled()
	return CONFIG_GET(flag/allow_crew_transfer_vote)

/datum/vote/crew_transfer/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .

	switch(SSticker.current_state)
		if(GAME_STATE_PLAYING)
			if(!EMERGENCY_IDLE_OR_RECALLED)
				return "Шаттл не может быть вызван."

			return VOTE_AVAILABLE
		if(GAME_STATE_FINISHED)
			return "Раунд уже закончен."
		else
			return "Раунд еще не начался."

/datum/vote/crew_transfer/finalize_vote(winning_option)
	switch(winning_option)
		if(CHOICE_CONTINUE)
			return
		if(CHOICE_INITIATE_CREW_TRANSFER)
			initiate_tranfer()
			return
		else
			CRASH("[type] не был передан правильный выбор победителя. (Получено: [winning_option || "null"])")

/datum/vote/crew_transfer/proc/initiate_tranfer()
	PRIVATE_PROC(TRUE)

	if(!EMERGENCY_IDLE_OR_RECALLED)
		log_admin("Шаттл не может быть вызван автоматическим голосованием за перевод экипажа, потому что он уже используется или отключен.")
		message_admins(span_adminnotice("Шаттл не может быть вызван автоматическим голосованием за перевод экипажа, потому что он уже используется или отключен."))
		return

	SSshuttle.admin_emergency_no_recall = TRUE
	SSshuttle.emergency.mode = SHUTTLE_IDLE
	SSshuttle.emergency.request(reason = " Автоматическое окончание смены")

	log_admin("Шаттл вызван в связи с голосованием по автоматическому переводу экипажа.")
	message_admins(span_adminnotice("Шаттл вызван в связи с голосованием по автоматическому переводу экипажа."))

#undef CHOICE_INITIATE_CREW_TRANSFER
#undef CHOICE_CONTINUE
