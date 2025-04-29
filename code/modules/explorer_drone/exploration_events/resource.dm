/// Simple event type that checks if you have a tool and after a retrieval delay adds loot to drone.
/datum/exploration_event/simple/resource
	name = "извлекаемый ресурс"
	root_abstract_type = /datum/exploration_event/simple/resource
	discovery_log = "Обнаруженно восстанавливаемый ресурс."
	action_text = "Извлекать"
	/// Tool type required to recover this resource
	var/required_tool
	/// What you get out of it, either /obj path or adventure_loot_generator id
	var/loot_type = /obj/item/trash/chips
	/// Message logged on success
	var/success_log = "Извлек что-то"
	/// Description shown when you don't have the tool
	var/no_tool_description = "Вы не сможете извлечь его без дрели."
	/// Description shown when you have the necessary tool
	var/has_tool_description = "Ты можешь вытащить его с помощью своей дрели!"
	var/delay = 30 SECONDS
	var/delay_message = "Восстанавливающий ресурс..."
	/// How many times can this be extracted
	var/amount = 1

/// Description shown below image
/datum/exploration_event/simple/resource/get_description(obj/item/exodrone/drone)
	. = ..()
	var/list/desc_list = list(.)
	if(!required_tool || drone.has_tool(required_tool))
		desc_list += has_tool_description
	else
		desc_list += no_tool_description
	return desc_list.Join("\n")

/datum/exploration_event/simple/resource/action_enabled(obj/item/exodrone/drone)
	return (amount > 0) && (!required_tool || drone.has_tool(required_tool))

/datum/exploration_event/simple/resource/fire(obj/item/exodrone/drone)
	if(!action_enabled(drone)) //someone used it up or we lost the tool while we were looking at ui
		end()
		return
	amount--
	if(delay > 0)
		drone.set_busy(delay_message,delay)
		addtimer(CALLBACK(src, PROC_REF(delay_finished),WEAKREF(drone)),delay)
	else
		finish_event(drone)

/datum/exploration_event/simple/resource/is_targetable()
	return visited && amount > 0 ///Can go back if something is left.

/datum/exploration_event/simple/resource/proc/delay_finished(datum/weakref/drone_ref)
	var/obj/item/exodrone/drone = drone_ref.resolve()
	if(QDELETED(drone)) //drone blown up in the meantime
		return
	drone.unset_busy(EXODRONE_EXPLORATION)
	finish_event(drone)

/datum/exploration_event/simple/resource/proc/finish_event(obj/item/exodrone/drone)
	drone.drone_log(success_log)
	dispense_loot(drone)
	end(drone)

/datum/exploration_event/simple/resource/proc/dispense_loot(obj/item/exodrone/drone)
	if(ispath(loot_type,/datum/adventure_loot_generator))
		var/datum/adventure_loot_generator/generator = new loot_type
		generator.transfer_loot(drone)
	else
		var/obj/loot = new loot_type()
		drone.try_transfer(loot)


/// Resource Events

// All
/datum/exploration_event/simple/resource/concealed_cache
	name = "скрытый тайник"
	band_values = list(EXOSCANNER_BAND_DENSITY=1)
	required_tool = EXODRONE_TOOL_WELDER
	discovery_log = "Обнаружил скрытый, запертый тайник."
	description = "Вы замечаете искусно спрятанный металлический контейнер."
	no_tool_description = "Вы не видите способа открыть его без помощи сварщика."
	has_tool_description = "Вы можете попробовать открыть его с помощью своего сварочного аппарата."
	action_text = "Открытый сварной шов"
	delay_message = "Сваркой открываем тайник..."
	loot_type = /datum/adventure_loot_generator/maintenance

// EXPLORATION_SITE_RUINS 2/2
/datum/exploration_event/simple/resource/remnants
	name = "высушенный труп"
	required_site_traits = list(EXPLORATION_SITE_RUINS)
	required_tool = EXODRONE_TOOL_MULTITOOL
	discovery_log = "Обнаружен труп гуманоида."
	description = "Вы находите высохший труп гуманоида, хотя он слишком поврежден, чтобы его можно было опознать. Неподалеку лежит запертый портфель."
	no_tool_description = "Вы не сможете открыть его без мультиинструмента."
	has_tool_description = "Вы можете попробовать взломать его своим мультитулом!"
	action_text = "Взломать дверь"
	delay_message = "Взлом..."
	loot_type = /datum/adventure_loot_generator/simple/cash

/datum/exploration_event/simple/resource/gunfight
	name = "остатки перестрелки"
	required_site_traits = list(EXPLORATION_SITE_RUINS)
	required_tool = EXODRONE_TOOL_DRILL
	discovery_log = "Обнаружил место прошлой перестрелки."
	description = "Вы находите место, заваленное гильзами от оружия и испещренное лазерными следами. Вы замечаете что-то под ближайшими обломками."
	no_tool_description = "Вы не сможете добраться до него без дрели."
	has_tool_description = "Вы можете удалить обломки с помощью своей дрели!"
	action_text = "Убирать щебень"
	delay_message = "Бурение..."
	loot_type = /datum/adventure_loot_generator/simple/weapons

// EXPLORATION_SITE_TECHNOLOGY 2/2
/datum/exploration_event/simple/resource/maint_room
	name = "запертое помещение для технического обслуживания"
	required_site_traits = list(EXPLORATION_SITE_TECHNOLOGY,EXPLORATION_SITE_STATION)
	required_tool = EXODRONE_TOOL_MULTITOOL
	discovery_log = "Обнаружил запертое техническое помещение."
	success_log = "Извлек содержимое запертого технического помещения."
	description = "Вы обнаруживаете запертую комнату технического обслуживания. Поблизости вы можете увидеть следы частых перемещений."
	no_tool_description = "Вы не сможете открыть его без мультитула."
	has_tool_description = "Вы можете попробовать открыть его с помощью своего мультитула!"
	action_text = "Взлом"
	delay_message = "Взлом..."
	loot_type = /datum/adventure_loot_generator/maintenance
	amount = 3

/datum/exploration_event/simple/resource/storage
	name = "складское помещение"
	required_site_traits = list(EXPLORATION_SITE_TECHNOLOGY,EXPLORATION_SITE_STATION)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	discovery_log = "Обнаружил кладовку, забитую ящиками."
	success_log = "Использовал переведенную декларацию, чтобы найти ящик с лекарствами."
	description = "Вы обнаруживаете складское помещение, забитое неопознанными ящиками. У входа прикреплена декларация на непонятном языке."
	no_tool_description = "Все ящики вокруг лишены полезного содержимого, а декларация нечитаема без переводчика."
	has_tool_description = "Вы можете перевести манифест с помощью вашего переводчика!"
	action_text = "Переводить"
	delay_message = "Перевод декларации..."
	loot_type = /datum/adventure_loot_generator/simple/drugs

// EXPLORATION_SITE_ALIEN 2/2
/datum/exploration_event/simple/resource/alien_tools
	name = "инопланетный саркофаг"
	required_site_traits = list(EXPLORATION_SITE_ALIEN)
	band_values = list(EXOSCANNER_BAND_TECH=1,EXOSCANNER_BAND_RADIATION=1)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	discovery_log = "Обнаружили инопланетный саркофаг, покрытый неизвестными иероглифами."
	success_log = "Извлеченное содержимое инопланетного саркофага."
	description = "Вы находите гигантский саркофаг инопланетного происхождения, покрытый неизвестными письменами."
	no_tool_description = "Вы не видите способа открыть саркофаг или перевести символы без мультитула."
	has_tool_description = "Вы переводите символы и находите описание скрытого механизма для отпирания гробницы."
	delay_message = "Открытие..."
	action_text = "Открыть"
	loot_type = /obj/item/scalpel/alien

/datum/exploration_event/simple/resource/pod
	name = "инопланетный биопод"
	required_site_traits = list(EXPLORATION_SITE_ALIEN)
	band_values = list(EXOSCANNER_BAND_LIFE=1)
	required_tool = EXODRONE_TOOL_LASER
	discovery_log = "Обнаружил капсулу инопланетянина."
	success_log = "Извлечено содержимое капсулы инопланетянина."
	description = "Вы сталкиваетесь с инопланетным биоплодом, полным странных мешков с похищенными формами жизни."
	no_tool_description = "Вы не сможете вскрыть биопод без высокоточного лазера."
	has_tool_description = "Вы можете попробовать разрезать его своим лазером!"
	delay_message = "Открытие..."
	action_text = "Открыть"
	loot_type = /datum/adventure_loot_generator/pet

// EXPLORATION_SITE_SHIP 2/2
/datum/exploration_event/simple/resource/fuel_storage
	name = "хранилище топлива"
	required_site_traits = list(EXPLORATION_SITE_SHIP)
	band_values = list(EXOSCANNER_BAND_PLASMA=1)
	required_tool = EXODRONE_TOOL_MULTITOOL
	discovery_log = "Обнаружен корабельный склад топлива."
	description = "Вы нашли топливный склад корабля. К сожалению, он заперт на электронный замок."
	success_log = "Извлекли топливо из хранилища."
	no_tool_description = "Вы не сможете взломать замок без мультитула."
	has_tool_description = "Вы можете попробовать закоротить замок с помощью своего мультитула!"
	delay_message = "Открытие..."
	action_text = "Открыть"
	loot_type = /obj/item/fuel_pellet/exotic

/datum/exploration_event/simple/resource/navigation
	name = "навигационные системы"
	required_site_traits = list(EXPLORATION_SITE_SHIP)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	discovery_log = "Обнаружил корабельные навигационные системы."
	description = "Вы обнаружите, что навигационные системы корабля закодированы на незнакомом языке. Вы сможете использовать данные с помощью переводчика."
	success_log = "Извлекли данные о доставке из навигационных систем."
	no_tool_description = "Вам понадобится переводчик, чтобы расшифровать эти данные."
	has_tool_description = "Вы можете попробовать перевести навигационные данные с помощью своего мультитула!"
	delay_message = "Извлечение данных..."
	action_text = "Извлечь данные"
	loot_type = /datum/adventure_loot_generator/cargo

// EXPLORATION_SITE_HABITABLE 2/2
/datum/exploration_event/simple/resource/unknown_microbiome
	name = "неизвестный микробиом"
	required_site_traits = list(EXPLORATION_SITE_HABITABLE)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	discovery_log = "Обнаружен изолированный микробиом."
	description = "Вы обнаруживаете гигантскую колонию грибов."
	success_log = "Получены образцы гриба для дальнейшего изучения."
	no_tool_description = "С помощью высокоточного лазера вы могли бы отрезать образец для исследования."
	has_tool_description = "Вы можете аккуратно вырезать образец из колонии своим лазером!"
	delay_message = "Взятие проб..."
	action_text = "Возьмите образец"
	loot_type = /obj/item/petri_dish/random

/datum/exploration_event/simple/resource/tcg_nerd
	name = "жуткий незнакомец"
	required_site_traits = list(EXPLORATION_SITE_HABITABLE)
	band_values = list(EXOSCANNER_BAND_LIFE=1)
	required_tool = EXODRONE_TOOL_TRANSLATOR
	discovery_log = "Встретили жуткого незнакомца."
	description = "Вы встречаете обитателя этого места, который выглядит оборванным и явно чем-то взволнованным."
	no_tool_description = "Без переводчика вы не сможете понять, что он пытается донести."
	has_tool_description = "Ваш переводчик говорит о том, что он хотел бы поделиться с вами своим хобби!"
	success_log = "Получил подарок от незнакомца."
	delay_message = "Ожидание..."
	action_text = "Примите подарок."
	loot_type = /obj/item/cardpack/series_one

// EXPLORATION_SITE_SPACE 2/2
/datum/exploration_event/simple/resource/comms_satellite
	name = "заброшенный спутник связи"
	required_site_traits = list(EXPLORATION_SITE_SPACE)
	required_tool = EXODRONE_TOOL_MULTITOOL
	discovery_log = "Обнаружен заброшенный спутник связи."
	description = "Вы обнаруживаете заброшенный спутник связи. Его ключ шифрования цел, но имеет сложный электронный замок."
	no_tool_description = "Для получения ключа шифрования вам понадобится мультитул."
	has_tool_description = "Вы можете отключить блокировку, чтобы извлечь ключ с помощью вашего мультитула!"
	success_log = "Извлек ключа шифрования с заброшенного спутника."
	delay_message = "Взлом..."
	action_text = "Замок открыт"
	loot_type = /obj/item/encryptionkey/heads/captain

/datum/exploration_event/simple/resource/welded_locker
	name = "сварной шкафчик"
	required_site_traits = list(EXPLORATION_SITE_SPACE)
	required_tool = EXODRONE_TOOL_WELDER
	discovery_log = "Обнаружил наспех сваренный шкафчик."
	description = "Вы обнаруживаете сварной шкафчик, парящий в космосе. Что может быть внутри...?"
	no_tool_description = "Чтобы извлечь содержимое шкафчика, вам понадобится сварочный инструмент."
	success_log = "Извлекли... отрубленную голову."
	delay_message = "Разваривание..."
	action_text = "Открыть"
	loot_type = /obj/item/bodypart/head

/datum/exploration_event/simple/resource/welded_locker/dispense_loot(obj/item/exodrone/drone)
	var/mob/living/carbon/human/head_species_source = new
	head_species_source.set_species(/datum/species/skeleton)
	head_species_source.real_name = "spaced locker victim"
	var/obj/item/bodypart/head/skeleton_head = head_species_source.get_bodypart(BODY_ZONE_HEAD)
	skeleton_head.drop_limb(FALSE)
	qdel(head_species_source)
	drone.try_transfer(skeleton_head)

// EXPLORATION_SITE_SURFACE 2/2
/datum/exploration_event/simple/resource/plasma_deposit
	name = "Необработанный плазменный осадок"
	required_site_traits = list(EXPLORATION_SITE_SURFACE)
	band_values = list(EXOSCANNER_BAND_PLASMA=3)
	required_tool = EXODRONE_TOOL_DRILL
	discovery_log = "Обнаружено значительное скопление плазмы."
	success_log = "Извлек плазму из осадка."
	description = "Вы обнаруживаете на поверхности обильное скопление плазмы."
	no_tool_description = "Вам понадобится дрель, чтобы взять что-нибудь из месторождения."
	has_tool_description = "Ваша дрель позволит вам извлечь месторождение!"
	action_text = "Добывать"
	delay_message = "Добыча..."
	loot_type = /obj/item/stack/sheet/mineral/plasma/thirty

/datum/exploration_event/simple/resource/mineral_deposit
	name = "МАТЕРИАЛЬНЫЙ депозит"
	required_site_traits = list(EXPLORATION_SITE_SURFACE)
	band_values = list(EXOSCANNER_BAND_DENSITY=3)
	required_tool = EXODRONE_TOOL_DRILL
	discovery_log = "Обнаружил значительное месторождение матрикса."
	success_log = "Извлекли МАТЕРИАЛ из месторождения."
	description = "Вы обнаруживаете богатые поверхностные залежи МАТЕРИАЛА."
	no_tool_description = "Вам понадобится дрель, чтобы взять что-нибудь из хранилища."
	has_tool_description = "Ваша дрель позволит вам извлечь месторождение!"
	action_text = "Добывать"
	delay_message = "Добыча..."
	var/static/list/possible_materials = list(/datum/material/silver,/datum/material/bananium,/datum/material/pizza) //only add materials with sheet type here
	var/loot_amount = 30
	var/chosen_material_type

/datum/exploration_event/simple/resource/mineral_deposit/New()
	. = ..()
	chosen_material_type = pick(possible_materials)
	var/datum/material/chosen_mat = GET_MATERIAL_REF(chosen_material_type)
	name = "[chosen_mat.name] Депозит"
	discovery_log = "Обнаружено крупное [chosen_mat.name] месторождение "
	success_log = "Извлечение [chosen_mat.name]."
	description = "Вы обнаруживаете богатое поверхностное месторождение [chosen_mat.name]."

/datum/exploration_event/simple/resource/mineral_deposit/dispense_loot(obj/item/exodrone/drone)
	var/datum/material/chosen_mat = GET_MATERIAL_REF(chosen_material_type)
	var/obj/loot = new chosen_mat.sheet_type(loot_amount)
	drone.try_transfer(loot)
