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
    platformRoofZ = -0.10, -- a bit lower than the platform, to look good on slopes
    underpassZ = -4, -- must be negative and different from the lift heights (5, 10, 15 etc)
    underpassLengthM = 1, -- don't change this, it must stay 1
    tunnelStairsUpZ = 7, -- was 4, which is too little, 7 is barely enough
    subwayPos2LinkX = 4,
    subwayPos2LinkY = 0,
    subwayPos2LinkZ = -4,

    maxPercentageDeviation4Midpoint = _maxPercentageDeviation4Midpoint,
    minPercentageDeviation4Midpoint = 1 / _maxPercentageDeviation4Midpoint,

    maxCargoWaitingAreaEdgeLength = 9, -- do not tamper with this
    maxPassengerWaitingAreaEdgeLength = 9, -- do not tamper with this
    railEdgeType = 1, -- 0 = ROAD, 1 = RAIL
    maxNTerminals = 12,
    minSplitDistance = 2,
    maxWaypointDistance = 800,
    searchRadius4NearbyStation2Join = 500,
    slopeHigh = 999,
    slopeLow = 2.5,

    groundFacesFillKey = 'shared/asphalt_02.gtex.lua',
    groundFacesStrokeOuterKey = 'lollo_freestyle_train_station/asphalt_01_high_priority.lua',

    platformMarkerConName = 'station/rail/lollo_freestyle_train_station/platform_marker.con',
    stationConFileName = 'station/rail/lollo_freestyle_train_station/station.con',
    subwayConFileName = 'station/rail/lollo_freestyle_train_station/subway.con',

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
    slopedPassengerArea1x5ModuleType = 'freestyleTrainStationSlopedPassengerArea1x5',
    slopedPassengerArea1x10ModuleType = 'freestyleTrainStationSlopedPassengerArea1x10',
    slopedPassengerArea1x20ModuleType = 'freestyleTrainStationSlopedPassengerArea1x20',
    platformRoofModuleType = 'freestyleTrainStationPlatformRoof',
    cargoTerminalModuleType = 'freestyleTrainStationCargoTerminal',
    passengerTerminalModuleType = 'freestyleTrainStationPassengerTerminal',
    underpassModuleType = 'freestyleTrainStationUnderpass',
    subwayModuleType = 'freestyleTrainStationSubway',
    trackSpeedModuleType = 'freestyleTrainStationTrackSpeed',
    trackElectrificationModuleType = 'freestyleTrainStationTrackElectrification',
    tunnelStairsUpModuleType = 'freestyleTrainStationTunnelStairsUp',
    tunnelStairsUpDownModuleType = 'freestyleTrainStationTunnelStairsUpDown',

    flatEraCCargoRampDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_down_smooth.mdl',
    flatEraCCargoRampDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_down_steep.mdl',
    flatEraCCargoRampFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_flat.mdl',
    flatEraCCargoRampUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_up_smooth.mdl',
    flatEraCCargoRampUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/ramp_up_steep.mdl',
    flatEraCPassengerStairsDownSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_down_smooth.mdl',
    flatEraCPassengerStairsDownSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_down_steep.mdl',
    flatEraCPassengerStairsFlatModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_flat.mdl',
    flatEraCPassengerStairsUpSmoothModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_up_smooth.mdl',
    flatEraCPassengerStairsUpSteepModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/stairs_up_steep.mdl',
    flatEraCCargoArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area5x5.mdl',
    flatEraCCargoArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area8x5.mdl',
    flatEraCCargoArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/area8x10.mdl',
    flatEraCCargoStation8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/station8x10.mdl',
    flatEraCCargoStationLower8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/cargo/station8x10_lower.mdl',
    flatEraCPassengerArea5x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area5x5.mdl',
    flatEraCPassengerArea8x5ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area8x5.mdl',
    flatEraCPassengerArea8x10ModelFileName = 'lollo_freestyle_train_station/railroad/flatSides/passengers/area8x10.mdl',
    slopedEraCCargoArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x5.mdl',
    slopedEraCCargoArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x10.mdl',
    slopedEraCCargoArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/cargo/area1x20.mdl',
    slopedEraCPassengerArea1x5ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x5.mdl',
    slopedEraCPassengerArea1x10ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x10.mdl',
    slopedEraCPassengerArea1x20ModelFileName = 'lollo_freestyle_train_station/railroad/slopedSides/passengers/area1x20.mdl',
    terminalModelFileName = 'lollo_freestyle_train_station/asset/arrivi_partenze_colonna_new.mdl',
    underpassGroundModelFileName = 'lollo_freestyle_train_station/underpass/underpassFloor.mdl',
    underpassBuildingWBottom10MModelFileName = 'lollo_freestyle_train_station/underpass/underpass_building_w_bottom_10m.mdl',
    underpassBuilding10MModelFileName = 'lollo_freestyle_train_station/underpass/underpass_building_10m.mdl',
    trackWaypointModelId = 'lollo_freestyle_train_station/railroad/track_waypoint.mdl',
    platformWaypointModelId = 'lollo_freestyle_train_station/railroad/platform_waypoint.mdl',
    cargoWaitingAreaModelId = 'lollo_freestyle_train_station/cargo_waiting_area.mdl',
    cargoWaitingAreaCentredModelFileName = 'lollo_freestyle_train_station/cargo_waiting_area_centred.mdl',
    passengerWaitingAreaModelId = 'lollo_freestyle_train_station/passenger_waiting_area.mdl',
    passengerWaitingAreaCentredModelFileName = 'lollo_freestyle_train_station/passenger_waiting_area_centred.mdl',
    passengerLaneLiftModelId = 'lollo_freestyle_train_station/passenger_lane_lift.mdl',
    passengerLaneUnderpassModelId = 'lollo_freestyle_train_station/passenger_lane_underpass.mdl',
    passengerLaneModelId = 'lollo_freestyle_train_station/passenger_lane.mdl',
    passengerLaneLinkableModelId = 'lollo_freestyle_train_station/passenger_lane_linkable.mdl',
    passengerLaneTunnelStairsUpModelId = 'lollo_freestyle_train_station/passenger_lane_tunnel_stairs_up.mdl',
    passengerLaneTunnelStairsUpDownModelId = 'lollo_freestyle_train_station/passenger_lane_tunnel_stairs_up_down.mdl',
    platformRoofConcretePillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofPillar_2_5m.mdl',
    platformRoofConcreteCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofCeiling_2_5m.mdl',
    platformRoofConcretePillar5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofPillar_5m.mdl',
    platformRoofConcreteCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/concrete/platformRoofCeiling_5m.mdl',
    platformRoofIronGlassAluPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_alu/platformRoofPillar_2_5m.mdl',
    platformRoofIronGlassAluCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_alu/platformRoofCeiling_2_5m.mdl',
    platformRoofIronGlassAluPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_alu/platformRoofPillar_5m.mdl',
    platformRoofIronGlassAluCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/iron_glass_alu/platformRoofCeiling_5m.mdl',
    platformRoofMetalGlassPillar2_5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofPillar_2_5m.mdl',
    platformRoofMetalGlassCeiling2_5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofCeiling_2_5m.mdl',
    platformRoofMetalGlassPillar5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofPillar_5m.mdl',
    platformRoofMetalGlassCeiling5MModelFileName = 'lollo_freestyle_train_station/roofs/metal_glass/platformRoofCeiling_5m.mdl',
    tunnelStairsUpModelId = 'lollo_freestyle_train_station/subway/stairsUp.mdl',
    tunnelStairsUpDownModelId = 'lollo_freestyle_train_station/subway/stairsUpDown.mdl',
    subwayModelId = 'lollo_freestyle_train_station/subway/subway.mdl',
    subwayUnconnectedModelId = 'lollo_freestyle_train_station/subway/subway_unconnected.mdl',
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
        flatStairsOrRampSlotId = 12000000,
        flatArea5x5SlotId = 13000000,
        flatArea8x5SlotId = 14000000,
        flatArea8x10SlotId = 15000000,
        flatStation0MSlotId = 21000000,
        flatStation5MSlotId = 22000000,
        sideLiftSlotId = 23000000,
        platformLiftSlotId = 24000000,
        stationSquareOuterSlotId = 25000000,
        stationSquareInnerSlotId = 26000000,
        slopedArea1x5SlotId = 31000000,
        slopedArea1x10SlotId = 32000000,
        slopedArea1x20SlotId = 33000000,
        underpassSlotId = 40000000,
        tunnelStairsUpSlotId = 50000000,
        subwaySlotId = 51000000,
        tunnelStairsUpDownSlotId = 52000000,
        trackElectrificationSlotId = 60000000,
        trackSpeedSlotId = 61000000,
        platformRoofSlotId = 70000000,
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