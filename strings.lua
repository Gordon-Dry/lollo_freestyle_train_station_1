function data()
	-- local _constants = require('lollo_freestyle_train_station.constants') -- this won't work
	return {
		en = {
			["DESC"] = [[
				A freestyle train station. It introduces some new special tracks, which will serve as platforms for cargo or passengers.

                [h1]Instructions[/h1]
				Lay platforms alongside normal tracks, then place a platform marker and a track marker where you want the platform and the track to end. Repeat at the other end.
				WAIT A MOMENT and let the computer think.
                Now you have built a terminal, trains will stop between your track markers.
                Add more platforms, tracks and markers, a popup will ask you if you want to join your new terminal to the other ones. You can have up to 12 terminals in one station.

                Now click your station to open the configuration menu and add some connections.
                - Adjacent platforms are connected together automatically. If you added extra platforms or space between, you will have to connect them by hand instead: use a suitable street type and <shift>. Avoid this with tunnels and bridges, keep it simple.
                - Every set of adjacent ground platforms requires street access, an underpass, a lift or stairs.
                - Every set of adjacent bridge platforms requires a lift or an underpass.
                - Every bridge level requires a lift, or an underpass near a ground platform lift or stairs.
                - Every set of adjacent underground platforms requires stairs.
                - Every underground level requires an underground entrance, or a ground platform with an underpass, or a higher underground level with stairs down (if you have multiple underground levels, you can add stairs on the higher levels, to go down to the lower levels).

                You can share a platform between two terminals, for example the first 100 metres with terminal 1 and the rest with terminal 2. If you do that, connect the platform ends by hand with a suitable street type and <shift>.
                You cannot share one stretch of platform among multiple terminals.

				When you bulldoze a terminal, the mod will try to rebuild the tracks as they were before, to make changes easy: bulldoze a terminal, change what you need, then rebuild it with the markers.
				When you bulldoze the station, everything will be bulldozed.

				Lifts, stairs and underground entrances are in the assets, search for "freestyle station".
				
				[h1]Tips:[/h1]
                - Platforms are tracks and they can also suffer from micro splits, very difficult to see.
				- To visualise the lanes and the splits, start the game in debug mode and press <AltGr> + <L>. This is particularly useful with multi-level underground stations.
				- To work underground, use <NumPad 4> or the 'Look Underground' track construction.
				- Platforms only carry passengers or cargo if they are part of a terminal.
				- 2.5 m platforms do not agree with bridges and tunnels. My 'no railing' bridges help, tunnels can't be helped.
                - This mod adds extra bridges to help with elevated stations.
                - Very thin paths help with certain setups: those are in my street fine tuning mod.
				- This mod adds extra pedestrian paths and bridges. Some of those paths turn into bridges after placing them. They can be tricky to place, the street fine tuning 'chunks' and 'splitter' constructions come to the rescue.
				- Sound effects for stations are in my dedicated mod.
				- Sound effects for trains are in my dedicated mod.
				- Extra ground textures are in my terrain tweaks mod.
				- If you want different buildings, use assets. There are mods with those.
				- This mod adds stairs and lifts as configurable assets; they can be used anywhere. My 'Construction Mover' mod helps to place them easily.
				- Use the track constructions "Smart track splitter" to do precision work.
				- Upgrading tracks does all tracks at once.
				- If you have too many track types, use the categories in the menu to make life easier.

				[h1]Note:[/h1]
				Underground stations are now in the assets.

				[h1]Known issues:[/h1]
				- Module placement is rather free, the player is allowed to do some unrealistic things. Proper checks would be too expensive.
				- Station naming does not work properly.
				- 2.5 m platforms do not agree with bridges and tunnels. Ask UG to make trackDistance work.
				- The bigger your station is, the longer it takes to add or remove a terminal. It can take over a minute. Just wait.
				- Some track and signal mods are incompatible.
			]],
			["NAME"] = "Freestyle train station",

			["CargoStationSquarePlainName"] = "Plain station square",
			["CargoStationSquarePlainDesc"] = "Plain square between cargo stations and the road. Repaint its ground with <shift> and a paint tool.",
			["FlatCargoRampDownSmoothName"] = "Smooth cargo ramp down",
			["FlatCargoRampDownSmoothDesc"] = "Smooth cargo ramp leading outside and down, 2 m. Adjust its height with <m> and <n>.",
			["FlatCargoRampDownSteepName"] = "Steep cargo ramp down",
			["FlatCargoRampDownSteepDesc"] = "Steep cargo ramp leading outside and down, 2 m. Adjust its height with <m> and <n>.",
			["FlatCargoRampFlatName"] = "Cargo exit",
			["FlatCargoRampFlatDesc"] = "Cargo exit, 2 m. Adjust its height with <m> and <n>.",
			["FlatPassengerStairsDownSmoothName"] = "Smooth passenger stairs down",
			["FlatPassengerStairsDownSmoothDesc"] = "Smooth passenger stairs leading outside and down, 2 m. Adjust their height with <m> and <n>.",
			["FlatPassengerStairsDownSteepName"] = "Steep passenger stairs down",
			["FlatPassengerStairsDownSteepDesc"] = "Steep passenger stairs leading outside and down, 2 m. Adjust their height with <m> and <n>.",
			["FlatPassengerStairsEdgeName"] = "Entrance to platform with auto bridge",
			["FlatPassengerStairsEdgeDesc"] = "Connects platforms to the road network. Adjust its height with <m> and <n>. Link it to \"stairs\" assets, bridges or paths as required. It will become snappy at the next config update.",
			["FlatPassengerStairsSnappyEdgeName"] = "Entrance to platform with snappy auto bridge",
			["FlatPassengerStairsSnappyEdgeDesc"] = "Connects platforms to the road network. Adjust its height with <m> and <n>. Link it to \"stairs\" assets, bridges or paths as required.",
			["FlatPassengerStairsFlatName"] = "Flat passenger exit",
			["FlatPassengerStairsFlatDesc"] = "Flat passenger exit, 2 m. Adjust its height with <m> and <n>.",
			["FlatCargoRampUpSmoothName"] = "Smooth cargo ramp up",
			["FlatCargoRampUpSmoothDesc"] = "Smooth cargo ramp leading outside and up, 2 m. Adjust its height with <m> and <n>.",
			["FlatCargoRampUpSteepName"] = "Steep cargo ramp up",
			["FlatCargoRampUpSteepDesc"] = "Steep cargo ramp leading outside and up, 2 m. Adjust its height with <m> and <n>.",
			["FlatPassengerStairsUpSmoothName"] = "Smooth passenger stairs up",
			["FlatPassengerStairsUpSmoothDesc"] = "Smooth passenger stairs leading outside and up, 2 m. Adjust their height with <m> and <n>.",
			["FlatPassengerStairsUpSteepName"] = "Steep passenger stairs up",
			["FlatPassengerStairsUpSteepDesc"] = "Steep passenger stairs leading outside and up, 2 m. Adjust their height with <m> and <n>.",
			["FlatCargoArea5x5Name"] = "5x5 flat side area with ramp, cargo",
			["FlatCargoArea5x5Desc"] = "Flat side area with ramp leading outside, 5x5 m, cargo style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatCargoArea8x5Name"] = "8x5 flat side area with ramp, cargo",
			["FlatCargoArea8x5Desc"] = "Flat side area with ramp leading outside, 8x5 m, cargo style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatCargoArea8x10Name"] = "8x10 flat side area with ramp, cargo",
			["FlatCargoArea8x10Desc"] = "Flat side area with ramp leading outside, 8x10 m, cargo style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatCargoStation8x10Name"] = "8x10 cargo station",
			["FlatCargoStation8x10Desc"] = "8x10 cargo station. Adjust its height with <m> and <n>.",
			["FlatCargoStation8x15Name"] = "8x15 cargo station",
			["FlatCargoStation8x15Desc"] = "8x15 cargo station. Adjust its height with <m> and <n>.",
			["FlatCargoStationLower8x10Name"] = "8x10 lower cargo station",
			["FlatCargoStationLower8x10Desc"] = "8x10 lower cargo station. Adjust its height with <m> and <n>. Repaint its ground with <shift> and a paint tool.",
			["FlatPassengerArea5x5Name"] = "5x5 flat side area with stairs, passenger",
			["FlatPassengerArea5x5Desc"] = "Flat side area with stairs leading outside, 5x5 m, passenger style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatPassengerArea8x5Name"] = "8x5 flat side area with stairs, passenger",
			["FlatPassengerArea8x5Desc"] = "Flat side area with stairs leading outside, 8x5 m, passenger style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatPassengerArea8x10Name"] = "8x10 flat side area with stairs, passenger",
			["FlatPassengerArea8x10Desc"] = "Flat side area with stairs leading outside, 8x10 m, passenger style. Good for plopping assets on. Adjust its height with <m> and <n>.",
			["FlatPassengerStation0MName"] = "Small slick passenger station",
			["FlatPassengerStation0MDesc"] = "Small slick passenger station.",
			["FlatPassengerStationSmallName"] = "Small ornate passenger station",
			["FlatPassengerStationSmallDesc"] = "Small ornate passenger station",
			["FlatPassengerStationMidName"] = "Ornate passenger station",
			["FlatPassengerStationMidDesc"] = "Ornate passenger station",
			["FlatPassengerStationLargeName"] = "Ornate passenger station",
			["FlatPassengerStationLargeDesc"] = "Ornate passenger station",
			["FlatPassengerStation5MName"] = "Small passenger station, 5 m high",
			["FlatPassengerStation5MDesc"] = "Small passenger station, to access a platform a bit higher than the road. Repaint its ground with <shift> and a paint tool.",
			["LookUndergroundName"] = "Look Underground",
			["LookUndergroundDesc"] = "Hover or build this to look underground, remove it when done.",
			["OpenLiftName"] = "Lift up for ground platform",
			["OpenLiftDesc"] = "Connects ground passenger platforms to their twins, to nearby bridge underpasses or, if you add an exit, to the road network.",
            ["OpenStairsUpLeftName"] = "Stairs up left for ground platform",
			["OpenStairsUpLeftDesc"] = "Connects ground passenger platforms to their twins, to nearby bridge underpasses or, if you add an exit, to the road network.",
			["OpenStairsUpRightName"] = "Stairs up right for ground platform",
			["OpenStairsUpRightDesc"] = "Connects ground passenger platforms to their twins, to nearby bridge underpasses or, if you add an exit, to the road network.",
			["OpenStairsExitWithEdgeName_2m"] = "Entrance to stairs with auto bridge",
			["OpenStairsExitWithSnappyEdgeName_2m"] = "Entrance to stairs with snappy auto bridge",
            ["OpenStairsExitName_4m"] = "Entrance to stairs, 4 m",
			["OpenStairsExitName_8m"] = "Entrance to stairs, 8 m",
			["OpenStairsExitName_16m"] = "Entrance to stairs, 16 m",
			["OpenStairsExitName_32m"] = "Entrance to stairs, 32 m",
			["OpenStairsExitName_64m"] = "Entrance to stairs, 64 m",
            ["OpenStairsExitDesc"] = "Connects stairs and lifts to the outside. Adjust its tilt with <m> and <n>. Link it to \"stairs\" assets if required.",
			["OpenStairsExitWithEdgeDesc"] = "Connects stairs and lifts to the road network. Adjust its tilt with <m> and <n>. Link it to \"stairs\" assets, bridges or paths as required. It will become snappy at the next config update.",
			["OpenStairsExitWithSnappyEdgeDesc"] = "Connects stairs and lifts to the road network. Adjust its tilt with <m> and <n>. Link it to \"stairs\" assets, bridges or paths as required.",
			["PassengerSideLiftName"] = "Passenger lift to a bridge side",
			["PassengerSideLiftDesc"] = "Passenger lift to access a platform on a bridge, from the side. It connects to bridge underpasses and other lifts if they are close enough. Max height 40 m, adjust it with <m> and <n>. Repaint its ground with <shift> and a paint tool.",
			["PassengerPlatformLiftName"] = "Passenger lift to a bridge",
			["PassengerPlatformLiftDesc"] = "Passenger lift to access a platform on a bridge, from below. It connects to bridge underpasses and other lifts if they are close enough. Max height 40 m, adjust it with <m> and <n>. Repaint its ground with <shift> and a paint tool.",
			["PassengerStationSquareName"] = "Station square",
			["PassengerStationSquareDesc"] = "Square between passenger stations and the road. Adjust its height with <m> and <n>. Repaint its ground with <shift> and a paint tool.",
			["PassengerStationSquarePlainName"] = "Plain station square",
			["PassengerStationSquarePlainDesc"] = "Plain square between passenger stations and the road. Adjust its height with <m> and <n>. Repaint its ground with <shift> and a paint tool.",
			["PlatformEraASwitcherName"] = "Switch platform to era A",
			["PlatformEraASwitcherDesc"] = "Switch a platform to era A style",
			["PlatformEraBSwitcherName"] = "Switch platform to era B",
			["PlatformEraBSwitcherDesc"] = "Switch a platform to era B style",
			["PlatformEraCSwitcherName"] = "Switch platform to era C",
			["PlatformEraCSwitcherDesc"] = "Switch a platform to era C style",
			["PlatformRoofConcreteName"] = "Concrete platform roof with tendons",
			["PlatformRoofConcreteDesc"] = "Concrete roof with tendons for passenger platforms",
			["PlatformRoofConcretePlainName"] = "Concrete platform roof, plain",
			["PlatformRoofConcretePlainDesc"] = "Concrete roof for passenger platforms",
			["PlatformRoofIronName"] = "Iron roof",
			["PlatformRoofIronDesc"] = "Iron roof for passenger platforms",
			["PlatformRoofIronGlassAluName"] = "Iron and glass roof",
			["PlatformRoofIronGlassAluDesc"] = "Iron and glass roof for passenger platforms",
			["PlatformRoofMetalGlassName"] = "Glass platform roof",
			["PlatformRoofMetalGlassDesc"] = "Glass roof for passenger platforms",
			["SlopedCargoArea1x5Name"] = "5 m platform extension, cargo style",
			["SlopedCargoArea1x5Desc"] = "Platform extension, 5 m, cargo style. Good for plopping assets on.",
			["SlopedCargoArea1x10Name"] = "10 m platform extension, cargo style",
			["SlopedCargoArea1x10Desc"] = "Platform extension, 10 m, cargo style. Good for plopping assets on.",
			["SlopedCargoArea1x20Name"] = "20 m platform extension, cargo style",
			["SlopedCargoArea1x20Desc"] = "Platform extension, 20 m, cargo style. Good for plopping assets on.",
			["SlopedCargoAreaWaiting1x5Name"] = "5 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x5Desc"] = "Platform extension, 5 m. It holds extra cargo.",
			["SlopedCargoAreaWaiting1x10Name"] = "10 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x10Desc"] = "Platform extension, 10 m. It holds extra cargo.",
			["SlopedCargoAreaWaiting1x20Name"] = "20 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x20Desc"] = "Platform extension, 20 m. It holds extra cargo.",
			["SlopedPassengerArea1x2_5Name"] = "2.5 m platform extension, passenger style",
			["SlopedPassengerArea1x2_5Desc"] = "Platform extension, 2.5 m, passenger style. Good for plopping assets on.",
			["SlopedPassengerArea1x5Name"] = "5 m platform extension, passenger style",
			["SlopedPassengerArea1x5Desc"] = "Platform extension, 5 m, passenger style. Good for plopping assets on.",
			["SlopedPassengerArea1x10Name"] = "10 m platform extension, passenger style",
			["SlopedPassengerArea1x10Desc"] = "Platform extension, 10 m, passenger style. Good for plopping assets on.",
			["SlopedPassengerArea1x20Name"] = "20 m platform extension, passenger style",
			["SlopedPassengerArea1x20Desc"] = "Platform extension, 20 m, passenger style. Good for plopping assets on.",
			["SlopedPassengerAreaWaiting1x2_5Name"] = "2.5 m platform extension, to hold extra passengers",
			["SlopedPassengerAreaWaiting1x2_5Desc"] = "Platform extension, 2.5 m. It holds extra passengers.",
			["SlopedPassengerAreaWaiting1x5Name"] = "5 m platform extension, to hold extra passengers",
			["SlopedPassengerAreaWaiting1x5Desc"] = "Platform extension, 5 m. It holds extra passengers.",
			["SlopedPassengerAreaWaiting1x10Name"] = "10 m platform extension, to hold extra passengers",
			["SlopedPassengerAreaWaiting1x10Desc"] = "Platform extension, 10 m. It holds extra passengers.",
			["SlopedPassengerAreaWaiting1x20Name"] = "20 m platform extension, to hold extra passengers",
			["SlopedPassengerAreaWaiting1x20Desc"] = "Platform extension, 20 m. It holds extra passengers.",
			["SubwayName"] = "Underground entrance",
			["SubwayDesc"] = "Plop these near a freestyle station and join them with the popup. Make sure your station has underpasses and / or subway stairs.",
			["TrackCrossingName"] = "Track crossing",
			["TrackCrossingDesc"] = "Track crossing. It can connect pedestrian traffic to the road network.",
			["TunnelStairsUpName"] = "Subway stairs up",
			["TunnelStairsUpDesc"] = "Connects underground passenger platforms to the subway entrances and the other terminals above.",
			["TunnelStairsUpDownName"] = "Subway stairs up and down",
			["TunnelStairsUpDownDesc"] = "Connects underground passenger platforms to the subway entrances and the other terminals above and below.",
			["UndergroundName"] = "Underground Station",
			["UnderpassName"] = "Covered Underpass",
			["UnderpassDesc"] = "When on the ground, it connects passenger platforms to subway entrances, lifts to bridges and other ground underpasses. When on a bridge instead, it connects to lifts to bridges, other bridge underpasses, platform stairs and lifts that are close enough.",
			["UnderpassStairsName"] = "Underpass",
			["UnderpassStairsDesc"] = "When on the ground, it connects passenger platforms to subway entrances, lifts to bridges and other ground underpasses. When on a bridge instead, it connects to lifts to bridges, other bridge underpasses, platform stairs and lifts that are close enough.",
			["WallConcretePlainName"] = "Concrete platform wall",
			["WallConcretePlainDesc"] = "Concrete wall for passenger platforms, also suitable for tunnels",
			["WallConcretePlainWRoofName"] = "Concrete platform wall and roof",
			["WallConcretePlainWRoofDesc"] = "Concrete wall and roof for passenger platforms, also suitable for tunnels",
			["WallTiledName"] = "Tiled platform wall",
			["WallTiledDesc"] = "Tiled wall for passenger platforms, also suitable for tunnels",
			["WallTiledWRoofName"] = "Tiled platform wall and roof",
			["WallTiledWRoofDesc"] = "Tiled wall and roof for passenger platforms, also suitable for tunnels",
			["EraACargoPlatform5MName"] = "5 m cargo platform, era A",
			["EraACargoPlatform5MDesc"] = "Cargo platforms to be laid as tracks, 5 m wide, era A. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraACargoPlatform10MName"] = "10 m cargo platform, era A",
			["EraACargoPlatform10MDesc"] = "Cargo platforms to be laid as tracks, 10 m wide, era A. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraACargoPlatform20MName"] = "20 m cargo platform, era A",
			["EraACargoPlatform20MDesc"] = "Cargo platforms to be laid as tracks, 20 m wide, era A. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraBCargoPlatform5MName"] = "5 m cargo platform, era B",
			["EraBCargoPlatform5MDesc"] = "Cargo platforms to be laid as tracks, 5 m wide, era B. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraBCargoPlatform10MName"] = "10 m cargo platform, era B",
			["EraBCargoPlatform10MDesc"] = "Cargo platforms to be laid as tracks, 10 m wide, era B. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraBCargoPlatform20MName"] = "20 m cargo platform, era B",
			["EraBCargoPlatform20MDesc"] = "Cargo platforms to be laid as tracks, 20 m wide, era B. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraCCargoPlatform5MName"] = "5 m cargo platform, era C",
			["EraCCargoPlatform5MDesc"] = "Cargo platforms to be laid as tracks, 5 m wide, era C. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraCCargoPlatform10MName"] = "10 m cargo platform, era C",
			["EraCCargoPlatform10MDesc"] = "Cargo platforms to be laid as tracks, 10 m wide, era C. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraCCargoPlatform20MName"] = "20 m cargo platform, era C",
			["EraCCargoPlatform20MDesc"] = "Cargo platforms to be laid as tracks, 20 m wide, era C. They are in fact slow train tracks; they are not meant to be crossed.",
			["LolloFreestyleTrainStationName"] = "Freestyle train station",
			["LolloFreestyleTrainStationDesc"] = "Freestyle train station",
			["PlatformWaypointName"] = "Platform end marker",
			["PlatformWaypointDesc"] = "Marks the ends of a platform that will become part of a freestyle station. The direction does not matter.",
			["EraAPassengerPlatform5MName"] = "5 m passenger platform, era A",
			["EraAPassengerPlatform5MDesc"] = "Passenger platforms to be laid as tracks, 5 m wide, era A. Use them with tunnels or bridges. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraAPassengerPlatform2_5MName"] = "2.5 m passenger platform, era A",
			["EraAPassengerPlatform2_5MDesc"] = "Passenger platforms to be laid as tracks, 2.5 m wide, era A. The best choice for stations on ground. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraBPassengerPlatform5MName"] = "5 m passenger platform, era B",
			["EraBPassengerPlatform5MDesc"] = "Passenger platforms to be laid as tracks, 5 m wide, era B. Use them with tunnels or bridges. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraBPassengerPlatform2_5MName"] = "2.5 m passenger platform, era B",
			["EraBPassengerPlatform2_5MDesc"] = "Passenger platforms to be laid as tracks, 2.5 m wide, era B. The best choice for stations on ground. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraCPassengerPlatform5MName"] = "5 m passenger platform, era C",
			["EraCPassengerPlatform5MDesc"] = "Passenger platforms to be laid as tracks, 5 m wide, era C. Use them with tunnels or bridges. They are in fact slow train tracks; they are not meant to be crossed.",
			["EraCPassengerPlatform2_5MName"] = "2.5 m passenger platform, era C",
			["EraCPassengerPlatform2_5MDesc"] = "Passenger platforms to be laid as tracks, 2.5 m wide, era C. The best choice for stations on ground. They are in fact slow train tracks; they are not meant to be crossed.",
			["TrackWaypointName"] = "Track End Marker",
			["TrackWaypointDesc"] = "Marks the ends of a track that will become part of a freestyle station. The direction does not matter. Close semaphores can interfere, you may want to remove them and put them back once the station is laid out.",

			["CementBridgeGlassWallNoPillars"] = "Concrete bridge with underpasses, glass shields and no pillars. Only for 5 m platforms.",
			["CementBridgeGlassWallNormalPillars"] = "Concrete bridge with underpasses and glass shields. Only for 5 m platforms.",
			["CementBridgeGlassWallSpacedPillars"] = "Concrete bridge with underpasses, glass shields and spaced pillars. Only for 5 m platforms.",
			["CementBridgeNoPillarsNoSides"] = "Concrete bridge with no pillars and no railing",
			["CementBridgeNormalPillarsNoSides"] = "Concrete bridge with no railing",
			["CementBridgeSpacedPillarsNoSides"] = "Concrete bridge with spaced pillars and no railing",
			["IronBridgeNoPillarsNoSides"] = "Iron bridge with no pillars and no railing",
			["IronBridgeNormalPillarsNoSides"] = "Iron bridge with no railing",
			["IronBridgeSpacedPillarsNoSides"] = "Iron bridge with spaced pillars and no railing",
			["PedestrianCementBridgeNoPillars"] = "Concrete bridge with no pillars. For pedestrian paths",
			["PedestrianCementBridgeNoPillarsNoSides"] = "Concrete bridge with no pillars and no railing. For pedestrian paths",
			-- these won't work
			-- ["PedestrianBasicBridgeNoPillars" .. _constants.eras.era_a.prefix] = "Era A bridge with no pillars, for pedestrian paths",
			-- ["PedestrianBasicBridgeNoPillarsNoSides" .. _constants.eras.era_a.prefix] = "Era A bridge with no pillars and no railing, for pedestrian paths",
			-- ["PedestrianBasicBridgeNoPillars" .. _constants.eras.era_b.prefix] = "Era B bridge with no pillars, for pedestrian paths",
			-- ["PedestrianBasicBridgeNoPillarsNoSides" .. _constants.eras.era_b.prefix] = "Era B bridge with no pillars and no railing, for pedestrian paths",
			-- ["PedestrianBasicBridgeNoPillars" .. _constants.eras.era_c.prefix] = "Era C bridge with no pillars, for pedestrian paths",
			-- ["PedestrianBasicBridgeNoPillarsNoSides" .. _constants.eras.era_c.prefix] = "Era C bridge with no pillars and no railing, for pedestrian paths",
			["era_a_PedestrianBasicBridgeNoPillars"] = "Era A bridge with no pillars, for pedestrian paths",
			["era_a_PedestrianBasicBridgeNoPillarsNoSides"] = "Era A bridge with no pillars and no railing, for pedestrian paths and 2.5 m platforms",
			["era_b_PedestrianBasicBridgeNoPillars"] = "Era B bridge with no pillars, for pedestrian paths",
			["era_b_PedestrianBasicBridgeNoPillarsNoSides"] = "Era B bridge with no pillars and no railing, for pedestrian paths and 2.5 m platforms",
			["era_c_PedestrianBasicBridgeNoPillars"] = "Era C bridge with no pillars, for pedestrian paths",
			["era_c_PedestrianBasicBridgeNoPillarsNoSides"] = "Era C bridge with no pillars and no railing, for pedestrian paths and 2.5 m platforms",

			["NewStationName"] = "New Station",

			-- categories
			["cargo-platform-extensions"] = "Cargo extensions",
			["cargo-platform-tracks"] = "Cargo platforms to be laid as tracks",
			["cargo-road-access"] = "Cargo -> road",
			["deco"] = "Deco",
            ["passenger-platform-extensions"] = "Passenger extensions",
			["passenger-platform-tracks"] = "Passenger platforms to be laid as tracks",
			["passenger-road-access"] = "Passengers -> road",
			["passenger-road-access-stairs"] = "Stairs -> road",
			["passenger-up-and-down"] = "Up and down",
			["train-tracks"] = "Train tracks",
			["waypoints-for-freestyle-station"] = "Waypoints For Freestyle Stations",

			["BuildMoreWaypoints"] = "Plop two track markers and two platform markers to build a freestyle station",
			["BuildSnappyTracksFailed"] = "Fix the station connections to the adjacent tracks, the game cannot do it for you this time",
			["DifferentPlatformWidths"] = "Avoid different track widths with cargo stations",
			["GoBack"] = "Go back",
			["GoThere"] = "Go there",
			["Join"] = "Join",
			["NeedAdjust4Snap"] = "Some street connections have unsnapped: make any change to the station configuration to fix this",
			["NoJoin"] = "Do not join",
			["ShowUnderground"] = "Show Underground",
			["ShowUndergroundTooltip"] = "It cannot be changed once plopped. If you want assistance to place it easily, use the 'Look Underground' track construction instead of this.",
			["StationPickerWindowTitle"] = "Pick a station to join",
			["SubwayCannotConnect"] = "Add stairs or underpasses to connect this underground entrance",
			["SubwayNotConnected"] = "Join this underground entrance to a station",
			["TrackWaypointBuiltOnPlatform"] = "You can only build track markers on tracks and platform markers on platforms",
			["TrackWaypointsMissing"] = "Build two track markers first",
			["UndergroundTrainDepotName"] = "Underground Train depot",
			["UndergroundTrainDepotDesc"] = "Used to buy/sell trains. The 'Look Underground' track construction helps to snap it to the track.",
			["WarningWindowTitle"] = "Warning",
			["WaypointAlreadyBuilt"] = "You can only build two markers",
			["WaypointsCrossCrossing"] = "There is a joint between this marker and its twin",
			["WaypointsCrossSignal"] = "There is a semaphore or a waypoint between this marker and its twin, or too close to either",
			["WaypointsCrossStation"] = "You cannot cross an existing station",
			["WaypointDistanceWindowTitle"] = "Air Distance",
			["WaypointsNotConnected"] = "This marker is not connected to its twin, or there is a station / joint / semaphore between, or it is too close to a station / joint / semaphore",
			["WaypointsTooCloseToStation"] = "Too close to an existing station or depot",
			["WaypointsTooFar"] = "Too far from its twin",

			-- free open stairs and free lifts
			["BaseMode"] = "Base Mode",
			["BridgeHeight"] = "Bridge Height",
			["BridgeMode"] = "Bridge Mode",
			["BridgeYAngle"] = "Bridge Tilt",
			["BridgeZAngle"] = "Bridge Rotation",
			["EdgeWithBridge"] = "Auto Bridge",
			["EdgeWithNoBridge"] = "Auto Path",
			["Era"] = "Era",
			["ErrorReplacingConWithSnappyCopy"] = "This object cannot connect to nearby roads, change it or move it somewhere else",
			["FlatSlopedTerrain"] = "Terrain Incline",
			["Model"] = "Platform",
			["NoRailing0"] = "0 - No Railing",
			["OpenLiftFreeDesc"] = "Lift matching the freestyle stations, collision free; use fences or similar mods to fine-tune collisions. Combine this to pedestrian bridges or paths. Place it accurately with the construction mover.",
			["OpenLiftFreeName"] = "Lift",
			["OpenStairsFreeDesc"] = "Stairs matching the freestyle stations, collision free; use fences or similar mods to fine-tune collisions. Combine this to pedestrian bridges or paths. Place it accurately with the construction mover.",
			["OpenStairsFreeHeight"] = "Height",
			["OpenStairsFreeName"] = "Stairs",
			["PedestrianBridges"] = "Pedestrian Bridges",
			["PedestrianPaths"] = "Pedestrian Paths",
			["SimpleConnection"] = "Simple",
			["SnappyEdgeWithBridge"] = "Snappy Bridge",
			["SnappyEdgeWithNoBridge"] = "Snappy Path",
			["Stairs"] = "Stairs, Lifts, Underground Entrances for the Freestyle Train Station",
            ["StairsBase"] = "Expand Base",
			["StairsBaseTooltip"] = "It might be easier to select \"Auto Path\" or \"Auto Bridge\" when building or changing properties and change it to \"Snappy Path\" or \"Snappy Bridge\" once done. Help yourself with AltGr + L.",
			["TerrainAlignmentType"] = "Terrain Alignment",
			["TerrainAlignmentTypeFlat"] = "Flat",
			["TerrainAlignmentTypeSloped"] = "Sloped",
			["TopPlatformLength"] = "Top Platform Length",
			["TopPlatformLengthTooltip"] = "It might be easier to select \"Auto Path\" or \"Auto Bridge\" when building or changing properties and change it to \"Snappy Path\" or \"Snappy Bridge\" once done. Help yourself with AltGr + L.",

			-- track splitter
			["SmartTrackSplitterName"] = "Smart track splitter",
			["SmartTrackSplitterDesc"] = "Splits a track in two sections. Does not work on tracks, which are part of a construction (eg a station). Use AltGr + L to see its effect.",
		},
	}
end
