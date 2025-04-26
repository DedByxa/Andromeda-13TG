//Proto-Kinetic Accelerators

/obj/item/gun/energy/recharge/kinetic_accelerator/variant //Parent Variant so we can apply general changes
/obj/item/gun/energy/recharge/kinetic_accelerator/variant/Initialize(mapload)
	. = ..()
	if(type == /obj/item/gun/energy/recharge/kinetic_accelerator/variant) // we don't want these prototypes to exist
		return INITIALIZE_HINT_QDEL

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/borg/upgrade/modkit/chassis_mod))
		to_chat(user, span_notice("This weapon doesn't have variant appearances."))
	else
		return ..()

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/nomod/crowbar_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("This weapon cannot have its modifications removed."))
	return ITEM_INTERACT_BLOCKING

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/nomod/

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/nomod/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/borg/upgrade/modkit))
		to_chat(user, span_notice("This weapon cannot have modifications applied."))
	else
		return ..()


/obj/item/gun/energy/recharge/kinetic_accelerator/variant/railgun
	name = "proto-kinetic railgun"
	desc = " This variant seems to use all its energy into an hyper focused shoot, and needs two hands to use."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticrailgun"
	base_icon_state = "kineticrailgun"
	inhand_icon_state = "kineticgun"
	w_class = WEIGHT_CLASS_HUGE
	pin = /obj/item/firing_pin/wastes
	recharge_time = 3 SECONDS
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/railgun)
	weapon_weight = WEAPON_HEAVY
	max_mod_capacity = 0
	recoil = 3
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/railgun/add_bayonet_point()
	return

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/repeater
	name = "proto-kinetic repeater"
	desc = " This variant seems to be specialized into firing thrice and has a longer barrel."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticrepeater"
	base_icon_state = "kineticrepeater"
	inhand_icon_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/repeater)
	max_mod_capacity = 65

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/repeater/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/shotgun
	name = "proto-kinetic shotgun"
	desc = " This variant seems to have a prism that splits the ray in three."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticshotgun"
	base_icon_state = "kineticshotgun"
	inhand_icon_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/shotgun)
	max_mod_capacity = 65
	randomspread = 0

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/glock
	name = "proto-kinetic pistol"
	desc = " This variant seems bare, but has a significant amount of mod slots."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticpistol"
	base_icon_state = "kineticpistol"
	inhand_icon_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/glock)
	max_mod_capacity = 220 // 30 over base.

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/glock/add_bayonet_point()
	return

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/shockwave
	name = "proto-kinetic shockwave"
	desc = " This variant produces a shockwave that surrounds the user with kinetic energy."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticshockwave"
	base_icon_state = "kineticshockwave"
	inhand_icon_state = "kineticgun"
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/shockwave)
	max_mod_capacity = 65
	randomspread = 0

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/shockwave/add_bayonet_point()
	return

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/nomod/m79
	name = "proto-kinetic grenade launcher"
	desc = " This variant launches mining charges, using the kinetic energy to propel them."
	icon = 'modular_andromeda/modules/mining_pka/icons/pka.dmi'
	icon_state = "kineticglauncher"
	base_icon_state = "kineticglauncher"
	inhand_icon_state = "kineticgun"
	pin = /obj/item/firing_pin/wastes
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/m79)
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	max_mod_capacity = 0

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/nomod/m79/add_bayonet_point()
	return

//Shockwave process_fire override to prevent Point Blank, we shoot towards the edge of the direction of the user, like with jumpboots.

/obj/item/gun/energy/recharge/kinetic_accelerator/variant/shockwave/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	target = get_edge_target_turf(user, user.dir)
	return ..()
