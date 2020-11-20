local arrayUtils = require('lollo_freestyle_train_station.arrayUtils')
local transfUtilUG = require('transf')

local function _myErrorHandler(err)
    print('lollo freestyle train station ERROR: ', err)
end

local _eventId = '__lolloFreestyleTrainStation__'
local _eventNames = {
    PLATFORM_WAYPOINT_BUILT_ON_PLATFORM = 'platformWaypointBuiltOnPlatform',
    PLATFORM_WAYPOINT_BUILT_OUTSIDE_PLATFORM = 'platformWaypointBuiltOutsidePlatform',
    TRACK_WAYPOINT_1_BUILT_ON_PLATFORM = 'trackWaypoint1BuiltOnPlatform',
    TRACK_WAYPOINT_1_BUILT_OUTSIDE_PLATFORM = 'trackWaypoint1BuiltOutsidePlatform',
    TRACK_WAYPOINT_2_BUILT_ON_PLATFORM = 'trackWaypoint2BuiltOnPlatform',
    TRACK_WAYPOINT_2_BUILT_OUTSIDE_PLATFORM = 'trackWaypoint2BuiltOutsidePlatform',
}


local _utils = {
    getContiguousEdges = function(edgeId, trackType)
        local _calcContiguousEdges = function(firstEdgeId, firstNodeId, map, trackType, isInsertFirst, results)
            local refEdgeId = firstEdgeId
            local edgeIds = map[firstNodeId] -- userdata
            local refNodeId = firstNodeId
            local isExit = false
            while not(isExit) do
                if not(edgeIds) or #edgeIds ~= 2 then
                    isExit = true
                else
                    for _, edgeId in pairs(edgeIds) do -- cannot use edgeIds[index] here
                        print('edgeId =')
                        debugPrint(edgeId)
                        if edgeId ~= refEdgeId then
                            local baseEdgeTrack = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE_TRACK)
                            print('baseEdgeTrack =')
                            debugPrint(baseEdgeTrack)
                            if not(baseEdgeTrack) or baseEdgeTrack.trackType ~= trackType then
                                isExit = true
                                break
                            else
                                if isInsertFirst then
                                    table.insert(results, 1, edgeId)
                                else
                                    table.insert(results, edgeId)
                                end
                                local edgeData = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
                                if edgeData.node0 ~= refNodeId then
                                    refNodeId = edgeData.node0
                                else
                                    refNodeId = edgeData.node1
                                end
                                refEdgeId = edgeId
                                break
                            end
                        end
                    end
                    edgeIds = map[refNodeId]
                end
            end
        end

        print('_getContiguousEdges starting, edgeId =')
        debugPrint(edgeId)
        print('track type =')
        debugPrint(trackType)

        if not(edgeId) or not(trackType) then return {} end

        local _baseEdgeTrack = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE_TRACK)
        if not(_baseEdgeTrack) or _baseEdgeTrack.trackType ~= trackType then return {} end

        local _baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
        local _edgeId = edgeId
        local _map = api.engine.system.streetSystem.getNode2SegmentMap()
        local results = { edgeId }

        _calcContiguousEdges(_edgeId, _baseEdge.node0, _map, trackType, true, results)
        _calcContiguousEdges(_edgeId, _baseEdge.node1, _map, trackType, false, results)

        return results
    end,

    getOuterNodes = function(contiguousEdgeIds, trackType)
        local _hasOnlyOneEdgeOfType1 = function(nodeId, map, trackType)
            if type(nodeId) ~= 'number' or nodeId < 1 or not(trackType) then return false end

            local edgeIds = map[nodeId] -- userdata
            if not(edgeIds) or #edgeIds < 2 then return true end

            local counter = 0
            for _, edgeId in pairs(edgeIds) do -- cannot use edgeIds[index] here
                local baseEdgeTrack = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE_TRACK)
                if baseEdgeTrack ~= nil and baseEdgeTrack.trackType == trackType then
                    counter = counter + 1
                end
            end

            return counter < 2
        end

        print('one')
        if type(contiguousEdgeIds) ~= 'table' or #contiguousEdgeIds < 1 then return {} end
        print('two')
        if #contiguousEdgeIds == 1 then
            local _baseEdge = api.engine.getComponent(contiguousEdgeIds[1], api.type.ComponentType.BASE_EDGE)
            print('three')
            return { _baseEdge.node0, _baseEdge.node1 }
        end

        local results = {}
        local _map = api.engine.system.streetSystem.getNode2SegmentMap()
        local _baseEdgeFirst = api.engine.getComponent(contiguousEdgeIds[1], api.type.ComponentType.BASE_EDGE)
        local _baseEdgeLast = api.engine.getComponent(contiguousEdgeIds[#contiguousEdgeIds], api.type.ComponentType.BASE_EDGE)
        if _hasOnlyOneEdgeOfType1(_baseEdgeFirst.node0, _map, trackType) then
            results[#results+1] = _baseEdgeFirst.node0
        elseif _hasOnlyOneEdgeOfType1(_baseEdgeFirst.node1, _map, trackType) then
            results[#results+1] = _baseEdgeFirst.node1
        end
        if _hasOnlyOneEdgeOfType1(_baseEdgeLast.node0, _map, trackType) then
            results[#results+1] = _baseEdgeLast.node0
        elseif _hasOnlyOneEdgeOfType1(_baseEdgeLast.node1, _map, trackType) then
            results[#results+1] = _baseEdgeLast.node1
        end

        return results
    end,

    getLastBuiltEdge = function(entity2tn)
        local nodeIds = {}
        for k, _ in pairs(entity2tn) do
            local entity = game.interface.getEntity(k)
            if entity.type == 'BASE_NODE' then nodeIds[#nodeIds+1] = entity.id end
        end
        if #nodeIds ~= 2 then return nil end

        for k, _ in pairs(entity2tn) do
            local entity = game.interface.getEntity(k)
            if entity.type == 'BASE_EDGE'
            and ((entity.node0 == nodeIds[1] and entity.node1 == nodeIds[2])
            or (entity.node0 == nodeIds[2] and entity.node1 == nodeIds[1])) then
                local extraEdgeData = api.engine.getComponent(entity.id, api.type.ComponentType.BASE_EDGE)
                return {
                    id = entity.id,
                    objects = extraEdgeData.objects
                }
            end
        end

        return nil
    end,

    getTransfFromApiResult = function(transfStr)
        transfStr = transfStr:gsub('%(%(', '(')
        transfStr = transfStr:gsub('%)%)', ')')
        local results = {}
        for match0 in transfStr:gmatch('%([^(%))]+%)') do
            local noBrackets = match0:gsub('%(', '')
            noBrackets = noBrackets:gsub('%)', '')
            for match1 in noBrackets:gmatch('[%-%.%d]+') do
                results[#results + 1] = tonumber(match1 or '0')
            end
        end
        return results
    end,

    getWaypointId = function(edgeObjects, refModelId)
        local result = nil
        for i = 1, #edgeObjects do
            -- debugPrint(game.interface.getEntity(edgeObjects[i][1]))
            local modelInstanceList = api.engine.getComponent(edgeObjects[i][1], api.type.ComponentType.MODEL_INSTANCE_LIST)
            -- print('LOLLO model instance list =')
            -- debugPrint(modelInstanceList)
            if modelInstanceList
            and modelInstanceList.fatInstances
            and modelInstanceList.fatInstances[1]
            and modelInstanceList.fatInstances[1].modelId == refModelId then
                result = edgeObjects[i][1]
                break
            end
        end
        return result
    end,

    isBuildingConstructionWithFileName = function(param, fileName)
        local toAdd =
            type(param) == 'table' and type(param.proposal) == 'userdata' and type(param.proposal.toAdd) == 'userdata' and
            param.proposal.toAdd

        if toAdd and #toAdd > 0 then
            for i = 1, #toAdd do
                if toAdd[i].fileName == fileName then
                    return true
                end
            end
        end

        return false
    end,
}

local function _isBuildingFreestyleTrainStation(param)
    return _utils.isBuildingConstructionWithFileName(param, 'station/rail/lollo_freestyle_train_station.con')
end

function data()
    return {
        ini = function()
        end,
        handleEvent = function(src, id, name, param)
            if (id ~= _eventId) then return end
            -- if type(param) ~= 'table' or type(param.constructionEntityId) ~= 'number' or param.constructionEntityId < 0 then return end

            print('handleEvent firing, src =', src, 'id =', id, 'name =', name, 'param =')
            debugPrint(param)
            -- handleEvent firing, src =	lollo_freestyle_train_station.lua	id =	__lolloFreestyleTrainStation__	name =	waypointBuilt	param =

            -- print('param.constructionEntityId =', param.constructionEntityId or 'NIL')
            -- if name == 'lorryStationBuilt' then
            --     _replaceStationWithSnapNodes(param.constructionEntityId)
            -- elseif name == 'lorryStationSelected' then
            --     _replaceStationWithStreetType_(param.constructionEntityId)
            -- end
            -- LOLLO TODO remove waypoint
        end,
        guiHandleEvent = function(id, name, param)
            -- LOLLO NOTE param can have different types, even boolean, depending on the event id and name
            if name == 'builder.apply' then
                xpcall(
                    function()
                        print('guiHandleEvent caught id =', id, 'name =', name, 'param =')
                        -- debugPrint(param)

                        if param and param.proposal and param.proposal.proposal
                        and param.proposal.proposal.edgeObjectsToAdd
                        and param.proposal.proposal.edgeObjectsToAdd[1]
                        and param.proposal.proposal.edgeObjectsToAdd[1].modelInstance
                        then
                            local platformWaypointModelId = api.res.modelRep.find('railroad/lollo_freestyle_train_station/lollo_platform_waypoint.mdl')
                            local trackWaypoint1ModelId = api.res.modelRep.find('railroad/lollo_freestyle_train_station/lollo_track_waypoint_1.mdl')
                            local trackWaypoint2ModelId = api.res.modelRep.find('railroad/lollo_freestyle_train_station/lollo_track_waypoint_2.mdl')
                            local platformTrackType = api.res.trackTypeRep.find('platform.lua')

                            -- if not param.result or not param.result[1] then
                            --     return
                            -- end

                            if param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.modelId == platformWaypointModelId then
                                print('LOLLO platform waypoint built!')
                                local lastBuiltEdge = _utils.getLastBuiltEdge(param.data.entity2tn)
                                if not(lastBuiltEdge) then return end

                                local waypointId = _utils.getWaypointId(lastBuiltEdge.objects, platformWaypointModelId)
                                -- for i = 1, #lastBuiltEdge.objects do
                                --     -- debugPrint(game.interface.getEntity(lastBuiltEdge.objects[i][1]))
                                --     local modelInstanceList = api.engine.getComponent(lastBuiltEdge.objects[i][1], api.type.ComponentType.MODEL_INSTANCE_LIST)
                                --     -- print('LOLLO model instance list =')
                                --     -- debugPrint(modelInstanceList)
                                --     if modelInstanceList
                                --     and modelInstanceList.fatInstances
                                --     and modelInstanceList.fatInstances[1]
                                --     and modelInstanceList.fatInstances[1].modelId == platformWaypointModelId then
                                --         waypointId = lastBuiltEdge.objects[i][1]
                                --     end
                                -- end
                                if not(waypointId) then return end

                                -- LOLLO NOTE as I added an edge object, I have NOT split the edge
                                if param.proposal.proposal.addedSegments[1].trackEdge.trackType == platformTrackType then
                                    -- waypoint built on platform
                                    -- LOLLO TODO:
                                    -- find all consecutive edges of the same type
                                    -- sort them from first to last
                                    local continuousEdges = _utils.getContiguousEdges(
                                        lastBuiltEdge.id,
                                        platformTrackType
                                    )
                                    print('contiguous edges =')
                                    debugPrint(continuousEdges)
                                    print('# contiguous edges =')
                                    debugPrint(#continuousEdges)
                                    print('type of contiguous edges =')
                                    debugPrint(type(continuousEdges))
                                    print('contiguous edges[1] =')
                                    debugPrint(continuousEdges[1])
                                    print('contiguous edges[last] =')
                                    debugPrint(continuousEdges[#continuousEdges])

                                    local outerNodes = _utils.getOuterNodes(continuousEdges, platformTrackType)
                                    print('outerNodes =')
                                    debugPrint(outerNodes)

                                    -- left side: find the 2 tracks (real tracks, not platform tracks) nearest to the platform start and end
                                    -- repeat on the right side
                                    -- for now, identify them with the red and green pins instead!
                                    -- if at least one normal track was found:
                                        -- raise an event
                                        -- the worker thread will:
                                        -- split the tracks near the ends of the platform (left and / or right)
                                        -- destroy all the tracks between the splits
                                        -- add a construction with:
                                            -- rail edges replacing the destroyed tracks
                                            -- many small models with straight person paths and terminals { personNode, personEdge, vehicleEdge }
                                            -- terminals with vehicleNodeOverride
                                        -- destroy the waypoint
                                        -- WHAT IF there is already a waypoint on the same table of platforms?
                                        -- WHAT IF the same track has already been split by another platform, or by the same?
                                        -- WHAT IF the user adds or removes an adjacent piece of platform?
                                            -- catch it and check if the station needs expanding
                                        -- WHAT IF the user removes a piece of platform inbetween?
                                            -- Homer Simpson: remove the station or make it on one end only
                                        -- WHAT IF the user destroys the construction?
                                            -- replace the edges with normal pieces of track
                                        -- WHAT IF more than 1 of my special waypoints is built? Delete the last one!
                                    -- else
                                        -- raise an event
                                        -- the worker thread will:
                                        -- destroy the waypoint
                                    -- endif
                                    game.interface.sendScriptEvent(_eventId, _eventNames.PLATFORM_WAYPOINT_BUILT_ON_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        -- transf = _getTransfFromApiResult(tostring(param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf))
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                    -- LOLLO TODO the worker thread must destroy the waypoint
                                else
                                    -- waypoint built outside platform
                                    game.interface.sendScriptEvent(_eventId, _eventNames.PLATFORM_WAYPOINT_BUILT_OUTSIDE_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        -- transf = _getTransfFromApiResult(tostring(param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf))
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                end
                            elseif param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.modelId == trackWaypoint1ModelId then
                                print('LOLLO track waypoint 1 built!')
                                local lastBuiltEdge = _utils.getLastBuiltEdge(param.data.entity2tn)
                                if not(lastBuiltEdge) then return end

                                local waypointId = _utils.getWaypointId(lastBuiltEdge.objects, trackWaypoint1ModelId)
                                if not(waypointId) then return end

                                -- LOLLO NOTE as I added an edge object, I have NOT split the edge
                                if param.proposal.proposal.addedSegments[1].trackEdge.trackType ~= platformTrackType then
                                    game.interface.sendScriptEvent(_eventId, _eventNames.TRACK_WAYPOINT_1_BUILT_OUTSIDE_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                else
                                    game.interface.sendScriptEvent(_eventId, _eventNames.TRACK_WAYPOINT_1_BUILT_ON_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                end
                            elseif param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.modelId == trackWaypoint2ModelId then
                                print('LOLLO track waypoint 2 built!')
                                local lastBuiltEdge = _utils.getLastBuiltEdge(param.data.entity2tn)
                                if not(lastBuiltEdge) then return end

                                local waypointId = _utils.getWaypointId(lastBuiltEdge.objects, trackWaypoint2ModelId)
                                if not(waypointId) then return end

                                -- LOLLO NOTE as I added an edge object, I have NOT split the edge
                                if param.proposal.proposal.addedSegments[1].trackEdge.trackType ~= platformTrackType then
                                    game.interface.sendScriptEvent(_eventId, _eventNames.TRACK_WAYPOINT_2_BUILT_OUTSIDE_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                else
                                    game.interface.sendScriptEvent(_eventId, _eventNames.TRACK_WAYPOINT_2_BUILT_ON_PLATFORM, {
                                        edgeId = lastBuiltEdge.id,
                                        transf = transfUtilUG.new(
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(0),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(1),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(2),
                                            param.proposal.proposal.edgeObjectsToAdd[1].modelInstance.transf:cols(3)
                                        ),
                                        waypointId = waypointId,
                                    })
                                end
                            end
                        end
                    end,
                    _myErrorHandler
                )
            end
        end,
        update = function()
        end,
        guiUpdate = function()
        end,
        -- save = function()
        --     return allState
        -- end,
        -- load = function(allState)
        -- end
    }
end