/singleton/persistent_type/generic/horizon_whiteboard
	/// Persistent whiteboards present on the Horizon when the round's map finished loading.
	var/list/whiteboard_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved whiteboards.
	var/whiteboard_initialized = FALSE

/** Loads saved whiteboard data to mapped whiteboards during late initialization. */
/singleton/persistent_type/generic/horizon_whiteboard/initialization_hook()
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_whiteboard, skip_caching = TRUE)
	var/list/saved_content_bulk = saved_generic?.content
	for(var/obj/structure/whiteboard/whiteboard in world)
		CHECK_TICK
		var/turf/T = get_turf(whiteboard)
		if(!T || !is_station_level(T.z))
			continue

		whiteboard_register += whiteboard
		var/persistent_whiteboard_id = "[whiteboard.x]-[whiteboard.y]-[whiteboard.z]-[whiteboard.type]"
		var/list/saved_content = saved_content_bulk?[persistent_whiteboard_id]
		if(islist(saved_content))
			whiteboard.written_contents = saved_content["written_contents"]
			// --- note to self: add whiteboard overlay icon name here
			// --- note to self: add author ckey here

	whiteboard_initialized = TRUE

/** Saves whiteboard data for the initially mapped whiteboards without considering their current locations. */
/singleton/persistent_type/generic/horizon_whiteboard/finalization_hook()
	if(!whiteboard_initialized)
		return

	var/list/all_whiteboards = list()
	for(var/obj/structure/whiteboard/whiteboard as anything in whiteboard_register)
		CHECK_TICK
		if(QDELETED(whiteboard))
			continue

		// even if written_contents is null, we include it anyway, if the board is empty by the end of the round
		var/list/whiteboard_content = list(
			"written_contents" = whiteboard.written_contents ? whiteboard.written_contents : ""
			// --- note to self: add whiteboard overlay icon name here
			// --- note to self: add author ckey here
		)
		all_whiteboards[whiteboard.persistent_whiteboard_id] = whiteboard_content

	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_whiteboard, all_whiteboards)
