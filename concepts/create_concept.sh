#!/usr/bin/env sh

awk '{print  "0", $0}' "0 timeofday_day.txt" >> concept.txt
awk '{print "10", $0}' "10 weather_lightning.txt" >> concept.txt
awk '{print "11", $0}' "11 weather_fogmist.txt" >> concept.txt
awk '{print "12", $0}' "12 weather_snowice.txt" >> concept.txt
awk '{print "13", $0}' "13 combustion_flames.txt" >> concept.txt
awk '{print "14", $0}' "14 combustion_smoke.txt" >> concept.txt
awk '{print "15", $0}' "15 combustion_fireworks.txt" >> concept.txt
awk '{print "16", $0}' "16 lighting_shadow.txt" >> concept.txt
awk '{print "17", $0}' "17 lighting_reflection.txt" >> concept.txt
awk '{print "18", $0}' "18 lighting_silhouette.txt" >> concept.txt
awk '{print "19", $0}' "19 lighting_lenseffect.txt" >> concept.txt
awk '{print  "1", $0}' "1 timeofday_night.txt" >> concept.txt
awk '{print "20", $0}' "20 scape_mountainhill.txt" >> concept.txt
awk '{print "21", $0}' "21 scape_desert.txt" >> concept.txt
awk '{print "22", $0}' "22 scape_forestpark.txt" >> concept.txt
awk '{print "23", $0}' "23 scape_coast.txt" >> concept.txt
awk '{print "24", $0}' "24 scape_rural.txt" >> concept.txt
awk '{print "25", $0}' "25 scape_city.txt" >> concept.txt
awk '{print "26", $0}' "26 scape_graffiti.txt" >> concept.txt
awk '{print "27", $0}' "27 water_underwater.txt" >> concept.txt
awk '{print "28", $0}' "28 water_seaocean.txt" >> concept.txt
awk '{print "29", $0}' "29 water_lake.txt" >> concept.txt
awk '{print  "2", $0}' "2 timeofday_sunrisesunset.txt" >> concept.txt
awk '{print "30", $0}' "30 water_riverstream.txt" >> concept.txt
awk '{print "31", $0}' "31 water_other.txt" >> concept.txt
awk '{print "32", $0}' "32 flora_tree.txt" >> concept.txt
awk '{print "33", $0}' "33 flora_plant.txt" >> concept.txt
awk '{print "34", $0}' "34 flora_flower.txt" >> concept.txt
awk '{print "35", $0}' "35 flora_grass.txt" >> concept.txt
awk '{print "36", $0}' "36 fauna_cat.txt" >> concept.txt
awk '{print "37", $0}' "37 fauna_dog.txt" >> concept.txt
awk '{print "38", $0}' "38 fauna_horse.txt" >> concept.txt
awk '{print "39", $0}' "39 fauna_fish.txt" >> concept.txt
awk '{print  "3", $0}' "3 celestial_sun.txt" >> concept.txt
awk '{print "40", $0}' "40 fauna_bird.txt" >> concept.txt
awk '{print "41", $0}' "41 fauna_insect.txt" >> concept.txt
awk '{print "42", $0}' "42 fauna_spider.txt" >> concept.txt
awk '{print "43", $0}' "43 fauna_amphibianreptile.txt" >> concept.txt
awk '{print "44", $0}' "44 fauna_rodent.txt" >> concept.txt
awk '{print "45", $0}' "45 quantity_none.txt" >> concept.txt
awk '{print "46", $0}' "46 quantity_one.txt" >> concept.txt
awk '{print "47", $0}' "47 quantity_two.txt" >> concept.txt
awk '{print "48", $0}' "48 quantity_three.txt" >> concept.txt
awk '{print "49", $0}' "49 quantity_smallgroup.txt" >> concept.txt
awk '{print  "4", $0}' "4 celestial_moon.txt" >> concept.txt
awk '{print "50", $0}' "50 quantity_biggroup.txt" >> concept.txt
awk '{print "51", $0}' "51 age_baby.txt" >> concept.txt
awk '{print "52", $0}' "52 age_child.txt" >> concept.txt
awk '{print "53", $0}' "53 age_teenager.txt" >> concept.txt
awk '{print "54", $0}' "54 age_adult.txt" >> concept.txt
awk '{print "55", $0}' "55 age_elderly.txt" >> concept.txt
awk '{print "56", $0}' "56 gender_male.txt" >> concept.txt
awk '{print "57", $0}' "57 gender_female.txt" >> concept.txt
awk '{print "58", $0}' "58 relation_familyfriends.txt" >> concept.txt
awk '{print "59", $0}' "59 relation_coworkers.txt" >> concept.txt
awk '{print  "5", $0}' "5 celestial_stars.txt" >> concept.txt
awk '{print "60", $0}' "60 relation_strangers.txt" >> concept.txt
awk '{print "61", $0}' "61 quality_noblur.txt" >> concept.txt
awk '{print "62", $0}' "62 quality_partialblur.txt" >> concept.txt
awk '{print "63", $0}' "63 quality_completeblur.txt" >> concept.txt
awk '{print "64", $0}' "64 quality_motionblur.txt" >> concept.txt
awk '{print "65", $0}' "65 quality_artifacts.txt" >> concept.txt
awk '{print "66", $0}' "66 style_pictureinpicture.txt" >> concept.txt
awk '{print "67", $0}' "67 style_circularwarp.txt" >> concept.txt
awk '{print "68", $0}' "68 style_graycolor.txt" >> concept.txt
awk '{print "69", $0}' "69 style_overlay.txt" >> concept.txt
awk '{print  "6", $0}' "6 weather_clearsky.txt" >> concept.txt
awk '{print "70", $0}' "70 view_portrait.txt" >> concept.txt
awk '{print "71", $0}' "71 view_closeupmacro.txt" >> concept.txt
awk '{print "72", $0}' "72 view_indoor.txt" >> concept.txt
awk '{print "73", $0}' "73 view_outdoor.txt" >> concept.txt
awk '{print "74", $0}' "74 setting_citylife.txt" >> concept.txt
awk '{print "75", $0}' "75 setting_partylife.txt" >> concept.txt
awk '{print "76", $0}' "76 setting_homelife.txt" >> concept.txt
awk '{print "77", $0}' "77 setting_sportsrecreation.txt" >> concept.txt
awk '{print "78", $0}' "78 setting_fooddrink.txt" >> concept.txt
awk '{print "79", $0}' "79 sentiment_happy.txt" >> concept.txt
awk '{print  "7", $0}' "7 weather_overcastsky.txt" >> concept.txt
awk '{print "80", $0}' "80 sentiment_calm.txt" >> concept.txt
awk '{print "81", $0}' "81 sentiment_inactive.txt" >> concept.txt
awk '{print "82", $0}' "82 sentiment_melancholic.txt" >> concept.txt
awk '{print "83", $0}' "83 sentiment_unpleasant.txt" >> concept.txt
awk '{print "84", $0}' "84 sentiment_scary.txt" >> concept.txt
awk '{print "85", $0}' "85 sentiment_active.txt" >> concept.txt
awk '{print "86", $0}' "86 sentiment_euphoric.txt" >> concept.txt
awk '{print "87", $0}' "87 sentiment_funny.txt" >> concept.txt
awk '{print "88", $0}' "88 transport_cycle.txt" >> concept.txt
awk '{print "89", $0}' "89 transport_car.txt" >> concept.txt
awk '{print  "8", $0}' "8 weather_cloudysky.txt" >> concept.txt
awk '{print "90", $0}' "90 transport_truckbus.txt" >> concept.txt
awk '{print "91", $0}' "91 transport_rail.txt" >> concept.txt
awk '{print "92", $0}' "92 transport_water.txt" >> concept.txt
awk '{print "93", $0}' "93 transport_air.txt" >> concept.txt
awk '{print  "9", $0}' "9 weather_rainbow.txt" >> concept.txt
sed -i 's/\ /,/g' concept.txt
