local arrayUtils = require('lollo_freestyle_train_station/arrayUtils')

local _maxPercentageDeviation4Midpoint = 1.1

local constants = {
    cargoPlatformTracksCategory = 'cargo-platform-tracks',
    invisiblePlatformTracksCategory = 'invisible-platform-tracks',
    passengerPlatformTracksCategory = 'passenger-platform-tracks',

    eventData = {
        eventId = '__lolloFreestyleTrainStation__',
        eventNames = {
            BUILD_SNAPPY_TRACKS_REQUESTED = 'buildSnappyTracksRequested',
            BUILD_STATION_REQUESTED = 'buildStationRequested',
            BULLDOZE_MARKER_REQUESTED = 'bulldozeMarkerRequested',
            BULLDOZE_STATION_REQUESTED = 'bulldozeStationRequested',
            HIDE_HOLE_REQUESTED = 'hideHoleRequested',
            HIDE_WARNINGS = 'hideWarnings',
            PLATFORM_MARKER_BUILT = 'platformMarkerBuilt',
            PLATFORM_WAYPOINT_1_SPLIT_REQUESTED = 'platformWaypoint1SplitRequested',
            PLATFORM_WAYPOINT_2_SPLIT_REQUESTED = 'platformWaypoint2SplitRequested',
            REBUILD_1_TRACK_REQUESTED = 'rebuild1TrackRequested',
            REMOVE_TERMINAL_REQUESTED = 'removeTerminalRequested',
            SUBWAY_JOIN_REQUESTED = 'subwayJoinRequested',
            TRACK_BULLDOZE_REQUESTED = 'trackBulldozeRequested',
            TRACK_WAYPOINT_1_SPLIT_REQUESTED = 'trackWaypoint1SplitRequested',
            TRACK_WAYPOINT_2_SPLIT_REQUESTED = 'trackWaypoint2SplitRequested',
            WAYPOINT_BULLDOZE_REQUESTED = 'waypointBulldozeRequested',
        }
    },

    stairsAndRampHeight = 1.2,
    platformHeight = 1.2,
    platformSideBitsZ = -0.10, -- a bit lower than the platform, to look good in bends
    platformRoofZ = -0.20, -- a bit lower than the platform, to look good on slopes
    underpassZ = -4, -- must be negative and different from the lift heights (5, 10, 15 etc)
    underpassLengthM = 1, -- don't change this, it must stay 1
    tunnelStairsUpZ = 7, -- was 4, which is too little, 7 is barely enough
    subwayPos2LinkX = 4,
    subwayPos2LinkY = 0,
    subwayPos2LinkZ = -4,
    openStairsUpZ = 8,
    trackCrossingZ = 0.45,
    trackCrossingRaise = 0.25,

    maxPercentageDeviation4Midpoint = _maxPercentageDeviation4Midpoint,
    minPercentageDeviation4Midpoint = 1 / _maxPercentageDeviation4Midpoint,

    maxCargoWaitingAreaEdgeLength = 9, -- do not tamper with this
    maxPassengerWaitingAreaEdgeLength = 9, -- do not tamper with this
    railEdgeType = 1, -- 0 = ROAD, 1 = RAIL
    maxNTerminals = 12,
    minSplitDistance = 2,
    maxWaypointDistance = 1020,
    searchRadius4NearbyStation2Join = 500,
    slopeHigh = 999,
    slopeLow = 2.5,

    eras = {
        era_a = { prefix = 'era_a_', startYear = 1850 },
        era_b = { prefix = 'era_b_', startYear = 1920 },
        era_c = { prefix = 'era_c_', startYear = 1980 },
    },

    era_a_groundFacesFillKey = 'lollo_freestyle_train_station/gravel_03_high_priority.lua', -- 'shared/gravel_02.gtex.lua',
    era_b_groundFacesFillKey = 'lollo_freestyle_train_station/asphalt_01_high_priority.lua', -- 'shared/asphalt_01.gtex.lua',
    era_c_groundFacesFillKey = 'lollo_freestyle_train_station/asphalt_02_high_priority.lua', -- 'shared/asphalt_02.gtex.lua',
    era_a_groundFacesStrokeOuterKey = 'lollo_freestyle_train_station/gravel_03_high_priority.lua',
    era_b_groundFacesStrokeOuterKey = 'lollo_freestyle_train_station/asphalt_01_high_priority.lua',
    era_c_groundFacesStrokeOuterKey = 'lollo_freestyle_train_station/asphalt_02_high_priority.lua',

    platformMarkerConName = 'station/rail/lollo_freestyle_train_station/platform_marker.con',
    stationConFileName = 'station/rail/lollo_freestyle_train_station/station.con',
    subwayConFileNames = {
        ['station/rail/lollo_freestyle_train_station/subway.con'] = true,
        ['station/rail/lollo_freestyle_train_station/subwayHollowayMedium.con'] = true,
        ['station/rail/lollo_freestyle_train_station/subwayHollowayLarge.con'] = true,
        ['station/rail/lollo_freestyle_train_station/subwayClaphamLarge.con'] = true,
        -- ['station/rail/lollo_freestyle_train_station/subwayMetropolitain.con'] = true,
    },
    undergroundDepotConFileName = 'depot/lollo_freestyle_train_station/underground_train_depot_era_a.con',

    cargoStationSquareModuleType = 'freestyleTrainStationCargoStationSquare',
    flatCargoRampModuleType = 'freestyleTrainStationFlatCargoRamp',
    flatPassengerStairsModuleType = 'freestyleTrainStationFlatPassengerStairs',
    flatCargoArea5x5ModuleType = 'freestyleTrainStationFlatCargoArea5x5',
    flatCargoArea8x5ModuleType = 'freestyleTrainStationFlatCargoArea8x5',
    flatCargoArea8x10ModuleType = 'freestyleTrainStationFlatCargoArea8x10',
    flatPassengerArea5x5ModuleType = 'freestyleTrainStationFlatPassengerArea5x5',
    flatPassengerArea8x5ModuleType = 'freestyleTrainStationFlatPassengerArea8x5',
    flatPassengerArea8x10ModuleType = 'freestyleTrainStationFlatPassengerArea8x10',
    flatPassengerStation0MModuleType = 'freestyleTrainStationFlatPassengerStation0M',
    flatPassengerStation5MModuleType = 'freestyleTrainStationFlatPassengerStation5M',
    passengerSideLiftModuleType = 'freestyleTrainStationPassengerSideLift',
    passengerPlatformLiftModuleType = 'freestyleTrainStationPassengerPlatformLift',
    passengerStationSquareModuleType = 'freestyleTrainStationPassengerStationSquare',
    -- slopedStairsModuleType = 'freestyleTrainStationSlopedStairs',
    slopedCargoArea1x5ModuleType = 'freestyleTrainStationSlopedCargoArea1x5',
    slopedCargoArea1x10ModuleType = 'freestyleTrainStationSlopedCargoArea1x10',
    slopedCargoArea1x20ModuleType = 'freestyleTrainStationSlopedCargoArea1x20',
    slopedPassengerArea1x2_5ModuleType = 'freestyleTrainStationSlopedPassengerArea1x2_5',
    slopedPassengerArea1x5ModuleType = 'freestyleTrainStationSlopedPassengerArea1x5',
    slopedPassengerArea1x10ModuleType = 'freestyleTrainStationSlopedPassengerArea1x10',
    slopedPassengerArea1x20ModuleType = 'freestyleTrainStationSlopedPassengerArea1x20',
    platformRoofModuleType = 'freestyleTrainStationPlatformRoof',
    cargoTerminalModuleType = 'freestyleTrainStationCargoTerminal',
    passengerTerminalModuleType = 'freestyleTrainStationPassengerTerminal',
    era_a_platformModuleType = 'freestyleTrainStationPlatformEraA',
    era_b_platformModuleType = 'freestyleTrainStationPlatformEraB',
    era_c_platformModuleType = 'freestyleTrainStationPlatformEraC',
    underpassModuleType = 'freestyleTrainStationUnderpass',
    subwayModuleType = 'freestyleTrainStationSubway',
    trackCrossingModuleType = 'freestyleTrainStationTrackCrossing',
    trackSpeedModuleType = 'freestyleTrainStationTrackSpeed',
    trackElectrificationModuleType = 'freestyleTrainStationTrackElectrification',
    tunnelStairsUpModuleType = 'freestyleTrainStationTunnelStairsUp',
    tunnelStairsUpDownModuleType = 'freestyleTrainStationTunnelStairsUpDown',
    openLiftModuleType = 'freestyleTrainStationOpenLift',
    openStairsUpLeftModuleType = 'freestyleTrainStationOpenStairsUpLeft',
    openStairsUpRightModuleType = 'freestyleTrainStationOpenStairsUpRight',
    openStairsExitModuleType = 'freestyleTrainStationOpenStairsExit',

    era_a_flatCargoRampDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_ramp_down_smooth.mdl',
    era_a_flatCargoRampDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_ramp_down_steep.mdl',
    era_a_flatCargoRampFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_ramp_flat.mdl',
    era_a_flatCargoRampUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_ramp_up_smooth.mdl',
    era_a_flatCargoRampUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_ramp_up_steep.mdl',
    era_a_flatPassengerStairsDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_stairs_down_smooth.mdl',
    era_a_flatPassengerStairsDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_stairs_down_steep.mdl',
    era_a_flatPassengerStairsFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_stairs_flat.mdl',
    era_a_flatPassengerStairsUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_stairs_up_smooth.mdl',
    era_a_flatPassengerStairsUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_stairs_up_steep.mdl',
    era_a_flatCargoArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_area5x5.mdl',
    era_a_flatCargoArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_area8x5.mdl',
    era_a_flatCargoArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_area8x10.mdl',
    era_a_flatCargoStation8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_station8x10.mdl',
    era_a_flatCargoStationLower8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_station8x10_lower.mdl',
    era_a_flatCargoStation8x15ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_a_station_8x15.mdl',
    era_a_flatPassengerArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_area5x5.mdl',
    era_a_flatPassengerArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_area8x5.mdl',
    era_a_flatPassengerArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_a_area8x10.mdl',
    era_b_flatCargoRampDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_ramp_down_smooth.mdl',
    era_b_flatCargoRampDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_ramp_down_steep.mdl',
    era_b_flatCargoRampFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_ramp_flat.mdl',
    era_b_flatCargoRampUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_ramp_up_smooth.mdl',
    era_b_flatCargoRampUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_ramp_up_steep.mdl',
    era_b_flatPassengerStairsDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_stairs_down_smooth.mdl',
    era_b_flatPassengerStairsDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_stairs_down_steep.mdl',
    era_b_flatPassengerStairsFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_stairs_flat.mdl',
    era_b_flatPassengerStairsUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_stairs_up_smooth.mdl',
    era_b_flatPassengerStairsUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_stairs_up_steep.mdl',
    era_b_flatCargoArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_area5x5.mdl',
    era_b_flatCargoArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_area8x5.mdl',
    era_b_flatCargoArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_area8x10.mdl',
    era_b_flatCargoStation8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_station8x10.mdl',
    era_b_flatCargoStationLower8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_station8x10_lower.mdl',
    era_b_flatCargoStation8x15ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/era_b_station_8x15.mdl',
    era_b_flatPassengerArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_area5x5.mdl',
    era_b_flatPassengerArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_area8x5.mdl',
    era_b_flatPassengerArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/era_b_area8x10.mdl',
    era_c_flatCargoRampDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_down_smooth.mdl',
    era_c_flatCargoRampDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_down_steep.mdl',
    era_c_flatCargoRampFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_flat.mdl',
    era_c_flatCargoRampUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_up_smooth.mdl',
    era_c_flatCargoRampUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_up_steep.mdl',
    era_c_flatPassengerStairsDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_down_smooth.mdl',
    era_c_flatPassengerStairsDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_down_steep.mdl',
    era_c_flatPassengerStairsFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_flat.mdl',
    era_c_flatPassengerStairsUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_up_smooth.mdl',
    era_c_flatPassengerStairsUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_up_steep.mdl',
    era_c_flatCargoArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area5x5.mdl',
    era_c_flatCargoArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area8x5.mdl',
    era_c_flatCargoArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area8x10.mdl',
    era_c_flatCargoStation8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/station8x10.mdl',
    era_c_flatCargoStationLower8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/station8x10_lower.mdl',
    era_c_flatPassengerArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area5x5.mdl',
    era_c_flatPassengerArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area8x5.mdl',
    era_c_flatPassengerArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area8x10.mdl',

    era_a_slopedCargoArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_a_area1x5.mdl',
    era_a_slopedCargoArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_a_area1x10.mdl',
    era_a_slopedCargoArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_a_area1x20.mdl',
    era_a_slopedPassengerArea1x2_5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_a_area1x2_5.mdl',
    era_a_slopedPassengerArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_a_area1x5.mdl',
    era_a_slopedPassengerArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_a_area1x10.mdl',
    era_a_slopedPassengerArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_a_area1x20.mdl',
    era_b_slopedCargoArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_b_area1x5.mdl',
    era_b_slopedCargoArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_b_area1x10.mdl',
    era_b_slopedCargoArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/era_b_area1x20.mdl',
    era_b_slopedPassengerArea1x2_5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_b_area1x2_5.mdl',
    era_b_slopedPassengerArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_b_area1x5.mdl',
    era_b_slopedPassengerArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_b_area1x10.mdl',
    era_b_slopedPassengerArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/era_b_area1x20.mdl',
    era_c_slopedCargoArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x5.mdl',
    era_c_slopedCargoArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x10.mdl',
    era_c_slopedCargoArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x20.mdl',
    era_c_slopedPassengerArea1x2_5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x2_5.mdl',
    era_c_slopedPassengerArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x5.mdl',
    era_c_slopedPassengerArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x10.mdl',
    era_c_slopedPassengerArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x20.mdl',

    terminalModelFileName = 'lollo_freestyle_train_station/asset/terminal_signal.mdl',
    era_a_underpassGroundModelFileName = 'lollo_freestyle_train_station/underpass/era_a_underpassFloor.mdl',
    era_b_underpassGroundModelFileName = 'lollo_freestyle_train_station/underpass/era_b_underpassFloor.mdl',
    era_c_underpassGroundModelFileName = 'lollo_freestyle_train_station/underpass/era_c_underpassFloor.mdl',
    underpassBuildingWBottom10MModelFileName = 'lollo_freestyle_train_station/underpass/underpass_building_w_bottom_10m.mdl',
    era_a_underpassBuilding10MModelFileName = 'lollo_freestyle_train_station/underpass/era_a_underpass_building_10m.mdl',
    era_b_underpassBuilding10MModelFileName = 'lollo_freestyle_train_station/underpass/era_b_underpass_building_10m.mdl',
    era_c_underpassBuilding10MModelFileName = 'lollo_freestyle_train_station/underpass/era_c_underpass_building_10m.mdl',
    trackWaypointModelId = 'lollo_freestyle_train_station/railroad/track_waypoint.mdl',
    platformWaypointModelId = 'lollo_freestyle_train_station/railroad/platform_waypoint.mdl',
    cargoWaitingAreaModelId = 'lollo_freestyle_train_station/cargo_waiting_area.mdl',
    cargoWaitingAreaCentredModelFileName = 'lollo_freestyle_train_station/cargo_waiting_area_centred.mdl',
    passengerWaitingAreaModelId = 'lollo_freestyle_train_station/passenger_waiting_area.mdl',
    passengerWaitingAreaCentredModelFileName = 'lollo_freestyle_train_station/passenger_waiting_area_centred.mdl',
    passengerLaneLiftModelId = 'lollo_freestyle_train_station/passenger_lane_lift.mdl',
    passengerLaneOpenLiftModelId = 'lollo_freestyle_train_station/passenger_lane_open_lift.mdl',
    passengerLaneUnderpassModelId = 'lollo_freestyle_train_station/passenger_lane_underpass.mdl',
    passengerLaneModelId = 'lollo_freestyle_train_station/passenger_lane.mdl',
    passengerLaneLinkableModelId = 'lollo_freestyle_train_station/passenger_lane_linkable.mdl',
    passengerLaneLinkableRaisedModelId = 'lollo_freestyle_train_station/passenger_lane_linkable_raised.mdl',
    passengerLaneOpenStairsUpBottomNextModelId = 'lollo_freestyle_train_station/passenger_lane_open_stairs_up_bottom_next.mdl',
    passengerLaneOpenStairsUpBottomPrevModelId = 'lollo_freestyle_train_station/passenger_lane_open_stairs_up_bottom_prev.mdl',
    -- passengerLaneOpenStairsUpTopModelId = 'lollo_freestyle_train_station/passenger_lane_open_stairs_up_top.mdl',
    passengerLaneOpenStairsUpTopNextModelId = 'lollo_freestyle_train_station/passenger_lane_open_stairs_up_top_next.mdl',
    passengerLaneOpenStairsUpTopPrevModelId = 'lollo_freestyle_train_station/passenger_lane_open_stairs_up_top_prev.mdl',
    passengerLaneTunnelStairsUpModelId = 'lollo_freestyle_train_station/passenger_lane_tunnel_stairs_up.mdl',
    passengerLaneTunnelStairsUpDownModelId = 'lollo_freestyle_train_station/passenger_lane_tunnel_stairs_up_down.mdl',
    platformRoofConcretePillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofPillar_2_5m.mdl',
    platformRoofConcreteCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofCeiling_2_5m.mdl',
    platformRoofConcretePillar5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofPillar_5m.mdl',
    platformRoofConcreteCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofCeiling_5m.mdl',
    platformRoofConcretePlainPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete_plain/platformRoofPillar_2_5m.mdl',
    platformRoofConcretePlainCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete_plain/platformRoofCeiling_2_5m.mdl',
    platformRoofConcretePlainPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete_plain/platformRoofPillar_5m.mdl',
    platformRoofConcretePlainCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete_plain/platformRoofCeiling_5m.mdl',
    platformRoofIronPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron/platformRoofPillar_2_5m.mdl',
    platformRoofIronCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron/platformRoofCeiling_2_5m.mdl',
    platformRoofIronPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/iron/platformRoofPillar_5m.mdl',
    platformRoofIronCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/iron/platformRoofCeiling_5m.mdl',
    platformRoofIronGlassAluPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_copper/platformRoofPillar_2_5m.mdl',
    platformRoofIronGlassAluCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_copper/platformRoofCeiling_2_5m.mdl',
    platformRoofIronGlassAluPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_copper/platformRoofPillar_5m.mdl',
    platformRoofIronGlassAluCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_copper/platformRoofCeiling_5m.mdl',
    platformRoofMetalGlassPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofPillar_2_5m.mdl',
    platformRoofMetalGlassCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofCeiling_2_5m.mdl',
    platformRoofMetalGlassPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofPillar_5m.mdl',
    platformRoofMetalGlassCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofCeiling_5m.mdl',
    era_a_tunnelStairsUpModelId = 'lollo_freestyle_train_station/subway/era_a_stairsUp.mdl',
    era_b_tunnelStairsUpModelId = 'lollo_freestyle_train_station/subway/era_b_stairsUp.mdl',
    era_c_tunnelStairsUpModelId = 'lollo_freestyle_train_station/subway/era_c_stairsUp.mdl',
    era_a_tunnelStairsUpDownModelId = 'lollo_freestyle_train_station/subway/era_a_stairsUpDown.mdl',
    era_b_tunnelStairsUpDownModelId = 'lollo_freestyle_train_station/subway/era_b_stairsUpDown.mdl',
    era_c_tunnelStairsUpDownModelId = 'lollo_freestyle_train_station/subway/era_c_stairsUpDown.mdl',
    era_a_openStairsUpModelId = 'lollo_freestyle_train_station/open_stairs/era_a_open_stairs_up.mdl',
    era_b_openStairsUpModelId = 'lollo_freestyle_train_station/open_stairs/era_b_open_stairs_up.mdl',
    era_c_openStairsUpModelId = 'lollo_freestyle_train_station/open_stairs/era_c_open_stairs_up.mdl',
    era_a_openStairsExitModelId = 'lollo_freestyle_train_station/open_stairs/era_c_bridge_chunk_4m.mdl',
    era_b_openStairsExitModelId = 'lollo_freestyle_train_station/open_stairs/era_c_bridge_chunk_4m.mdl',
    era_c_openStairsExitModelId = 'lollo_freestyle_train_station/open_stairs/era_c_bridge_chunk_4m.mdl',
    redMessageModelFileName = 'lollo_freestyle_train_station/icon/red_w_message.mdl',
    yellowMessageModelFileName = 'lollo_freestyle_train_station/icon/yellow_w_message.mdl',
    emptyModelFileName = 'lollo_freestyle_train_station/empty.mdl',

    cargoTerminalModuleFileName = 'station/rail/lollo_freestyle_train_station/cargoTerminal.module',
    passengerTerminalModuleFileName = 'station/rail/lollo_freestyle_train_station/passengerTerminal.module', 
    subwayModuleFileName = 'station/rail/lollo_freestyle_train_station/subway.module',
    trackSpeedSlowModuleFileName = 'station/rail/lollo_freestyle_train_station/trackSpeedSlow.module',
    trackSpeedFastModuleFileName = 'station/rail/lollo_freestyle_train_station/trackSpeedFast.module',
    trackSpeedUndefinedModuleFileName = 'station/rail/lollo_freestyle_train_station/trackSpeedUndefined.module',
    trackElectrificationNoModuleFileName = 'station/rail/lollo_freestyle_train_station/trackElectrificationNo.module',
    trackElectrificationYesModuleFileName = 'station/rail/lollo_freestyle_train_station/trackElectrificationYes.module',
    trackElectrificationUndefinedModuleFileName = 'station/rail/lollo_freestyle_train_station/trackElectrificationUndefined.module',

    cargoWaitingAreaTagRoot = 'cargoWaitingArea_',
    passengersWaitingAreaTagRoot = 'passengersWaitingArea_',
    passengersWaitingAreaUnderpassTagRoot = 'passengersWaitingAreaUnderpass_',

    stationCargoTag = 1,
    stationPassengerTag = 2,

    nTerminalMultiplier = 10000,
	idBases = {
        terminalSlotId = 1000000,
        trackCrossingSlotId = 11000000,
        flatStairsOrRampSlotId = 12000000,
        flatArea5x5SlotId = 13000000,
        flatArea8x5SlotId = 14000000,
        flatArea8x10SlotId = 15000000,
        flatStation0MSlotId = 21000000,
        flatStation5MSlotId = 22000000,
        sideLiftSlotId = 23000000,
        platformLiftSlotId = 24000000,
        passengerStationSquareOuterSlotId = 25000000,
        passengerStationSquareInnerSlotId = 26000000,
        cargoStationSquareOuterSlotId = 27000000,
        slopedArea1x5SlotId = 31000000,
        slopedArea1x10SlotId = 32000000,
        slopedArea1x20SlotId = 33000000,
        slopedArea1x2_5SlotId = 34000000,
        underpassSlotId = 40000000,
        tunnelStairsUpSlotId = 50000000,
        subwaySlotId = 51000000,
        tunnelStairsUpDownSlotId = 52000000,
        openStairsUpRightSlotId = 53000000,
        openStairsUpLeftSlotId = 54000000,
        openStairsExitOuterSlotId = 55000000,
        openStairsExitInnerSlotId = 56000000,
        openLiftSlotId = 57000000,
        openLiftExitOuterSlotId = 58000000,
        openLiftExitInnerSlotId = 59000000,
        trackElectrificationSlotId = 60000000,
        trackSpeedSlotId = 61000000,
        platformRoofSlotId = 70000000,
        platformEraASlotId = 80000000,
        platformEraBSlotId = 81000000,
        platformEraCSlotId = 82000000,
    },
    idTransf = {
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    }
}

local _idBasesSortedDesc = {}
for k, v in pairs(constants.idBases) do
    table.insert(_idBasesSortedDesc, {id = v, name = k})
end
arrayUtils.sort(_idBasesSortedDesc, 'id', false)
constants.idBasesSortedDesc = _idBasesSortedDesc

return constants