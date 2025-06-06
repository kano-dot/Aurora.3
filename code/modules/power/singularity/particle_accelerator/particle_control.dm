//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/machinery/particle_accelerator/control_box
	name = "Particle Accelerator Control Computer"
	desc = "This controls the density of the particles."
	icon = 'icons/obj/machinery/particle_accelerator.dmi'
	icon_state = "control_box"
	reference = "control_box"
	anchored = FALSE
	density = TRUE
	use_power = POWER_USE_OFF
	idle_power_usage = 500
	active_power_usage = 70000 //70 kW per unit of strength
	construction_state = 0
	active = FALSE
	dir = NORTH
	var/strength_upper_limit = 2
	var/list/obj/structure/particle_accelerator/connected_parts
	var/assembled = 0
	var/parts
	var/datum/wires/particle_acc/control_box/wires

/obj/machinery/particle_accelerator/control_box/Initialize()
	wires = new(src)
	connected_parts = list()
	change_power_consumption(initial(active_power_usage) * (strength + 1), POWER_USE_ACTIVE)
	. = ..()

/obj/machinery/particle_accelerator/control_box/Destroy()
	if(active)
		toggle_power()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/particle_accelerator/control_box/attack_hand(mob/user as mob)
	if(construction_state >= 3)
		interact(user)
	else if(construction_state == 2) // Wires exposed
		wires.interact(user)

/obj/machinery/particle_accelerator/control_box/update_state()
	if(construction_state < 3)
		update_use_power(POWER_USE_OFF)
		assembled = 0
		active = 0
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = null
			part.powered = 0
			part.update_icon()
		connected_parts = list()
		return
	if(!part_scan())
		update_use_power(POWER_USE_IDLE)
		active = 0
		connected_parts = list()

	return

/obj/machinery/particle_accelerator/control_box/update_icon()
	if(active)
		icon_state = "[reference]p[strength]"
	else
		if(use_power)
			if(assembled)
				icon_state = "[reference]p"
			else
				icon_state = "u[reference]p"
		else
			switch(construction_state)
				if(0)
					icon_state = "[reference]"
				if(1)
					icon_state = "[reference]"
				if(2)
					icon_state = "[reference]w"
				else
					icon_state = "[reference]c"
	return

/obj/machinery/particle_accelerator/control_box/Topic(href, href_list)
	..()
	//Ignore input if we are broken, !silicon guy cant touch us, or nonai controlling from super far away
	if(stat & (BROKEN|NOPOWER) || (get_dist(src, usr) > 1 && !istype(usr, /mob/living/silicon)) || (get_dist(src, usr) > 8 && !istype(usr, /mob/living/silicon/ai)))
		usr.unset_machine()
		usr << browse(null, "window=pacontrol")
		return

	if(href_list["close"])
		usr << browse(null, "window=pacontrol")
		usr.unset_machine()
		return

	if(href_list["togglep"])
		if(!wires.is_cut(WIRE_POWER))
			src.toggle_power(usr)
	else if(href_list["scan"])
		src.part_scan()

	else if(href_list["strengthup"])
		if(!wires.is_cut(WIRE_STRENGTH))
			add_strength()

	else if(href_list["strengthdown"])
		if(!wires.is_cut(WIRE_STRENGTH))
			remove_strength()

	src.updateDialog()
	src.update_icon()
	return

/obj/machinery/particle_accelerator/control_box/proc/strength_change()
	for(var/obj/structure/particle_accelerator/part in connected_parts)
		part.strength = strength
		part.update_icon()

	update_icon()

/obj/machinery/particle_accelerator/control_box/proc/add_strength(var/s)
	if(assembled)
		strength++
		if(strength > strength_upper_limit)
			strength = strength_upper_limit
		else
			message_admins("PA Control Computer increased to [strength] by [key_name(usr, usr.client)](<A href='byond://?_src_=holder;adminmoreinfo=[REF(usr)]'>?</A>) in ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			log_game("PA Control Computer increased to [strength] by [usr.ckey]([usr]) in ([x],[y],[z])")
			investigate_log("increased to <span class='warning'>[strength]</span> by [usr.key]","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/proc/remove_strength(var/s)
	if(assembled)
		strength--
		if(strength < 0)
			strength = 0
		else
			message_admins("PA Control Computer decreased to [strength] by [key_name(usr, usr.client)](<A href='byond://?_src_=holder;adminmoreinfo=[REF(usr)]'>?</A>) in ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			log_game("PA Control Computer decreased to [strength] by [usr.ckey]([usr]) in ([x],[y],[z])")
			investigate_log("decreased to <font color='green'>[strength]</font> by [usr.key]","singulo")
		strength_change()

/obj/machinery/particle_accelerator/control_box/power_change()
	..()
	if(stat & NOPOWER)
		active = FALSE
		update_use_power(POWER_USE_OFF)
	else if(!stat && construction_state == 3)
		update_use_power(POWER_USE_IDLE)
	return


/obj/machinery/particle_accelerator/control_box/process()
	if(src.active)
		//a part is missing!
		if(length(connected_parts) < 6)
			investigate_log("lost a connected part; It <span class='warning'>powered down</span>.","singulo")
			src.toggle_power()
			return
		//emit some particles
		for(var/obj/structure/particle_accelerator/particle_emitter/PE in connected_parts)
			if(PE)
				PE.emit_particle(src.strength)
	return


/obj/machinery/particle_accelerator/control_box/proc/part_scan()
	for(var/obj/structure/particle_accelerator/fuel_chamber/F in orange(1,src))
		src.set_dir(F.dir)
	connected_parts = list()
	var/tally = 0
	var/ldir = turn(dir,-90)
	var/rdir = turn(dir,90)
	var/odir = turn(dir,180)
	var/turf/T = src.loc
	T = get_step(T,rdir)
	if(check_part(T,/obj/structure/particle_accelerator/fuel_chamber))
		tally++
	T = get_step(T,odir)
	if(check_part(T,/obj/structure/particle_accelerator/end_cap))
		tally++
	T = get_step(T,dir)
	T = get_step(T,dir)
	if(check_part(T,/obj/structure/particle_accelerator/power_box))
		tally++
	T = get_step(T,dir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/center))
		tally++
	T = get_step(T,ldir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/left))
		tally++
	T = get_step(T,rdir)
	T = get_step(T,rdir)
	if(check_part(T,/obj/structure/particle_accelerator/particle_emitter/right))
		tally++
	if(tally >= 6)
		assembled = 1
		return 1
	else
		assembled = 0
		return 0


/obj/machinery/particle_accelerator/control_box/proc/check_part(var/turf/T, var/type)
	if(!(T)||!(type))
		return 0
	var/obj/structure/particle_accelerator/PA = locate(/obj/structure/particle_accelerator) in T
	if(istype(PA, type))
		if(PA.connect_master(src))
			if(PA.report_ready(src))
				src.connected_parts.Add(PA)
				return 1
	return 0


/obj/machinery/particle_accelerator/control_box/toggle_power(mob/user)
	src.active = !src.active
	investigate_log("turned [active?SPAN_WARNING("ON"):"<font color='green'>OFF</font>"] by [user ? user.key : "outside forces"]","singulo")
	message_admins("PA Control Computer turned [active ?"ON":"OFF"] by [key_name(user, TRUE, highlight_special = TRUE)] in ([x],[y],[z] - <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("PA Control Computer turned [active ?"ON":"OFF"] by [key_name(user)] in ([x],[y],[z])")
	if(src.active)
		update_use_power(POWER_USE_ACTIVE)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = src.strength
			part.powered = 1
			part.update_icon()
	else
		update_use_power(POWER_USE_IDLE)
		for(var/obj/structure/particle_accelerator/part in connected_parts)
			part.strength = null
			part.powered = 0
			part.update_icon()
	return 1


/obj/machinery/particle_accelerator/control_box/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (BROKEN|NOPOWER)))
		if(!istype(user, /mob/living/silicon))
			user.unset_machine()
			user << browse(null, "window=pacontrol")
			return
	user.set_machine(src)

	var/dat = ""
	dat += "Particle Accelerator Control Panel<BR>"
	dat += "<A href='byond://?src=[REF(src)];close=1'>Close</A><BR><BR>"
	dat += "Status:<BR>"
	if(!assembled)
		dat += "Unable to detect all parts!<BR>"
		dat += "<A href='byond://?src=[REF(src)];scan=1'>Run Scan</A><BR><BR>"
	else
		dat += "All parts in place.<BR><BR>"
		dat += "Power:"
		if(active)
			dat += "On<BR>"
		else
			dat += "Off <BR>"
		dat += "<A href='byond://?src=[REF(src)];togglep=1'>Toggle Power</A><BR><BR>"
		dat += "Particle Strength: [src.strength] "
		dat += "<A href='byond://?src=[REF(src)];strengthdown=1'>--</A>|<A href='byond://?src=[REF(src)];strengthup=1'>++</A><BR><BR>"

	var/datum/browser/pa_win = new(user, "pacontrol", capitalize_first_letters(name), 420, 500)
	pa_win.set_content(dat)
	pa_win.open()
