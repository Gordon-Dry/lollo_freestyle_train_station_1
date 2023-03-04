-- local bridgeutil = require 'bridgeutil'
local pedestrianBridgeUtil = require('lollo_freestyle_train_station.pedestrianBridgeUtil')

function data()
	local pillarDir = 'bridge/lollo_freestyle_train_station/iron_pillars_high/'
	local railingDir = 'bridge/lollo_freestyle_train_station/cement_glass/'

	local railing = {
		railingDir .. 'railing_rep_side_glass_shield_roof.mdl',
		railingDir .. 'railing_rep_side_glass_shield.mdl',
		railingDir .. 'railing_rep_side_no_side.mdl',
		railingDir .. 'railing_rep_rep_roof.mdl',
		railingDir .. 'railing_rep_rep.mdl',
	}

	local config = {
		pillarBase = { pillarDir .. "pillar_2_btm_side.mdl", pillarDir .. "pillar_2_btm_rep.mdl", pillarDir .. "pillar_2_btm_side_2.mdl" },
        pillarRepeat = { pillarDir .. "pillar_2_rep_side.mdl", pillarDir .. "pillar_2_rep_rep.mdl", pillarDir .. "pillar_2_rep_side_2.mdl" },
        pillarTop = { pillarDir .. "pillar_2_top_side.mdl", pillarDir .. "pillar_2_top_rep.mdl", pillarDir .. "pillar_2_top_side_2.mdl" },
		railingBegin = railing,
		railingRepeat = railing,
		railingEnd = railing,
	}

	return pedestrianBridgeUtil.getData4CementGlassBridge(
		_('CementBridgeGlassWallSpacedPillars'),
		config,
		48, 192, 96
	)
--[[
	return {
		name = _('CementBridgeGlassWallSpacedPillars'),
		yearFrom = 0,
		yearTo = 0,
		carriers = { 'RAIL', 'ROAD' },
		speedLimit = 320.0 / 3.6,
		pillarLen = 3,
		pillarMinDist = 48.0,
		pillarMaxDist = 192.0,
		pillarTargetDist = 96.0,
		noParallelStripSubdivision = true,
		cost = 400.0,
		materialsToReplace = {
			streetPaving = {
				name = 'street/country_new_medium_paving.mtl',
			},
			streetLane = {
				name = 'street/new_medium_lane.mtl',
			},
			crossingLane = {
				name = 'street/new_medium_lane.mtl',
			},
			sidewalkPaving = {
				name = 'street/new_medium_sidewalk.mtl',
			},
			sidewalkBorderInner = {
				name = 'street/new_medium_sidewalk_border_inner.mtl',
				size = { 3, 0.6 },
			},
		},
		updateFn = bridgeutil.makeDefaultUpdateFn(config),
	}
]]
end
