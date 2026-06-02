/datum/map_template/ruin/away_site/desolate_fortress
	name = "Desolate Fortress"
	description = "Desolate Fortress."
	id = "desolate_fortress"

	prefix = "scenarios/desolate_fortress/"
	suffix = "desolate_fortress.dmm"

	traits = list(
		// Surface
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Above Surface
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	spawn_cost = 1
	spawn_weight = 0
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	unit_test_groups = list(3)

	exoplanet_atmospheres = list(/datum/gas_mixture/earth_hot)
	exoplanet_lightlevel = list(5)
	exoplanet_lightcolor = list("#e7b079")

/singleton/submap_archetype/desolate_fortress
	map = "Desolate Fortress"
	descriptor = "Desolate Fortress."

/obj/effect/overmap/visitable/sector/desolate_fortress
	name = "Enaiposha-Prime, Swamp Planet"
	desc = "\
		A humid, waterlogged planet. Surface is predominantly shallow water and saturated peat. Storms are frequent, fog is persistent. \
		Ground is unreliable, expect sink zones and corrosion from humidity. \
		Further scans indicate a network of fortified settlements near the perimeter of viable landing zones. \
		"
	comms_support = TRUE
	icon_state = "globe2"
	color = "#af9281"

	initial_generic_waypoints = list(
	)
