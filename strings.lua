function data()
	return {
		en = {
			["DESC"] = [[
				A freestyle train station. It introduces some new special tracks, which will serve as platforms for cargo or passengers.
				Lay them alongside normal tracks, then place two platform markers and two track markers where you want the station to end. Now click your station to open the configuration menu and add some street access.
				
				Platforms must be connected to roads, as usual. In particular:
				- Underground stations require stairs or underpasses in each platform and at least one subway entrance placed nearby, connected to a road.
				- Elevated stations require lifts or underpasses in each platform. At least one lift must be connected to a road.
				- Ground stations require street access or underpasses in each platform.
				In all cases, adjacent platforms are connected together automatically.

				When you delete a freestyle station or one of its terminals, it will try to rebuild the tracks as they were before, to make changes easy: bulldoze a terminal, change what you need, then rebuild it.
				
				[h1]Some handy tips:[/h1]
				- To visualise the lanes, start the game in debug mode and press <AltGr> + <L>.
				- Very thin paths help with certain setups: those are in my street fine-tuning mod.
				- Sound effects for stations are in my dedicated mod.
				- Sound effects for trains are in my dedicated mod.
				- Extra ground textures are in my terrain tweak mod.
				- This mod adds extra bridges (modern era only) to help with elevated stations.

				[h1]Known issues:[/h1]
				- Module placement is rather free, the player is allowed to do some unrealistic things.
				- If you want large buildings, use assets. There are mods for those.
				- Station naming does not work properly.
				- For now, it's only modern era.
				- Upgrading tracks works poorly.
			]],
			["NAME"] = "Freestyle train station EXPERIMENTAL",

			["FlatCargoRampSmoothName"] = "Smooth cargo ramp",
			["FlatCargoRampSmoothDesc"] = "Smooth cargo ramp leading outside, 2 m. Adjust its height with <m> and <n>.",
			["FlatCargoRampSteepName"] = "Steep cargo ramp",
			["FlatCargoRampSteepDesc"] = "Steep cargo ramp leading outside, 2 m. Adjust its height with <m> and <n>.",
			["FlatPassengerStairsSmoothName"] = "Smooth passenger stairs",
			["FlatPassengerStairsSmoothDesc"] = "Smooth passenger stairs leading outside, 2 m. Adjust their height with <m> and <n>.",
			["FlatPassengerStairsSteepName"] = "Steep passenger stairs",
			["FlatPassengerStairsSteepDesc"] = "Steep passenger stairs leading outside, 2 m. Adjust their height with <m> and <n>.",
			["FlatCargoArea5x5Name"] = "5x5 flat side area with stairs, cargo",
			["FlatCargoArea5x5Desc"] = "Flat side area with stairs leading outside, 5x5 m, cargo style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatCargoArea8x5Name"] = "8x5 flat side area with stairs, cargo",
			["FlatCargoArea8x5Desc"] = "Flat side area with stairs leading outside, 8x5 m, cargo style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatCargoArea8x10Name"] = "8x10 flat side area with stairs, cargo",
			["FlatCargoArea8x10Desc"] = "Flat side area with stairs leading outside, 8x10 m, cargo style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatCargoStation8x10Name"] = "8x10 cargo station",
			["FlatCargoStation8x10Desc"] = "8x10 cargo station. Adjust its height with <m> and <n>.",
			["FlatPassengerArea5x5Name"] = "5x5 flat side area with stairs, passenger",
			["FlatPassengerArea5x5Desc"] = "Flat side area with stairs leading outside, 5x5 m, passenger style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatPassengerArea8x5Name"] = "8x5 flat side area with stairs, passenger",
			["FlatPassengerArea8x5Desc"] = "Flat side area with stairs leading outside, 8x5 m, passenger style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatPassengerArea8x10Name"] = "8x10 flat side area with stairs, passenger",
			["FlatPassengerArea8x10Desc"] = "Flat side area with stairs leading outside, 8x10 m, passenger style. Good for plopping assets. Adjust its height with <m> and <n>.",
			["FlatPassengerStation0MName"] = "Small passenger station",
			["FlatPassengerStation0MDesc"] = "Small passenger station",
			["FlatPassengerStation5MName"] = "Small passenger station, 5 m high",
			["FlatPassengerStation5MDesc"] = "Small passenger station, to access a platform a bit higher than the road",
			["PassengerSideLiftName"] = "Passenger lift to a bridge side",
			["PassengerSideLiftDesc"] = "Passenger lift to access a platform on a bridge, from the side. It does not connect to underpasses. Max height 40 m.",
			["PassengerPlatformLiftName"] = "Passenger lift to a bridge",
			["PassengerPlatformLiftDesc"] = "Passenger lift to access a platform on a bridge, from below. It connects to underpasses. Max height 40 m.",
			["PassengerStationSquareName"] = "Station square",
			["PassengerStationSquareDesc"] = "Square between passenger stations and the road",
			["PassengerStationSquarePlainName"] = "Plain station square",
			["PassengerStationSquarePlainDesc"] = "Plain square between passenger stations and the road",
			["PlatformRoofConcreteName"] = "Concrete platform roof",
			["PlatformRoofConcreteDesc"] = "Concrete roof for passenger platforms",
			["PlatformRoofMetalGlassName"] = "Glass platform roof",
			["PlatformRoofMetalGlassDesc"] = "Glass roof for passenger platforms",
			["SlopedCargoArea1x5Name"] = "5 m platform extension, cargo style",
			["SlopedCargoArea1x5Desc"] = "Platform extension, 5 m, cargo style. Good for plopping assets.",
			["SlopedCargoArea1x10Name"] = "10 m platform extension, cargo style",
			["SlopedCargoArea1x10Desc"] = "Platform extension, 10 m, cargo style. Good for plopping assets.",
			["SlopedCargoArea1x20Name"] = "20 m platform extension, cargo style",
			["SlopedCargoArea1x20Desc"] = "Platform extension, 20 m, cargo style. Good for plopping assets.",
			["SlopedCargoAreaWaiting1x5Name"] = "5 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x5Desc"] = "Platform extension, 5 m. It holds extra cargo.",
			["SlopedCargoAreaWaiting1x10Name"] = "10 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x10Desc"] = "Platform extension, 10 m. It holds extra cargo.",
			["SlopedCargoAreaWaiting1x20Name"] = "20 m platform extension, to hold extra cargo",
			["SlopedCargoAreaWaiting1x20Desc"] = "Platform extension, 20 m. It holds extra cargo.",
			["SlopedPassengerArea1x5Name"] = "5 m platform extension, passenger style",
			["SlopedPassengerArea1x5Desc"] = "Platform extension, 5 m, passenger style. Good for plopping assets.",
			["SlopedPassengerArea1x10Name"] = "10 m platform extension, passenger style",
			["SlopedPassengerArea1x10Desc"] = "Platform extension, 10 m, passenger style. Good for plopping assets.",
			["SlopedPassengerArea1x20Name"] = "20 m platform extension, passenger style",
			["SlopedPassengerArea1x20Desc"] = "Platform extension, 20 m, passenger style. Good for plopping assets.",
			["Stairs2SubwayName"] = "Subway stairs",
			["Stairs2SubwayDesc"] = "Plop these on underground passenger platforms, to connect them to the subways and the other terminals.",
			["SubwayDesc"] = "Subway to underground station",
			["SubwayName"] = "Plop these near a station and join them with the popup. Make sure your station has underpasses and / or subway stairs.",
			["UnderpassName"] = "Underpass",
			["UnderpassDesc"] = "Plop these on passenger platforms, to connect them to the subways and the other terminals.",

			["CargoPlatform5MTracksName"] = "5 m cargo platform",
			["CargoPlatform5MTracksDesc"] = "Cargo platforms to be laid as tracks, 5 m wide. They are in fact slow train tracks; they are not meant to be crossed.",
			["CargoPlatform10MTracksName"] = "10 m cargo platform",
			["CargoPlatform10MTracksDesc"] = "Cargo platforms to be laid as tracks, 10 m wide. They are in fact slow train tracks; they are not meant to be crossed.",
			["CargoPlatform20MTracksName"] = "20 m cargo platform",
			["CargoPlatform20MTracksDesc"] = "Cargo platforms to be laid as tracks, 20 m wide. They are in fact slow train tracks; they are not meant to be crossed.",
			["LolloFreestyleTrainStationName"] = "Freestyle train station",
			["LolloFreestyleTrainStationDesc"] = "Freestyle train station",
			["PlatformWaypointName"] = "Platform end marker",
			["PlatformWaypointDesc"] = "Marks the ends of a platform that will become part of a freestyle station. The direction does not matter.",
			["PassengerPlatform5MTracksName"] = "5 m passenger platform",
			["PassengerPlatform5MTracksDesc"] = "Passenger platforms to be laid as tracks, 5 m wide. Use them with tunnels or bridges. They are in fact slow train tracks; they are not meant to be crossed.",
			["PassengerPlatform2_5MTracksName"] = "2.5 m passenger platform",
			["PassengerPlatform2_5MTracksDesc"] = "Passenger platforms to be laid as tracks, 2.5 m wide. The best choice for stations on ground. They are in fact slow train tracks; they are not meant to be crossed.",
			["TrackWaypointName"] = "Track End Marker",
			["TrackWaypointDesc"] = "Marks the ends of a track that will become part of a freestyle station. The direction does not matter.",

			["CementBridgeNoPillars"] = "Concrete Bridge with no pillars",
			["CementBridgeNormalPillars"] = "Concrete Bridge",
			["CementBridgeSpacedPillars"] = "Concrete Bridge with spaced pillars",
			["CementBridgeNoPillarsNoSides"] = "Concrete Bridge with no pillars and low railing",
			["CementBridgeNormalPillarsNoSides"] = "Concrete Bridge with low railing",
			["CementBridgeSpacedPillarsNoSides"] = "Concrete Bridge with spaced pillars and low railing",

			["NewStationName"] = "New Station",

			["cargo-platform-extensions"] = "Cargo extensions",
			["cargo-platform-tracks"] = "Cargo platforms to be laid as tracks",
			["cargo-road-access"] = "Cargo road access",
			["passenger-platform-extensions"] = "Passenger extensions",
			["passenger-platform-roofs"] = "Platform roofs",
			["passenger-platform-tracks"] = "Passenger platforms to be laid as tracks",
			["passenger-road-access"] = "Passenger road access",
			["passenger-up-and-down"] = "Up and down",

			["BuildMoreWaypoints"] = "Plop two track markers and two platform markers to build a freestyle station",
			["DifferentPlatformWidths"] = "Avoid different track widths with cargo stations",
			["GoBack"] = "Go back",
			["GoThere"] = "Go there",
			["Join"] = "Join",
			["NoJoin"] = "Do not join",
			["StationPickerWindowTitle"] = "Pick a station to join",
			["SubwayCannotConnect"] = "Add stairs or underpasses to connect this subway",
			["SubwayNotConnected"] = "Join this subway to a station",
			["TrackWaypointBuiltOnPlatform"] = "You can only build track markers on tracks and platform markers on platforms",
			["TrackWaypointsMissing"] = "Build two track markers first",
			["WarningWindowTitle"] = "Warning",
			["WaypointAlreadyBuilt"] = "You can only build two markers",
			["WaypointsCrossStation"] = "You cannot cross an existing station",
			["WaypointsNotConnected"] = "This markers is not connected to its twin",
			["WaypointsTooFar"] = "Too far from its twin",
		},
	}
end
