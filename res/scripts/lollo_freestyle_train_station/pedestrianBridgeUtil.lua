local arrayUtils = require('lollo_freestyle_train_station.arrayUtils')
local bridgeutil = require 'bridgeutil'
local mdlHelpers = require('lollo_freestyle_train_station.mdlHelpers')

local utils = {}
utils.getData = function(isSides)
    local _pillarLength = 1

    local pillarDir = 'bridge/lollo_freestyle_train_station/cement_pillars/'
    local railingDir = 'bridge/lollo_freestyle_train_station/pedestrian_cement/'
    local stockDir = 'bridge/cement/'

    -- LOLLO NOTE bridgeutil receives a list of models of bridge parts, each with its bounding box,
    -- and a list of lanes and offsets,
    -- then places them together depending on this information.
    -- The bounding boxes explain why bridges have a less flexible file structure.

    -- One problem is, platform-tracks < 5 m don't work well on stock bridges.
    -- Either we rewrite the whole thing, or we adjust something and use the automatisms
    -- => number two.
    -- My dedicated *_rep_* models have a mesh and bounding box 0.5 m wide instead of 4.
    -- This applies to railing and pillars.
    -- bridgeutil uses more instances if required, stacked sideways;
    -- otherwise, only one, and it is narrow enough for anything.
    -- This allows for bridges under 2.5 m platform-tracks and narrow paths;
    -- Sadly, any sorts of sides won't work with 2.5 m platforms
    -- coz bridgeutil assumes tracks are 5 m wide (UG TODO the lane data is manky).

    -- Skins and bones help bridges look better, they look segmented without them.
    -- Blender 2.79 has them and they work with the old converter; they are done with vertex groups.
    -- Use the weight painting, then the gradient tool on every vertex group.
    -- Don't forget to clean each vertex group after editing, like with meshes.

    -- This particular bridge is for 1 metre roads, which are very bendy.
    -- See the notes below.

    local railing = isSides
        and {
            railingDir .. 'railing_rep_side_full_side.mdl',
            railingDir .. 'railing_rep_side_full_side.mdl',
            railingDir .. 'railing_rep_side_no_side.mdl',
            railingDir .. 'railing_rep_rep.mdl',
            railingDir .. 'railing_rep_rep.mdl',
            -- these are useful to avoid funny dark textures on one side, but we use the two-sided material instead
            -- railingDir .. 'railing_rep_side2_full_side.mdl',
            -- railingDir .. 'railing_rep_side2_no_side.mdl',
            -- railingDir .. 'railing_rep_side2_no_side.mdl',
        }
        or {
            railingDir .. 'railing_rep_side_no_side.mdl',
            railingDir .. 'railing_rep_side_no_side.mdl',
            railingDir .. 'railing_rep_side_no_side.mdl',
            railingDir .. 'railing_rep_rep.mdl',
            railingDir .. 'railing_rep_rep.mdl',
            -- these are useful to avoid funny dark textures on one side, but we use the two-sided material instead
            -- railingDir .. 'railing_rep_side2_no_side.mdl',
            -- railingDir .. 'railing_rep_side2_no_side.mdl',
            -- railingDir .. 'railing_rep_side2_no_side.mdl',
        }

    local config = {
        pillarBase = { stockDir .. 'pillar_btm_side.mdl', pillarDir .. 'pillar_btm_rep.mdl', stockDir .. 'pillar_btm_side2.mdl' },
        pillarRepeat = { stockDir .. 'pillar_rep_side.mdl', pillarDir .. 'pillar_rep_rep.mdl', stockDir .. 'pillar_rep_side2.mdl' },
        pillarTop = { stockDir .. 'pillar_top_side.mdl', pillarDir .. 'pillar_top_rep.mdl', stockDir .. 'pillar_top_side2.mdl' },
        railingBegin = railing,
        railingRepeat = railing,
        railingEnd = railing,
    }

    local updateFn = bridgeutil.makeDefaultUpdateFn(config)
    local newUpdateFn = function(params)
        -- print('newUpdateFn starting with params =') debugPrint(arrayUtils.cloneOmittingFields(params, {'state'}))
        -- UG TODO
        -- LOLLO NOTE
        -- when making a sharp bend, railingWidth is 10 instead of 0.5 and the lanes are screwed:
        -- this draws pointless artifacts on the sides. When it happens, pillarLength is different from the set value.
        -- the reason is, the C routine giving us the params assumes that the road is at least 5 m wide.
        -- this stupid C routine does not say how wide the road is, so we specialise the bridge on 1 metre wide roads.

        -- params.pillarHeights = {}

        if params.pillarLength ~= _pillarLength then
            params.pillarLength = _pillarLength
            params.pillarWidth = 0.5

            for _, railingInterval in pairs(params.railingIntervals) do
                -- railingInterval.hasPillar = { -1, -1, }
                for _, lane in pairs(railingInterval.lanes) do
                    lane.offset = -0.5 -- goodish, it is minus the road width * 0.5
                    -- lane.type = 0
                end
            end
            -- params.railingWidth = 0.5
            params.railingWidth = 1 -- goodish, it is the road width
            -- print('newUpdateFn tweaked params =') debugPrint(arrayUtils.cloneOmittingFields(params, {'state'}))
        end

        local results = updateFn(params)
        -- print('newUpdateFn returning =') debugPrint(results)
        return results
    end

    return {
        name = isSides and _('PedestrianCementBridgeNoPillars') or _('PedestrianCementBridgeNoPillarsNoSides'),
        yearFrom = 1960,
        yearTo = 0,
        carriers = { 'ROAD' },
        speedLimit = 20.0 / 3.6,
        pillarLen = _pillarLength,
        pillarMinDist = 65535,
        pillarMaxDist = 65535,
        pillarTargetDist = 65535,
        -- pillarWidth = 2,
        cost = 400.0,
        -- LOLLO NOTE
        -- Sharp bends draw the street tangent to the bridge, outside,
        -- because the game expects 6m long street segments, while this bridge has 2m long segments.
        -- We can make street materials transparent, so sharp bends will look better.
        -- However, this will give junctions a hole in the middle.
        -- All in all, we choose junctions with no holes
        -- and put up with segments in stupidly narrow bends.
        materialsToReplace = {
            -- streetPaving = {
            --     name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            -- },
            -- streetLane = { -- this is the most conspicuous
            --     name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            -- },
            -- crossingLane = {
            --     name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            -- },
            -- sidewalkPaving = { -- this fills small gaps at junctions but also draws tangent stripes outside sharp bends
            --     -- name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            --     -- name = "lollo_freestyle_train_station/icon/green.mtl"
            --     -- name = "lollo_freestyle_train_station/station_concrete_1_low_prio.mtl"
            --     name = 'street/country_new_medium_paving.mtl',
            --     size = { 2, 2 },
            -- },
            -- sidewalkCurb = { -- useless
            --     -- size = { 3, 0.6 },
            --     -- name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            --     name = "lollo_freestyle_train_station/icon/yellow.mtl"
            -- },
            -- sidewalkBorderInner = {
            --     size = { 2, 0.8 },
            --     -- name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            --     name = "lollo_freestyle_train_station/icon/blue.mtl"
            -- },
            -- sidewalkLane = {
            --     size = { 2, 0.8 },
            --     -- name = 'lollo_freestyle_train_station/totally_transparent.mtl'
            --     name = "lollo_freestyle_train_station/icon/red.mtl"
            -- },
        },
        noParallelStripSubdivision = true,
        -- updateFn = updateFn,
        updateFn = newUpdateFn,
    }
end

utils.getModel = function(nSegments)
    local _2nSegments = 2 * nSegments
    local _iMax = _2nSegments - 2
	local lod0Children  = {}

	for i = 0, _iMax, 2 do
		lod0Children[#lod0Children + 1] = {
			children = {
				{
					children = {
						{
							name = "cement_bridge_bone_2m_start",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0.66667, 0, 1, },
						},
						{
							name = "cement_bridge_bone_2m_end",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0.66667, 0, 1, },
						},
					},
					name = "container_2m",
					skin = "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_rep_skin/cement_low_bottom_railing_rep_rep_lod0.msh",
					skinMaterials = {
						-- "lollo_freestyle_train_station/bridge/cement_skinned_2_sided.mtl",
						"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
						"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
					},
				},
			},
			transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, i, -0.25, 0, 1, },
		}
		lod0Children[#lod0Children + 1] = {
			children = {
				{
					children = {
						{
							name = "cement_bridge_bone_2m_start_side1",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0.66667, 0, 1, },
						},
						{
							name = "cement_bridge_bone_2m_end_side1",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0.66667, 0, 1, },
						},
					},
					name = "container_2m_side1",
					skin = (i == 0 or i == _iMax)
						and "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_no_side_lod0.msh"
						or "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_full_side_lod0.msh",
					skinMaterials = (i == 0 or i == _iMax)
						and {
							-- "lollo_freestyle_train_station/bridge/cement_skinned_2_sided.mtl"
							"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
						}
						or {
							-- "lollo_freestyle_train_station/bridge/cement_skinned_2_sided.mtl",
							"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
							"lollo_freestyle_train_station/metal/rough_iron_skinned.mtl",
						},
				},
			},
			transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, i, -0.5, 0, 1, },
		}
		lod0Children[#lod0Children + 1] = {
			children = {
				{
					children = {
						{
							name = "cement_bridge_bone_2m_start_side2",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0.66667, 0, 1, },
						},
						{
							name = "cement_bridge_bone_2m_end_side2",
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 2, 0.66667, 0, 1, },
						},
					},
					name = "container_2m_side2",
					skin = (i == 0 or i == _iMax)
						and "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_no_side_lod0.msh"
						or "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_full_side_lod0.msh",
					skinMaterials = (i == 0 or i == _iMax)
						and {
							-- "lollo_freestyle_train_station/bridge/cement_skinned_2_sided.mtl",
							"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
						}
						or {
							-- "lollo_freestyle_train_station/bridge/cement_skinned_2_sided.mtl",
							"lollo_freestyle_train_station/station_concrete_1_low_prio_skinned.mtl",
							"lollo_freestyle_train_station/metal/rough_iron_skinned.mtl",
						},
				},
			},
			transf = { 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, i, 0.5, 0, 1, },
		}
	end

	return {
		boundingInfo = mdlHelpers.getVoidBoundingInfo(),
		collider = mdlHelpers.getVoidCollider(),
		lods = {
			{
				node = {
					children =  lod0Children,
					name = "lod0Children",
					transf = { 1 / _2nSegments, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1, },
				},
				static = false,
				visibleFrom = 0,
				visibleTo = 200,
			},
			{
				node = {
					children = {
						{
							mesh = "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_no_side_lod1.msh",
							-- materials = { "bridge/cement.mtl", },
							materials = { "lollo_freestyle_train_station/station_concrete_1_low_prio.mtl", },
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, -0.5, 0, 1, },
						},
						{
							mesh = "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_rep_skin/cement_low_bottom_railing_rep_rep_lod1.msh",
							materials = { "lollo_freestyle_train_station/station_concrete_1_low_prio.mtl", },
							transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, -0.25, 0, 1, },
						},
						{
							mesh = "lollo_freestyle_train_station/bridge/pedestrian_cement/railing_rep_side_skin/cement_low_bottom_railing_rep_side_no_side_lod1.msh",
							-- materials = { "bridge/cement.mtl", },
							materials = { "lollo_freestyle_train_station/station_concrete_1_low_prio.mtl", },
							transf = { 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0.5, 0, 1, },
						},
					},
					name = "lod1Children",
					transf = { 0.5, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, },
				},
				static = false,
				visibleFrom = 200,
				visibleTo = 600,
			},
		},
		metadata = {
			transportNetworkProvider = {
				laneLists = {
					{
						linkable = false, -- false, --true,
						nodes = {
							{
								{ 0, 0, 0 },
								{ 1, 0, 0 },
								1.5,
							},
							{
								{ 1, 0, 0 },
								{ 1, 0, 0 },
								1.5,
							},
						},
						transportModes = { 'PERSON', },
						speedLimit = 20,
					},
				},
				runways = { },
				terminals = { },
			},
		},
		version = 1,
	}
end

return utils
