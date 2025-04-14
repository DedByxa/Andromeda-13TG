#define CHOICE_RESTART "Restart Round"
#define CHOICE_CONTINUE "Continue Playing"

/datum/vote/restart_vote
	name = "Рестарт раунда"
	default_choices = list(
		CHOICE_RESTART,
		CHOICE_CONTINUE,
	)
	default_message = "Проголосуйте, чтобы перезапустить текущий раунд. \
		Работает только в том случае, если в сети нет администраторов или они AFK."

/// This proc checks to see if any admins are online for the purposes of this vote to see if it can pass. Returns TRUE if there are valid admins online (Has +SERVER and is not AFK), FALSE otherwise.
/datum/vote/restart_vote/proc/admins_present()
	for(var/client/online_admin as anything in GLOB.admins)
		if(online_admin.is_afk() || !check_rights_for(online_admin, R_SERVER))
			continue

		return TRUE

	return FALSE

/datum/vote/restart_vote/toggle_votable()
	CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))

/datum/vote/restart_vote/is_config_enabled()
	return CONFIG_GET(flag/allow_vote_restart)

/datum/vote/restart_vote/create_vote(mob/vote_creator)
	. = ..()
	if(!.)
		return
	if(!admins_present())
		return
	async_alert_about_admins(vote_creator)

/datum/vote/restart_vote/proc/async_alert_about_admins(mob/vote_creator)
	set waitfor = FALSE
	tgui_alert(vote_creator, "Независимо от результатов этого голосования, \
		раунд автоматически не возобновится, поскольку активный администратор находится в сети.")

/datum/vote/restart_vote/get_vote_result(list/non_voters)
	if(!CONFIG_GET(flag/default_no_vote))
		// Default no votes will add non-voters to "Continue Playing"
		choices[CHOICE_CONTINUE] += length(non_voters)

	return ..()

/datum/vote/restart_vote/finalize_vote(winning_option)
	if(winning_option == CHOICE_CONTINUE)
		return

	if(winning_option == CHOICE_RESTART)
		if(admins_present())
			to_chat(world, span_boldannounce("Нотис: Голосование по перезапуску не приведет к автоматическому перезапуску сервера, поскольку на нем присутствуют активные администраторы."))
			message_admins("Голосование за перезапуск прошло, но на сервере есть активные администраторы с +SERVER, поэтому оно было отменено. Если вы хотите, вы можете перезапустить сервер.")
			return

		// If there was a previous map vote, we revert the change.
		if(!isnull(SSmap_vote.next_map_config))
			log_game("Следующая карта была сброшена из-за успешного голосования за рестарт.")
			send_to_playing_players(span_boldannounce("Следующая карта была сброшена из-за успешного голосования за рестарт."))
			SSmap_vote.revert_next_map()

		SSticker.force_ending = FORCE_END_ROUND
		log_game("Вынужденное завершение раунда, благодаря успешному голосованию за рестарт.")
		return

	CRASH("[type] не был передан правильный выбор победителя. (Получено: [winning_option || "null"])")

#undef CHOICE_RESTART
#undef CHOICE_CONTINUE
