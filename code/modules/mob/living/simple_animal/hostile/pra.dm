/mob/living/simple_animal/hostile/republicon
	name = "republican defensive robot"
	desc = "An outdated defense drone commonly used by People's Republic of Adhomai Orbital Fleet."
	desc_extended = "Most heavy and medium Republican ships carry a detachment of very outdated combat robots brought from Solarian military surplus, they are usually armed with \
	blades,	ballistic rifles or rockets. Those machines are usually deployed in rare cases of boarding operations. They possess a rudimentary artificial intelligence and targeting system, \
	being only capable of perfoming simple tasks outside of attacking. The People's Republic is unable to manufacture this kind of synthetics, but their fleet technicians can \
	easily repair and reprogram them."
	icon = 'icons/mob/npc/republicon.dmi'
	icon_state = "republicon"
	icon_living = "republicon"
	icon_dead = "republicon_dead"
	blood_type = COLOR_OIL
	speak_chance = 5
	universal_speak = FALSE
	turns_per_move = 3
	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speak_emote = list("beeps")
	emote_hear = list("buzzes","beeps")
	speak = list("Hadii's grace, comrades.","Report any enemy of the Party!", "Attention; this gun is not on stun!")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	attack_emote = "buzzes menacingly at"
	stop_automated_movement_when_pulled = FALSE
	health = 300
	maxHealth = 300

	destroy_surroundings = FALSE

	universal_speak = TRUE
	universal_understand = TRUE

	melee_damage_lower = 15
	melee_damage_upper = 15
	mob_size = 5

	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	speed = 2

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "PRA"

	tameable = FALSE

	smart_ranged = TRUE

	mob_bump_flag = ROBOT
	mob_swap_flags = ROBOT|MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = ~HEAVY

	simple_default_language = LANGUAGE_SIIK_MAAS

	psi_pingable = FALSE
	sample_data = null

/mob/living/simple_animal/hostile/republicon/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/simple_animal/hostile/republicon/validator_living(var/mob/living/L, var/atom/current)
	if((L.faction == src.faction) && !attack_same)
		return FALSE
	if(L in friends)
		return FALSE

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.w_uniform)
			var/obj/item/clothing/under/suit = H.w_uniform
			if((locate(/obj/item/clothing/accessory/hadii_pin) in suit.accessories) || (locate(/obj/item/clothing/accessory/badge/hadii_card) in suit.accessories))
				return FALSE
	if(ismech(L))
		var/mob/living/heavy_vehicle/M = L
		if(M.body && istype(M.body, /obj/item/mech_component/chassis/pra_egg))
			return FALSE

	if(!L.stat)
		var/current_health = INFINITY
		if (isliving(current))
			var/mob/living/M = current
			current_health = M.health
		if(L.health < current_health)
			return TRUE

	return FALSE

/mob/living/simple_animal/hostile/republicon/FoundTarget()
	if(istajara(last_found_target))
		say("Subversive element detected!")
	else
		say("Foreign invader detected!")
	return

/mob/living/simple_animal/hostile/republicon/LostTarget()
	say("Returning to patrol.")
	return

/mob/living/simple_animal/hostile/republicon/isSynthetic()
	return TRUE

/mob/living/simple_animal/hostile/republicon/ranged
	icon_state = "republicon-armed"
	icon_living = "republicon-armed"
	icon_dead = "republicon-armed_dead"
	speed = 3

	health = 200
	maxHealth = 200

	ranged = TRUE
	rapid = TRUE

	projectilesound = 'sound/weapons/gunshot/gunshot_saw.ogg'
	projectiletype = /obj/projectile/bullet/rifle/a762
	casingtype = /obj/item/ammo_casing/a762/spent

/mob/living/simple_animal/hostile/republicon/ranged/Initialize()
	. = ..()
	if(prob(25))
		projectiletype = /obj/projectile/bullet/gyro/law
		projectilesound = 'sound/effects/Explosion1.ogg'
		rapid = FALSE
		casingtype = null

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone
	name = "hadiist exploration drone"
	desc = "A reconnaissance drone used by the People's Republic of Adhomai to explore space and collect information on planets."

	icon = 'icons/mob/npc/republicon.dmi'
	icon_state = "exploration_drone"
	icon_living = "exploration_drone"
	icon_dead = "exploration_drone"

	blood_type = COLOR_OIL
	smart_ranged = TRUE
	turns_per_move = 3
	organ_names = list("body", "probes", "antenna")

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0

	speak_emote = list("beeps")
	emote_hear = list("buzzes","beeps")
	speak = list("Hadii's grace, comrades.", "The stars belong to the People's Republic of Adhomai!", "The quest for knowledge must continue!")
	emote_see = list("beeps curiously", "whirrs softly", "scans its surroundings")
	attack_emote = "beeps menacingly at"

	destroy_surroundings = FALSE
	universal_speak = TRUE
	universal_understand = TRUE
	speak_chance = 5
	simple_default_language = LANGUAGE_SIIK_MAAS

	mob_size = 3

	health = 100
	maxHealth = 100

	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "smashed"
	attack_sound = 'sound/weapons/genhit1.ogg'

	speed = 1
	ranged = TRUE
	projectiletype = /obj/projectile/beam/pistol
	projectilesound = 'sound/weapons/laser1.ogg'

	emote_see = list("examines","hovers","blinks")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	faction = "PRA"

	tameable = FALSE
	flying = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	emote_sounds = list('sound/effects/creatures/PRA_drone.ogg')

	psi_pingable = FALSE

	var/datum/effect_system/ion_trail/ion_trail

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/Allow_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/isSynthetic()
	return TRUE

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/death()
	..(null, "blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, GLOB.alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/Initialize()
	. = ..()

	set_light(1.2, 3, LIGHT_COLOR_RED)

	ion_trail = new(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/FoundTarget()
	if(!ishuman(last_found_target))
		say("Hostile xenofauna detected!")
	else if(istajara(last_found_target))
		say("Subversive element detected!")
	else
		say("Foreign invader detected!")
	playsound(src, 'sound/effects/creatures/PRA_drone_aggro.ogg', 75, 1)

/mob/living/simple_animal/hostile/retaliate/pra_exploration_drone/LostTarget()
	say("Returning to data gathering.")
