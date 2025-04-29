#define ADVENTURE_DIR "[global.config.directory]/adventures/"

//Special preset nodes

/// Victory node - Get loot and exit
#define WIN_NODE "ПОБЕДА"
/// Failure node - No loot, get damaged and exit.
#define FAIL_NODE "ПРОВАЛ"
/// Failure node - No loot and drone blown up.
#define FAIL_DEATH_NODE "СБОЙ_СМЕРТЬ"
/// Return node - navigates to previous adventure node.
#define GO_BACK_NODE "ВЕРНУТЬСЯ"

//Adventure results
#define ADVENTURE_RESULT_SUCCESS "успешно"
#define ADVENTURE_RESULT_DAMAGE "повреждение"
#define ADVENTURE_RESULT_DEATH "смерть"

// Exploration drone states

/// Drone is stationside - allow changing tools and such.
#define EXODRONE_IDLE "бездействует"
/// Drone is traveling from or to the exploration site
#define EXODRONE_TRAVEL "путешествует"
/// Drone is in adventure/event caused timeout
#define EXODRONE_BUSY "занятый"
/// Drone is at exploration site either idle or in simple event
#define EXODRONE_EXPLORATION "исследовать"
/// Drone is currently playing an adventure
#define EXODRONE_ADVENTURE "приключение"


// Scanner bands, use these to guess what's in the site and prepare drone accordingly.
#define EXOSCANNER_BAND_PLASMA "Plasma absorption band"
#define EXOSCANNER_BAND_LIFE "Углеводороды/молекулярный кислород"
#define EXOSCANNER_BAND_TECH "Узкополосные радиоволны"
#define EXOSCANNER_BAND_RADIATION "Экзотическое излучение"
#define EXOSCANNER_BAND_DENSITY "Повышенная плотность"
// Exodrone tools
#define EXODRONE_TOOL_WELDER "сварочный аппарат"
#define EXODRONE_TOOL_TRANSLATOR "переводчик"
#define EXODRONE_TOOL_LASER "лазер"
#define EXODRONE_TOOL_MULTITOOL "мультитул"
#define EXODRONE_TOOL_DRILL "бур"

GLOBAL_LIST_INIT(exodrone_tool_metadata,list(
	EXODRONE_TOOL_WELDER = list("description"="Сварка большой мощности.","icon"="burn"),
	EXODRONE_TOOL_TRANSLATOR = list("description"="Мощное программное обеспечение для перевода и записи данных.","icon"="language"),
	EXODRONE_TOOL_LASER = list("description"="Универсальный инструмент, пригодный для боевой и прецизионной резки.","icon"="bolt"),
	EXODRONE_TOOL_MULTITOOL = list("description"="Универсальный инструмент для работы с электроникой. Поставляется с набором датчиков излучения и радиоволн.","icon"="broadcast-tower"),
	EXODRONE_TOOL_DRILL = list("description"="Сверхмощный бур, пригодный для добычи полезных ископаемых.","icon"="screwdriver")
))

// Site traits

/// Some kind of ruined interior
#define EXPLORATION_SITE_RUINS "руины"
/// Power, wires and machinery present.
#define EXPLORATION_SITE_TECHNOLOGY "современные технологии"
/// It's a space station
#define EXPLORATION_SITE_STATION "космическая станция"
/// It's ancient alien site
#define EXPLORATION_SITE_ALIEN "инопланетянин"
/// Carbon-based life-forms can live here
#define EXPLORATION_SITE_HABITABLE "пригодный для жилья"
/// Site is in space
#define EXPLORATION_SITE_SPACE "в космосе"
/// Site is located on planet/moon/whatever surface
#define EXPLORATION_SITE_SURFACE "на поверхности"
/// Site is a space ship
#define EXPLORATION_SITE_SHIP "космический корабыль"
/// Site is civilized and populated, trading stations,cities etc. Lack of this trait means it's wilderness
#define EXPLORATION_SITE_CIVILIZED "цивилизация"


/// Scan types

// Wide scan, untargeted scan only reveals interest points. Cost increases exponentially with each firing. No scan conditions.
#define EXOSCAN_WIDE "широкое"
// Point scan, reveals name/description and general band information. Flat cost. Affected by scan conditions of the site
#define EXOSCAN_POINT "точное"
// Deep scan, reveals event scan texts. Linear cost increase with distance. Affected by scan conditions of the site.
#define EXOSCAN_DEEP "глубокое"

///  Adventure Effect Types

//completely removes the quality
#define ADVENTURE_EFFECT_TYPE_REMOVE "Удалить"
//adds/substracts value from quality
#define ADVENTURE_EFFECT_TYPE_ADD "Добавить"
//sets quality to specific value
#define ADVENTURE_EFFECT_TYPE_SET "Установить"

/// Adventure Effect Value Types

/// rolls value between low and high inclusive
#define ADVENTURE_QUALITY_TYPE_RANDOM "рандомное"
#define ADVENTURE_RANDOM_QUALITY_LOW_FIELD "низкое"
#define ADVENTURE_RANDOM_QUALITY_HIGH_FIELD "высокое"
