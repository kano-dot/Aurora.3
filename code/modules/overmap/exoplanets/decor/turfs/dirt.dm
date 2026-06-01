/turf/simulated/floor/exoplanet/asteroid/dirt
	name = "dirt"
	gender = PLURAL
	desc = "Some coarse dirt."
	icon_state = "darkdirt"
	base_icon = 'icons/turf/smooth/darkdirt.dmi'
	base_icon_state = "darkdirt"
	does_footprint = FALSE
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON

/turf/simulated/floor/exoplanet/asteroid/dirt/mire
	color = "#c2c2c2"
	var/obj/effect/overlay/mire/mire_overlay

/turf/simulated/floor/exoplanet/asteroid/dirt/mire/Initialize()
	. = ..()
	mire_overlay = new(src)

/turf/simulated/floor/exoplanet/asteroid/dirt/mire/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(locate(/obj/structure/lattice) in get_turf(src))
		return

	if(isliving(AM) && !AM.throwing)
		if(mire_overlay)
			if(AM.loc == src)
				mire_overlay.layer = ABOVE_HUMAN_LAYER
				mire_overlay.plane = ABOVE_GAME_PLANE

/turf/simulated/floor/exoplanet/asteroid/dirt/mire/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		if(mire_overlay)
			if(!locate(/mob/living) in src)
				mire_overlay.layer = BELOW_BELOW_OBJ_LAYER
				mire_overlay.plane = GAME_PLANE

/obj/effect/overlay/mire
	icon = 'icons/turf/smooth/darkdirt_overlay.dmi'
	icon_state = "bottom"
	color = "#c2c2c2"
	density = FALSE
	mouse_opacity = FALSE
	layer = BELOW_BELOW_OBJ_LAYER
	anchored = TRUE

/turf/simulated/floor/exoplanet/asteroid/rock
	name = "rock"
	icon_state = "rock"
	base_icon = 'icons/turf/smooth/rock.dmi'
	base_icon_state = "rock"
	does_footprint = FALSE
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	canSmoothWith = list(
		/turf/simulated/floor/exoplanet/asteroid/dirt
	)
