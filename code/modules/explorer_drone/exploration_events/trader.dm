/// Trader events - If drone is loaded with X exchanges it for Y, might require translator tool.
/datum/exploration_event/simple/trader
	root_abstract_type = /datum/exploration_event/simple/trader
	action_text = "Trade"
	/// Obj path we'll take or list of paths ,one path will be picked from it at init
	var/required_path
	/// Obj path we'll give out or list of paths ,one path will be picked from it at init
	var/traded_path
	//How many times we'll allow the trade
	var/amount = 1
	var/requires_translator = TRUE

/datum/exploration_event/simple/trader/New()
	. = ..()
	if(islist(required_path))
		required_path = pick(required_path)
	if(islist(traded_path))
		traded_path = pick(traded_path)

/datum/exploration_event/simple/trader/get_discovery_message(obj/item/exodrone/drone)
	if(requires_translator && !drone.has_tool(EXODRONE_TOOL_TRANSLATOR))
		return "Вы столкнулись с [name], но не смогли понять, чего они хотят, без переводчика."
	var/obj/want = required_path
	var/obj/gives = traded_path
	return "Столкнулись с [name] желающим обменять [initial(gives.name)] на [initial(want.name)]"

/datum/exploration_event/simple/trader/get_description(obj/item/exodrone/drone)
	if(requires_translator && !drone.has_tool(EXODRONE_TOOL_TRANSLATOR))
		return "Вы сталкиваетесь с [name], но не можете понять, чего они хотят, без переводчика."
	var/obj/want = required_path
	var/obj/gives = traded_path
	return "Вы сталкиваетесь с [name] желающим обменять [initial(want.name)] на  [initial(gives.name)] [amount > 1 ? "[amount] раз":""]."

/datum/exploration_event/simple/trader/is_targetable()
	return visited && (amount > 0)

/datum/exploration_event/simple/trader/action_enabled(obj/item/exodrone/drone)
	var/obj/trade_good = locate(required_path) in drone.contents
	return (amount > 0) && trade_good && (!requires_translator || drone.has_tool(EXODRONE_TOOL_TRANSLATOR))

/datum/exploration_event/simple/trader/fire(obj/item/exodrone/drone)
	if(!action_enabled(drone))
		end(drone)
		return
	amount--
	trade(drone)
	end(drone)

/datum/exploration_event/simple/trader/proc/trade(obj/item/exodrone/drone)
	var/obj/trade_good = locate(required_path) in drone.contents
	var/obj/loot = new traded_path()
	drone.drone_log("Обменял [trade_good] на [loot].")
	qdel(trade_good)
	drone.try_transfer(loot)


/// Trade events

/datum/exploration_event/simple/trader/vendor_ai
	name = "разумный автомат по продаже наркотиков"
	required_site_traits = list(EXPLORATION_SITE_TECHNOLOGY)
	band_values = list(EXOSCANNER_BAND_TECH=2)
	requires_translator = FALSE
	required_path = /obj/item/stock_parts/power_store/cell/high
	traded_path = /obj/item/storage/pill_bottle/happy
	amount = 3

/datum/exploration_event/simple/trader/farmer_market
	name = "фермерский рынок"
	deep_scan_description = "Вы обнаруживаете на территории участок с необычно высокой концентрацией съестных припасов."
	required_site_traits = list(EXPLORATION_SITE_HABITABLE,EXPLORATION_SITE_SURFACE)
	band_values = list(EXOSCANNER_BAND_LIFE=2)
	required_path = /obj/item/stock_parts/servo/nano
	traded_path = list(/obj/item/seeds/tomato/killer,/obj/item/seeds/orange_3d,/obj/item/seeds/firelemon,/obj/item/seeds/gatfruit)
	amount = 1

/datum/exploration_event/simple/trader/fish
	name = "межзвездный торговец рыбой"
	requires_translator = FALSE
	deep_scan_description = "На территории отеля вы замечаете гигантскую вывеску "СВЕЖАЯ РЫБА"."
	required_site_traits = list(EXPLORATION_SITE_HABITABLE,EXPLORATION_SITE_SURFACE)
	band_values = list(EXOSCANNER_BAND_LIFE=2)
	required_path = /obj/item/stock_parts/power_store/cell/high
	traded_path = /obj/item/storage/fish_case/random
	amount = 3

/datum/exploration_event/simple/trader/shady_merchant
	name = "сомнительный торговец"
	requires_translator = FALSE
	required_site_traits = list(EXPLORATION_SITE_HABITABLE,EXPLORATION_SITE_CIVILIZED)
	band_values = list(EXOSCANNER_BAND_LIFE=1)
	required_path = list(/obj/item/organ/heart,/obj/item/organ/liver,/obj/item/organ/stomach,/obj/item/organ/eyes)
	traded_path = list(/obj/item/implanter/explosive)
	amount = 1

/datum/exploration_event/simple/trader/surplus
	name = "торговец военными излишками"
	deep_scan_description = "Вы расшифровываете сообщение, рекламирующее военное имущество, выставленное на продажу."
	required_site_traits = list(EXPLORATION_SITE_HABITABLE,EXPLORATION_SITE_CIVILIZED)
	band_values = list(EXOSCANNER_BAND_LIFE=1)
	required_path = list(/obj/item/clothing/suit/armor,/obj/item/clothing/shoes/jackboots)
	traded_path = /obj/item/gun/energy/laser/retro/old
	amount = 3

/datum/exploration_event/simple/trader/flame_card
	name = "мастер по изготовлению удостоверений личности"
	deep_scan_description = "Вы заметили рекламу семинара по настройке идентификационных карт."
	required_site_traits = list(EXPLORATION_SITE_HABITABLE,EXPLORATION_SITE_CIVILIZED)
	band_values = list(EXOSCANNER_BAND_TECH=1)
	required_path = list(/obj/item/card/id) //If you trade a better card for worse that's on you
	traded_path = null
	requires_translator = FALSE
	amount = 1
	var/static/list/possible_card_states = list("card_flames","card_carp","card_rainbow")

/datum/exploration_event/simple/trader/flame_card/get_discovery_message(obj/item/exodrone/drone)
	return "Столкнулись с [name] желающими настроить любое удостоверение личности, которое вы им принесете."

/datum/exploration_event/simple/trader/flame_card/get_description(obj/item/exodrone/drone)
	return "Вы встретите местного мастера, который бесплатно изготовит для вас индивидуальное удостоверение личности."

/datum/exploration_event/simple/trader/flame_card/trade(obj/item/exodrone/drone)
	var/obj/item/card/id/card = locate(required_path) in drone.contents
	card.icon_state = pick(possible_card_states)
	card.update_icon() //Refresh cached helper image
	drone.drone_log("Позвольте ремесленнику работать над [card.name].")
