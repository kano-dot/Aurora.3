/singleton/scenario/desolate_fortress
	name = "Desolate Fortress"
	desc = "\
		While venturing through the sector, SCCV Horizon's sensors caught a distress call sent from an indepentendtly owned deep-space shipyard nearby. \
		SCCV Horizon, one of the few vessels within the perimeter capable of responding, was dispatched to investigate further."
	scenario_site_id = "desolate_fortress"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/desolate_fortress
	roles = list(
		/singleton/role/generic_crew,
		/singleton/role/generic_engineer,
		/singleton/role/generic_medical,
		/singleton/role/generic_security,
		/singleton/role/generic_business,
	)
	default_outfit = /obj/outfit/admin/generic
	//actor_accesses = list(/datum/access/decrepit_shipyard_staff)
	radio_frequency_name = "Fortress Enaiposha-Prime"

	base_area = /area/desolate_fortress

/singleton/scenario_announcements/desolate_fortress
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. A nearby deep-space shipyard has launched a distress beacon, requesting help. \
		The station is independently owned and has been providing repair and maintenance services for the travellers until recently. \
		You are authorized to establish contact, investigate and provide aid if required. \
		Docking clearance have been granted, you may dispatch at will. \
		"

	offship_announcement_message = "A nearby deep-space shipyard has launched a distress beacon. The coordinates have been registered on the flight deck."
