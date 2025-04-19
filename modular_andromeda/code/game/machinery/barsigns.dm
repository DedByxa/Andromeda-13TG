// Позволяет коду брать спрайт из нашей папки
/obj/machinery/barsign/set_sign(datum/barsign/sign)
	if(!istype(sign))
		return
	if(initial(sign.andromeda13_icon))
		icon = initial(sign.andromeda13_icon)
	else
		icon = initial(icon)
	. = ..()

/datum/barsign
	var/andromeda13_icon


/datum/barsign/wagner
	name = "Вагнер"
	icon_state = "pmc_wagner"
	desc = "Работа для крепких ребят."
	andromeda13_icon = 'modular_andromeda/icons/obj/machines/barsigns.dmi'
