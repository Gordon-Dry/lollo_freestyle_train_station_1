local _constants = require('lollo_freestyle_train_station.constants')
local arrayUtils = require('lollo_freestyle_train_station.arrayUtils')
local edgeUtils = require('lollo_freestyle_train_station.edgeUtils')
local stringUtils = require('lollo_freestyle_train_station.stringUtils')
local trackUtils = require('lollo_freestyle_train_station.trackHelpers')
local transfUtils = require('lollo_freestyle_train_station.transfUtils')
local transfUtilsUG = require('transf')


local helpers = {
    getNearbyFreestyleStationsListOLD = function(transf, searchRadius)
        if type(transf) ~= 'table' then return {} end

        local squareCentrePosition = transfUtils.getVec123Transformed({0, 0, 0}, transf)
        local cons = game.interface.getEntities(
            {pos = squareCentrePosition, radius = searchRadius},
            {type = "CONSTRUCTION", includeData = true, fileName = _constants.stationConFileName}
        )
        -- #cons returns 0 coz it's not a list
        local results = {}
        for _, con in pairs(cons) do
            for _, staId in pairs(con.stations) do
                local staGroupId = api.engine.system.stationGroupSystem.getStationGroup(staId)
                if edgeUtils.isValidAndExistingId(staGroupId) then
                    local staGroupName = api.engine.getComponent(staGroupId, api.type.ComponentType.NAME)
                    print('staGroupName =') debugPrint(staGroupName)
                    if staGroupName ~= nil and not(stringUtils.isNullOrEmptyString(staGroupName.name)) then
                        results[#results+1] = {
                            id = con.id,
                            name = staGroupName.name,
                            position = arrayUtils.cloneDeepOmittingFields(con.position)
                        }
                        break
                    end
                end
            end
        end
        -- print('# nearby freestyle stations = ', #results)
        -- print('nearby freestyle stations = ') debugPrint(results)
        return results
    end,

    getNearbyFreestyleStationsList = function(transf, searchRadius, isOnlyPassengers)
        if type(transf) ~= 'table' then return {} end
        if tonumber(searchRadius) == nil then searchRadius = _constants.searchRadius4NearbyStation2Join end

        -- LOLLO NOTE in the game and in this mod, there is one train station for each station group
        -- and viceversa. Station groups hold some information that stations don't, tho.
        -- Multiple station groups can share a construction.
        -- What I really want here is a list with one item each construction, but that could be an expensive loop,
        -- so I check the stations instead and index by the construction.
        local stationIds = edgeUtils.getNearbyObjectIds(transf, searchRadius, api.type.ComponentType.STATION)
        local _station2ConstructionMap = api.engine.system.streetConnectorSystem.getStation2ConstructionMap()
        local resultsIndexed = {}
        for _, stationId in pairs(stationIds) do
            if edgeUtils.isValidAndExistingId(stationId) then
                local conId = _station2ConstructionMap[stationId]
                if edgeUtils.isValidAndExistingId(conId) then
                    -- print('getNearbyFreestyleStationsList has found conId =', conId)
                    local con = api.engine.getComponent(conId, api.type.ComponentType.CONSTRUCTION)
                    if con ~= nil and type(con.fileName) == 'string' and con.fileName == _constants.stationConFileName then
                        -- print('construction.name =') debugPrint(con.name) nil
                        local isCargo = api.engine.getComponent(stationId, api.type.ComponentType.STATION).cargo or false
                        -- print('isCargo =', isCargo)
                        -- print('isOnlyPassengers =', isOnlyPassengers)
                        if not(isCargo) or not(isOnlyPassengers) then
                            local stationGroupId = api.engine.system.stationGroupSystem.getStationGroup(stationId)
                            local name = ''
                            local stationGroupName = api.engine.getComponent(stationGroupId, api.type.ComponentType.NAME)
                            if stationGroupName ~= nil then name = stationGroupName.name end

                            local isTwinCargo = false
                            local isTwinPassenger = false

                            if resultsIndexed[conId] ~= nil then
                                -- print('found a twin, it is') debugPrint(resultsIndexed[conId])
                                if stringUtils.isNullOrEmptyString(name) then
                                    name = resultsIndexed[conId].name or ''
                                end
                                if resultsIndexed[conId].isCargo then isTwinCargo = true end
                                if resultsIndexed[conId].isPassenger then isTwinPassenger = true end
                            end
                            local position = transfUtils.transf2Position(
                                transfUtilsUG.new(con.transf:cols(0), con.transf:cols(1), con.transf:cols(2), con.transf:cols(3))
                            )
                            resultsIndexed[conId] = {
                                id = conId,
                                isCargo = isCargo or isTwinCargo,
                                isPassenger = not(isCargo) or isTwinPassenger,
                                name = name,
                                position = position
                            }
                        end
                    end
                end
            end
        end

        print('resultsIndexed =') debugPrint(resultsIndexed)
        local results = {}
        for _, value in pairs(resultsIndexed) do
            results[#results+1] = value
        end
        -- print('# nearby freestyle stations = ', #results)
        -- print('nearby freestyle stations = ') debugPrint(results)
        return results
    end,

    getEdgeIdsProperties = function(edgeIds)
        if type(edgeIds) ~= 'table' then return {} end

        local _getEdgeType = function(baseEdgeType)
            return baseEdgeType == 1 and 'BRIDGE' or (baseEdgeType == 2 and 'TUNNEL' or nil)
        end
        local _getEdgeTypeName = function(baseEdgeType, baseEdgeTypeIndex)
            if baseEdgeType == 1 then -- bridge
                return api.res.bridgeTypeRep.getName(baseEdgeTypeIndex)
            elseif baseEdgeType == 2 then -- tunnel
                return api.res.tunnelTypeRep.getName(baseEdgeTypeIndex)
            else
                return nil
            end
        end

        local results = {}
        for i = 1, #edgeIds do
            -- print('edgeId =', edgeIds[i])
            local baseEdge = api.engine.getComponent(edgeIds[i], api.type.ComponentType.BASE_EDGE)
            -- print('baseEdge =') debugPrint(baseEdge)
            local baseEdgeTrack = api.engine.getComponent(edgeIds[i], api.type.ComponentType.BASE_EDGE_TRACK)
            -- print('baseEdgeTrack =') debugPrint(baseEdgeTrack)
            local baseNode0 = api.engine.getComponent(baseEdge.node0, api.type.ComponentType.BASE_NODE)
            local baseNode1 = api.engine.getComponent(baseEdge.node1, api.type.ComponentType.BASE_NODE)
            local baseEdgeProperties = api.res.trackTypeRep.get(baseEdgeTrack.trackType)

            local pos0 = baseNode0.position
            local pos1 = baseNode1.position
            local tan0 = baseEdge.tangent0
            local tan1 = baseEdge.tangent1

            local _swap = function()
                local swapPos = pos0
                pos0 = pos1
                pos1 = swapPos
                local swapTan = tan0
                tan0 = tan1
                tan1 = swapTan
                tan0.x = -tan0.x
                tan0.y = -tan0.y
                tan0.z = -tan0.z
                tan1.x = -tan1.x
                tan1.y = -tan1.y
                tan1.z = -tan1.z
            end
            -- edgeIds are in the right sequence, but baseNode0 and baseNode1 depend on the sequence edges were laid in
            if i == 1 then
                if i < #edgeIds then
                    -- print('nextBaseEdgeId =') debugPrint(edgeIds[i + 1])
                    local nextBaseEdge = api.engine.getComponent(edgeIds[i + 1], api.type.ComponentType.BASE_EDGE)
                    if baseEdge.node0 == nextBaseEdge.node0 or baseEdge.node0 == nextBaseEdge.node1 then _swap() end
                end
            else
                local prevBaseEdge = api.engine.getComponent(edgeIds[i - 1], api.type.ComponentType.BASE_EDGE)
                if baseEdge.node1 == prevBaseEdge.node0 or baseEdge.node1 == prevBaseEdge.node1 then _swap() end
            end

            local result = {
                catenary = baseEdgeTrack.catenary,
                posTanX2 = {
                    {
                        {
                            pos0.x,
                            pos0.y,
                            pos0.z,
                        },
                        {
                            tan0.x,
                            tan0.y,
                            tan0.z,
                        }
                    },
                    {
                        {
                            pos1.x,
                            pos1.y,
                            pos1.z,
                        },
                        {
                            tan1.x,
                            tan1.y,
                            tan1.z,
                        }
                    }
                },
                trackType = baseEdgeTrack.trackType,
                trackTypeName = api.res.trackTypeRep.getName(baseEdgeTrack.trackType),
                type = baseEdge.type, -- 0 on ground, 1 bridge, 2 tunnel
                edgeType = _getEdgeType(baseEdge.type), -- same as above but in a format constructions understand
                typeIndex = baseEdge.typeIndex, -- -1 on ground, 0 tunnel / cement bridge, 1 steel bridge, 2 stone bridge, 3 suspension bridge
                edgeTypeName = _getEdgeTypeName(baseEdge.type, baseEdge.typeIndex), -- same as above but in a format constructions understand
                width = baseEdgeProperties.trackDistance,
                era = trackUtils.getEraPrefix(baseEdgeTrack.trackType)
            }
            results[#results+1] = result
        end

        return results
    end,

    getAllEdgeObjectsWithModelIdOLD = function(refModelId, searchRadius)
        -- too slow
        if not(searchRadius) then searchRadius = 99999 end
        local results = {}
        local nearbyEdgeIds = edgeUtils.getNearbyObjectIds(_constants.idTransf, searchRadius, api.type.ComponentType.BASE_EDGE)
        -- print('nearbyEdgeIds =')
        -- debugPrint(nearbyEdgeIds)
        for _, edgeId in pairs(nearbyEdgeIds) do
            local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
            if baseEdge ~= nil and baseEdge.objects ~= nil then
                local edgeObjectIds = edgeUtils.getEdgeObjectsIdsWithModelId(baseEdge.objects, refModelId)
                for _, edgeObjectId in pairs(edgeObjectIds) do
                    arrayUtils.addUnique(results, edgeObjectId)
                end
            end
        end

        -- print('getAllEdgeObjectsWithModelId is about to return') debugPrint(results)
        return results
    end,

    getAllEdgeObjectsWithModelId = function(refModelId)
        if not(edgeUtils.isValidAndExistingId(refModelId)) then return {} end

        local _map = api.engine.system.streetSystem.getEdgeObject2EdgeMap()
        local edgeObjectIds = {}
        for edgeObjectId, edgeId in pairs(_map) do
            edgeObjectIds[#edgeObjectIds+1] = edgeObjectId
        end

        return edgeUtils.getEdgeObjectsIdsWithModelId2(edgeObjectIds, refModelId)
    end,

    getOuterNodes = function(contiguousEdgeIds, trackType)
        -- only for testing
        local _hasOnlyOneEdgeOfType1 = function(nodeId, map)
            if not(edgeUtils.isValidAndExistingId(nodeId)) or not(trackType) then return false end

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
        local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()
        local _baseEdgeFirst = api.engine.getComponent(contiguousEdgeIds[1], api.type.ComponentType.BASE_EDGE)
        local _baseEdgeLast = api.engine.getComponent(contiguousEdgeIds[#contiguousEdgeIds], api.type.ComponentType.BASE_EDGE)
        if _hasOnlyOneEdgeOfType1(_baseEdgeFirst.node0, _map) then
            results[#results+1] = _baseEdgeFirst.node0
        elseif _hasOnlyOneEdgeOfType1(_baseEdgeFirst.node1, _map) then
            results[#results+1] = _baseEdgeFirst.node1
        end
        if _hasOnlyOneEdgeOfType1(_baseEdgeLast.node0, _map) then
            results[#results+1] = _baseEdgeLast.node0
        elseif _hasOnlyOneEdgeOfType1(_baseEdgeLast.node1, _map) then
            results[#results+1] = _baseEdgeLast.node1
        end

        return results
    end,

    getCentralEdgePositions = function(edgeLists, maxEdgeLength, addTerrainHeight)
        -- print('getCentralEdgePositions starting')
        if type(edgeLists) ~= 'table' then return {} end

        local leadingIndex = 0
        local results = {}
        for _, pel in pairs(edgeLists) do
            leadingIndex = leadingIndex + 1
            local edgeLength = (transfUtils.getVectorLength(pel.posTanX2[1][2]) + transfUtils.getVectorLength(pel.posTanX2[2][2])) * 0.5
            -- print('edgeLength =') debugPrint(edgeLength)
            local nModelsInEdge = math.ceil(edgeLength / maxEdgeLength)
            -- print('nModelsInEdge =') debugPrint(nModelsInEdge)

            local edgeResults = {}
            local lengthCovered = 0
            local previousNodeBetween = nil
            for i = 1, nModelsInEdge do
                -- print('i == ', i)
                -- print('i / nModelsInEdge =', i / nModelsInEdge)
                local nodeBetween = edgeUtils.getNodeBetween(
                    transfUtils.oneTwoThree2XYZ(pel.posTanX2[1][1]),
                    transfUtils.oneTwoThree2XYZ(pel.posTanX2[2][1]),
                    transfUtils.oneTwoThree2XYZ(pel.posTanX2[1][2]),
                    transfUtils.oneTwoThree2XYZ(pel.posTanX2[2][2]),
                    i / nModelsInEdge
                )
                -- print('nodeBetween =') debugPrint(nodeBetween)
                if nodeBetween == nil then
                    print('ERROR: nodeBetween not found')
                    print('pel =') debugPrint(pel)
                    return {}
                end
                local newEdgeLength = nodeBetween.refDistance0 - lengthCovered
                -- print('newEdgeLength =', newEdgeLength)
                -- print('lengthCovered =', lengthCovered)
                if i == 1 then
                    edgeResults[#edgeResults+1] = {
                        posTanX2 = {
                            {
                                {
                                    pel.posTanX2[1][1][1],
                                    pel.posTanX2[1][1][2],
                                    pel.posTanX2[1][1][3],
                                },
                                {
                                    pel.posTanX2[1][2][1] * newEdgeLength / edgeLength,
                                    pel.posTanX2[1][2][2] * newEdgeLength / edgeLength,
                                    pel.posTanX2[1][2][3] * newEdgeLength / edgeLength,
                                }
                            },
                            {
                                {
                                    nodeBetween.position.x,
                                    nodeBetween.position.y,
                                    nodeBetween.position.z,
                                },
                                {
                                    nodeBetween.tangent.x * newEdgeLength,
                                    nodeBetween.tangent.y * newEdgeLength,
                                    nodeBetween.tangent.z * newEdgeLength,
                                }
                            },
                        },
                    }
                elseif i == nModelsInEdge then
                    edgeResults[#edgeResults+1] = {
                        posTanX2 = {
                            {
                                {
                                    previousNodeBetween.position.x,
                                    previousNodeBetween.position.y,
                                    previousNodeBetween.position.z,
                                },
                                {
                                    previousNodeBetween.tangent.x * newEdgeLength,
                                    previousNodeBetween.tangent.y * newEdgeLength,
                                    previousNodeBetween.tangent.z * newEdgeLength,
                                }
                            },
                            {
                                {
                                    pel.posTanX2[2][1][1],
                                    pel.posTanX2[2][1][2],
                                    pel.posTanX2[2][1][3],
                                },
                                {
                                    pel.posTanX2[2][2][1] * newEdgeLength / edgeLength,
                                    pel.posTanX2[2][2][2] * newEdgeLength / edgeLength,
                                    pel.posTanX2[2][2][3] * newEdgeLength / edgeLength,
                                }
                            },
                        },
                    }
                else
                    edgeResults[#edgeResults+1] = {
                        posTanX2 = {
                            {
                                {
                                    previousNodeBetween.position.x,
                                    previousNodeBetween.position.y,
                                    previousNodeBetween.position.z,
                                },
                                {
                                    previousNodeBetween.tangent.x * newEdgeLength,
                                    previousNodeBetween.tangent.y * newEdgeLength,
                                    previousNodeBetween.tangent.z * newEdgeLength,
                                }
                            },
                            {
                                {
                                    nodeBetween.position.x,
                                    nodeBetween.position.y,
                                    nodeBetween.position.z,
                                },
                                {
                                    nodeBetween.tangent.x * newEdgeLength,
                                    nodeBetween.tangent.y * newEdgeLength,
                                    nodeBetween.tangent.z * newEdgeLength,
                                }
                            },
                        },
                    }
                end
                edgeResults[#edgeResults].catenary = pel.catenary
                edgeResults[#edgeResults].leadingIndex = leadingIndex
                if addTerrainHeight then
                    edgeResults[#edgeResults].terrainHeight1 = api.engine.terrain.getBaseHeightAt(api.type.Vec2f.new(
                        edgeResults[#edgeResults].posTanX2[1][1][1],
                        edgeResults[#edgeResults].posTanX2[1][1][2]
                    ))
                    -- edgeResults[#edgeResults].terrainHeight2 = api.engine.terrain.getBaseHeightAt(api.type.Vec2f.new(
                    --     edgeResults[#edgeResults].posTanX2[2][1][1],
                    --     edgeResults[#edgeResults].posTanX2[2][1][2]
                    -- ))
                end
                edgeResults[#edgeResults].trackType = pel.trackType
                edgeResults[#edgeResults].trackTypeName = pel.trackTypeName
                edgeResults[#edgeResults].type = pel.type
                edgeResults[#edgeResults].typeIndex = pel.typeIndex
                edgeResults[#edgeResults].width = pel.width or 0
                edgeResults[#edgeResults].era = pel.era or trackUtils.eras.era_c.prefix

                lengthCovered = nodeBetween.refDistance0
                previousNodeBetween = nodeBetween
            end

            for _, value in pairs(edgeResults) do
                results[#results+1] = value
            end
        end

        -- print('getCentralEdgePositions results =') debugPrint(results)
        return results
    end,

    getShiftedEdgePositionsOLD = function(edgeLists, sideShift)
        local results = {
            {
                -- catenary = edgeLists[1].catenary,
                posTanX2 = transfUtils.getParallelSideways(edgeLists[1].posTanX2, sideShift),
                -- trackType = edgeLists[1].trackType,
                -- trackTypeName = edgeLists[1].trackTypeName,
                -- type = edgeLists[1].type,
                -- typeIndex = edgeLists[1].typeIndex
            }
        }
        local previousPosTanX2 = results[1].posTanX2
        for i = 2, #edgeLists do
            local currentPosTanX2 = transfUtils.getParallelSideways(edgeLists[i].posTanX2, sideShift)
            currentPosTanX2[1][1] = previousPosTanX2[2][1]
            results[#results+1] = {
                -- catenary = edgeLists[i].catenary,
                posTanX2 = currentPosTanX2,
                -- trackType = edgeLists[i].trackType,
                -- trackTypeName = edgeLists[i].trackTypeName,
                -- type = edgeLists[i].type,
                -- typeIndex = edgeLists[i].typeIndex
            }
            previousPosTanX2 = currentPosTanX2
        end

        return results
    end,

    getShiftedEdgePositions = function(edgeLists, sideShift, index1, indexN)
        local i1 = index1
        local iN = indexN
        if type(i1) ~= 'number' or i1 < 1 then i1 = 1 end
        if type(iN) ~= 'number' or iN > #edgeLists then iN = #edgeLists end

        local results = {}
        for i = i1, iN do
            results[#results+1] = {
                -- catenary = edgeLists[i].catenary,
                leadingIndex = edgeLists[i].leadingIndex,
                posTanX2 = transfUtils.getParallelSideways(edgeLists[i].posTanX2, sideShift),
                -- trackType = edgeLists[i].trackType,
                -- trackTypeName = edgeLists[i].trackTypeName,
                -- type = edgeLists[i].type,
                -- typeIndex = edgeLists[i].typeIndex
            }
        end

        for i = 1, #results - 1 do
            local pos1 = results[i].posTanX2[2][1]
            local pos2 = results[i + 1].posTanX2[1][1]
            if pos1[1] ~= pos2[1] or pos1[2] ~= pos2[2] or pos1[3] ~= pos2[3] then
                -- an average is cheaper than working out the intersection
                local oldLength1 = transfUtils.getPositionsDistance(results[i].posTanX2[1][1], results[i].posTanX2[2][1])
                local oldLength2 = transfUtils.getPositionsDistance(results[i + 1].posTanX2[1][1], results[i + 1].posTanX2[2][1])

                local newPos = transfUtils.getPositionsMiddle(pos1, pos2)
                local newLength1 = transfUtils.getPositionsDistance(results[i].posTanX2[1][1], newPos)
                local newLength2 = transfUtils.getPositionsDistance(newPos, results[i + 1].posTanX2[2][1])
                local tanCorrectionFactor1 = newLength1 / oldLength1
                local tanCorrectionFactor2 = newLength2 / oldLength2

                results[i].posTanX2[2][1] = newPos
                results[i].posTanX2[2][2] = {
                    results[i].posTanX2[2][2][1] * tanCorrectionFactor1,
                    results[i].posTanX2[2][2][2] * tanCorrectionFactor1,
                    results[i].posTanX2[2][2][3] * tanCorrectionFactor1,
                }

                results[i + 1].posTanX2[1][1] = newPos
                results[i + 1].posTanX2[1][2] = {
                    results[i + 1].posTanX2[1][2][1] * tanCorrectionFactor2,
                    results[i + 1].posTanX2[1][2][2] * tanCorrectionFactor2,
                    results[i + 1].posTanX2[1][2][3] * tanCorrectionFactor2,
                }
            end
        end

        return results
    end,

    getCrossConnectors = function(leftPlatforms, centrePlatforms, rightPlatforms, isTrackOnPlatformLeft)
        local results = {}
        for i = 1, #centrePlatforms do
            local centrePosTanX2 = centrePlatforms[i].posTanX2

            if isTrackOnPlatformLeft then
                local leftPosTanX2 = leftPlatforms[i].posTanX2
                local newTanLeft = {
                    centrePosTanX2[1][1][1] - leftPosTanX2[1][1][1],
                    centrePosTanX2[1][1][2] - leftPosTanX2[1][1][2],
                    centrePosTanX2[1][1][3] - leftPosTanX2[1][1][3],
                }
                local newRecordLeft = {
                    {
                        leftPosTanX2[1][1],
                        newTanLeft
                    },
                    {
                        centrePosTanX2[1][1],
                        newTanLeft
                    }
                }
                results[#results+1] = { posTanX2 = newRecordLeft }
            else
                local rightPosTanX2 = rightPlatforms[i].posTanX2
                local newTanRight = {
                    centrePosTanX2[1][1][1] - rightPosTanX2[1][1][1],
                    centrePosTanX2[1][1][2] - rightPosTanX2[1][1][2],
                    centrePosTanX2[1][1][3] - rightPosTanX2[1][1][3],
                }
                local newRecordRight = {
                    {
                        rightPosTanX2[1][1],
                        newTanRight
                    },
                    {
                        centrePosTanX2[1][1],
                        newTanRight
                    },
                }
                results[#results+1] = { posTanX2 = newRecordRight }
            end
        end

        return results
    end,

    getCrossConnectors_ONE_MORE_ITEM_BUT_USELESS_4_PRACTICAL_PURPOSES = function(leftPlatforms, centrePlatforms, rightPlatforms, isTrackOnPlatformLeft)
        local results = {}

        for i = 1, #centrePlatforms + 1 do -- there are N segments and N + 1 nodes, hence the extra complexity
            local isAddingLast = i > #centrePlatforms
            local centrePosTanX2 = isAddingLast and centrePlatforms[#centrePlatforms].posTanX2 or centrePlatforms[i].posTanX2
            local posTanX2Index = isAddingLast and 2 or 1

            if isTrackOnPlatformLeft then
                local leftPosTanX2 = isAddingLast and leftPlatforms[#centrePlatforms].posTanX2 or leftPlatforms[i].posTanX2
                local newTanLeft = {
                    centrePosTanX2[posTanX2Index][1][1] - leftPosTanX2[posTanX2Index][1][1],
                    centrePosTanX2[posTanX2Index][1][2] - leftPosTanX2[posTanX2Index][1][2],
                    centrePosTanX2[posTanX2Index][1][3] - leftPosTanX2[posTanX2Index][1][3],
                }
                local newRecordLeft = {
                    {
                        leftPosTanX2[posTanX2Index][1],
                        newTanLeft
                    },
                    {
                        centrePosTanX2[posTanX2Index][1],
                        newTanLeft
                    }
                }
                results[#results+1] = { posTanX2 = newRecordLeft }
            else
                local rightPosTanX2 = isAddingLast and rightPlatforms[#centrePlatforms].posTanX2 or rightPlatforms[i].posTanX2
                local newTanRight = {
                    centrePosTanX2[posTanX2Index][1][1] - rightPosTanX2[posTanX2Index][1][1],
                    centrePosTanX2[posTanX2Index][1][2] - rightPosTanX2[posTanX2Index][1][2],
                    centrePosTanX2[posTanX2Index][1][3] - rightPosTanX2[posTanX2Index][1][3],
                }
                local newRecordRight = {
                    {
                        rightPosTanX2[posTanX2Index][1],
                        newTanRight
                    },
                    {
                        centrePosTanX2[posTanX2Index][1],
                        newTanRight
                    },
                }
                results[#results+1] = { posTanX2 = newRecordRight }
            end
        end

        return results
    end,

    getWhichEdgeGetsEdgeObjectAfterSplit = function(edgeObjPosition, node0pos, node1pos, nodeBetween)
        local result = {
            -- assignToFirstEstimate = nil,
            assignToSecondEstimate = nil,
        }
        -- print('LOLLO attempting to place edge object with position =')
        -- debugPrint(edgeObjPosition)
        -- print('wholeEdge.node0pos =') debugPrint(node0pos)
        -- print('nodeBetween.position =') debugPrint(nodeBetween.position)
        -- print('nodeBetween.tangent =') debugPrint(nodeBetween.tangent)
        -- print('wholeEdge.node1pos =') debugPrint(node1pos)
        -- first estimator
        -- local nodeBetween_Node0_Distance = transfUtils.getVectorLength({
        --     nodeBetween.position.x - node0pos[1],
        --     nodeBetween.position.y - node0pos[2]
        -- })
        -- local nodeBetween_Node1_Distance = transfUtils.getVectorLength({
        --     nodeBetween.position.x - node1pos[1],
        --     nodeBetween.position.y - node1pos[2]
        -- })
        -- local edgeObj_Node0_Distance = transfUtils.getVectorLength({
        --     edgeObjPosition[1] - node0pos[1],
        --     edgeObjPosition[2] - node0pos[2]
        -- })
        -- local edgeObj_Node1_Distance = transfUtils.getVectorLength({
        --     edgeObjPosition[1] - node1pos[1],
        --     edgeObjPosition[2] - node1pos[2]
        -- })
        -- if edgeObj_Node0_Distance < nodeBetween_Node0_Distance then
        --     result.assignToFirstEstimate = 0
        -- elseif edgeObj_Node1_Distance < nodeBetween_Node1_Distance then
        --     result.assignToFirstEstimate = 1
        -- end

        -- second estimator
        local edgeObjPosition_assignTo = nil
        local node0_assignTo = nil
        local node1_assignTo = nil
        -- at nodeBetween, I can draw the normal to the road:
        -- y = a + bx
        -- the angle is alpha = atan2(nodeBetween.tangent.y, nodeBetween.tangent.x) + PI / 2
        -- so b = math.tan(alpha)
        -- a = y - bx
        -- so a = nodeBetween.position.y - b * nodeBetween.position.x
        -- points under this line will go one way, the others the other way
        local alpha = math.atan2(nodeBetween.tangent.y, nodeBetween.tangent.x) + math.pi * 0.5
        local b = math.tan(alpha)
        if math.abs(b) < 1e+06 then
            local a = nodeBetween.position.y - b * nodeBetween.position.x
            if a + b * edgeObjPosition[1] > edgeObjPosition[2] then -- edgeObj is below the line
                edgeObjPosition_assignTo = 0
            else
                edgeObjPosition_assignTo = 1
            end
            if a + b * node0pos[1] > node0pos[2] then -- wholeEdge.node0pos is below the line
                node0_assignTo = 0
            else
                node0_assignTo = 1
            end
            if a + b * node1pos[1] > node1pos[2] then -- wholeEdge.node1pos is below the line
                node1_assignTo = 0
            else
                node1_assignTo = 1
            end
        -- if b grows too much, I lose precision, so I approximate it with the y axis
        else
            -- print('alpha =', alpha, 'b =', b)
            if edgeObjPosition[1] > nodeBetween.position.x then
                edgeObjPosition_assignTo = 0
            else
                edgeObjPosition_assignTo = 1
            end
            if node0pos[1] > nodeBetween.position.x then
                node0_assignTo = 0
            else
                node0_assignTo = 1
            end
            if node1pos[1] > nodeBetween.position.x then
                node1_assignTo = 0
            else
                node1_assignTo = 1
            end
        end

        if edgeObjPosition_assignTo == node0_assignTo then
            result.assignToSecondEstimate = 0
        elseif edgeObjPosition_assignTo == node1_assignTo then
            result.assignToSecondEstimate = 1
        end

        -- print('LOLLO assignment =') debugPrint(result)
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

    getProposal2ReplaceEdgeWithSameRemovingObject = function(oldEdgeId, objectIdToRemove)
        -- replaces a track segment with an identical one, without destroying the buildings
        if not(edgeUtils.isValidAndExistingId(oldEdgeId)) then return false end

        local oldEdge = api.engine.getComponent(oldEdgeId, api.type.ComponentType.BASE_EDGE)
        local oldEdgeTrack = api.engine.getComponent(oldEdgeId, api.type.ComponentType.BASE_EDGE_TRACK)
        -- save a crash when a modded road underwent a breaking change, so it has no oldEdgeTrack
        if oldEdge == nil or oldEdgeTrack == nil then return false end

        local newEdge = api.type.SegmentAndEntity.new()
        newEdge.entity = -1
        newEdge.type = _constants.railEdgeType
        -- newEdge.comp = oldEdge -- no good enough if I want to remove objects, the api moans
        newEdge.comp.node0 = oldEdge.node0
        newEdge.comp.node1 = oldEdge.node1
        newEdge.comp.tangent0 = oldEdge.tangent0
        newEdge.comp.tangent1 = oldEdge.tangent1
        newEdge.comp.type = oldEdge.type -- respect bridge or tunnel
        newEdge.comp.typeIndex = oldEdge.typeIndex -- respect type of bridge or tunnel
        newEdge.playerOwned = api.engine.getComponent(oldEdgeId, api.type.ComponentType.PLAYER_OWNED)
        newEdge.trackEdge = oldEdgeTrack
        if trackUtils.isPlatform(oldEdgeTrack.trackType) then
            newEdge.trackEdge.catenary = false
        end

        -- print('edgeUtils.isValidId(objectIdToRemove) =', edgeUtils.isValidId(objectIdToRemove))
        -- print('edgeUtils.isValidAndExistingId(objectIdToRemove) =', edgeUtils.isValidAndExistingId(objectIdToRemove))
        if edgeUtils.isValidId(objectIdToRemove) then
            local edgeObjects = {}
            for _, edgeObj in pairs(oldEdge.objects) do
                if edgeObj[1] ~= objectIdToRemove then
                    table.insert(edgeObjects, { edgeObj[1], edgeObj[2] })
                end
            end
            if #edgeObjects > 0 then
                newEdge.comp.objects = edgeObjects -- LOLLO NOTE cannot insert directly into edge0.comp.objects
                -- print('replaceEdgeWithSameRemovingObject: newEdge.comp.objects =') debugPrint(newEdge.comp.objects)
            else
                -- print('replaceEdgeWithSameRemovingObject: newEdge.comp.objects = not changed')
            end
        else
            print('replaceEdgeWithSameRemovingObject: objectIdToRemove is no good, it is') debugPrint(objectIdToRemove)
            newEdge.comp.objects = oldEdge.objects
        end

        -- print('newEdge.comp.objects:')
        -- for key, value in pairs(newEdge.comp.objects) do
        --     print('key =', key) debugPrint(value)
        -- end

        local proposal = api.type.SimpleProposal.new()
        proposal.streetProposal.edgesToRemove[1] = oldEdgeId
        proposal.streetProposal.edgesToAdd[1] = newEdge
        if edgeUtils.isValidAndExistingId(objectIdToRemove) then
            proposal.streetProposal.edgeObjectsToRemove[1] = objectIdToRemove
        end

        return proposal
    end,

    getNeighbourNodeIdsOfBulldozedTerminal = function(platformEdgeLists, trackEdgeLists)
        print('getNeighbourNodeIdsOfBulldozedTerminal starting')

        local result = {
            platforms = {
                node1 = nil,
                node2 = nil
            },
            tracks = {
                node1 = nil,
                node2 = nil
            }
        }

        if type(platformEdgeLists) == 'table' and #platformEdgeLists > 0 then
            result.platforms.node1 = edgeUtils.getNearbyObjectIds(
                transfUtils.position2Transf(platformEdgeLists[1].posTanX2[1][1]), 0.001, api.type.ComponentType.BASE_NODE
            )[1] -- LOLLO TODO what if it finds two nodes? How do I make sure it will take the best one? Same applies to the brothers below.
            result.platforms.node2 = edgeUtils.getNearbyObjectIds(
                transfUtils.position2Transf(platformEdgeLists[#platformEdgeLists].posTanX2[2][1]), 0.001, api.type.ComponentType.BASE_NODE
            )[1]
        end
        if type(trackEdgeLists) == 'table' and #trackEdgeLists > 0 then
            result.tracks.node1 = edgeUtils.getNearbyObjectIds(
                transfUtils.position2Transf(trackEdgeLists[1].posTanX2[1][1]), 0.001, api.type.ComponentType.BASE_NODE
            )[1]
            result.tracks.node2 = edgeUtils.getNearbyObjectIds(
                transfUtils.position2Transf(trackEdgeLists[#trackEdgeLists].posTanX2[2][1]), 0.001, api.type.ComponentType.BASE_NODE
            )[1]
        end
        -- print('getNeighbourNodeIdsOfBulldozedTerminal about to return') debugPrint(result)
        return result
    end,
}

local _getStationEndNodeIds4T = function(con, nTerminal, frozenEdges, frozenNodes)
    -- print('getStationEndNodesUnsorted starting, nTerminal =', nTerminal)
    -- print('getStationEndNodesUnsorted, con =') debugPrint(con)
    -- con contains fileName, params, transf, timeBuilt, frozenNodes, frozenEdges, depots, stations
    -- we may want to respect frozen edges and nodes of other constructions, too, so we import them
    -- instead of picking them from the current station.
    if not(con) or con.fileName ~= _constants.stationConFileName then
        return {}
    end

    local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()
    local _getNodeId = function(nodePosition, otherEdgeNodePosition)
        -- print('nodePosition =') debugPrint(nodePosition)
        -- print('otherEdgeNodePosition =') debugPrint(otherEdgeNodePosition)
        local nearbyNodeIds = edgeUtils.getNearbyObjectIds(transfUtils.position2Transf(nodePosition), 0.001, api.type.ComponentType.BASE_NODE)
        -- print('nodeFunds =') debugPrint(nearbyNodeIds)
        for _, nodeId in pairs(nearbyNodeIds) do
            if _map[nodeId] ~= nil and not(arrayUtils.arrayHasValue(frozenNodes, nodeId)) then
                for _, edgeId in pairs(_map[nodeId]) do
                    if arrayUtils.arrayHasValue(frozenEdges, edgeId) then
                        local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
                        -- If I have two terminals after the other, as opposed to parallel,
                        -- nodeId could belong to the other terminal: to make sure, I check the other node attached to the same frozen edge.
                        if baseEdge.node0 == nodeId then
                            local otherBaseNode = api.engine.getComponent(baseEdge.node1, api.type.ComponentType.BASE_NODE)
                            -- print('baseEdge.node0 == nodeId, otherBaseNode =') debugPrint(otherBaseNode)
                            if otherBaseNode and otherBaseNode.position and edgeUtils.isXYZVeryClose(otherBaseNode.position, otherEdgeNodePosition, 4) then
                                return nodeId
                            end
                        elseif baseEdge.node1 == nodeId then
                            local otherBaseNode = api.engine.getComponent(baseEdge.node0, api.type.ComponentType.BASE_NODE)
                            -- print('baseEdge.node1 == nodeId, otherBaseNode =') debugPrint(otherBaseNode)
                            if otherBaseNode and otherBaseNode.position and edgeUtils.isXYZVeryClose(otherBaseNode.position, otherEdgeNodePosition, 4) then
                                return nodeId
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local result = {
        platforms = {
            node1Id = _getNodeId(con.params.terminals[nTerminal].platformEdgeLists[1].posTanX2[1][1], con.params.terminals[nTerminal].platformEdgeLists[1].posTanX2[2][1]),
            node2Id = _getNodeId(arrayUtils.getLast(con.params.terminals[nTerminal].platformEdgeLists).posTanX2[2][1], arrayUtils.getLast(con.params.terminals[nTerminal].platformEdgeLists).posTanX2[1][1])
        },
        tracks = {
            node1Id = _getNodeId(con.params.terminals[nTerminal].trackEdgeLists[1].posTanX2[1][1], con.params.terminals[nTerminal].trackEdgeLists[1].posTanX2[2][1]),
            node2Id = _getNodeId(arrayUtils.getLast(con.params.terminals[nTerminal].trackEdgeLists).posTanX2[2][1], arrayUtils.getLast(con.params.terminals[nTerminal].trackEdgeLists).posTanX2[1][1])
        }
    }

    if result.platforms.node1Id == nil then
        print('WARNING: could not find platformnode1Id in station construction')
        print('nTerminal =') debugPrint(nTerminal)
    end
    if result.platforms.node2Id == nil then
        print('WARNING: could not find platformnode2Id in station construction')
        print('nTerminal =') debugPrint(nTerminal)
    end
    if result.tracks.node1Id == nil then
        print('WARNING: could not find tracknode1Id in station construction')
        print('nTerminal =') debugPrint(nTerminal)
    end
    if result.tracks.node2Id == nil then
        print('WARNING: could not find tracknode2Id in station construction')
        print('nTerminal =') debugPrint(nTerminal)
    end

    return result
end

local _getStationEndEntities4T = function(con, t)
    -- con contains fileName, params, transf, timeBuilt, frozenNodes, frozenEdges, depots, stations
    -- print('con =') debugPrint(conData)
    if not(con) or con.fileName ~= _constants.stationConFileName then
        print('ERROR: _getStationEndEntities4T con.fileName =') debugPrint(con.fileName)
        return nil
    end

    local frozenEdgeIds = arrayUtils.cloneDeepOmittingFields(con.frozenEdges, {}, true)
    local frozenNodeIds = arrayUtils.cloneDeepOmittingFields(con.frozenNodes, {}, true)
    -- get all stations, not only mine? It does not seem necessary for now, and we also bar building close to a station, on top of it.
    -- This thing here works, just in case.
    -- local conTransf = transfUtilsUG.new(con.transf:cols(0), con.transf:cols(1), con.transf:cols(2), con.transf:cols(3))
    -- print('frozenEdges first =') debugPrint(frozenEdgeIds)
    -- print('frozenNodes first =') debugPrint(frozenNodeIds)
    -- local nearbyStations = helpers.getNearbyFreestyleStationsList(conTransf, _constants.searchRadius4NearbyStation2Join, true)
    -- for _, nearbyStation in pairs(nearbyStations) do
    --     print('nearbyStation =') debugPrint(nearbyStation)
    --     if edgeUtils.isValidAndExistingId(nearbyStation.id) then
    --         local nearbyCon = api.engine.getComponent(nearbyStation.id, api.type.ComponentType.CONSTRUCTION)
    --         print('nearbyCon found')
    --         print('#nearbyCon.frozenEdges = ', #nearbyCon.frozenEdges, 'nearbyCon.frozenEdges =') debugPrint(nearbyCon.frozenEdges)
    --         if nearbyCon and nearbyCon.frozenEdges then
    --             for _, frozenEdgeId in pairs(nearbyCon.frozenEdges) do
    --                 frozenEdgeIds[#frozenEdgeIds+1] = frozenEdgeId
    --             end
    --         end
    --         if nearbyCon and nearbyCon.frozenNodes then
    --             for _, frozenNodeId in pairs(nearbyCon.frozenNodes) do
    --                 frozenNodeIds[#frozenNodeIds+1] = frozenNodeId
    --             end
    --         end
    --     end
    -- end
    -- print('frozenEdges with neighbours =') debugPrint(frozenEdgeIds)
    -- print('frozenNodes with neighbours =') debugPrint(frozenNodeIds)

    local endNodeIds4T = _getStationEndNodeIds4T(con, t, frozenEdgeIds, frozenNodeIds)
    -- print('endNodeIds4T =') debugPrint(endNodeIds4T)
    -- I cannot clone these, for some reason: it dumps
    local platformNode1Position = edgeUtils.isValidAndExistingId(endNodeIds4T.platforms.node1Id)
        and api.engine.getComponent(endNodeIds4T.platforms.node1Id, api.type.ComponentType.BASE_NODE).position
        or nil
    local platformNode2Position = edgeUtils.isValidAndExistingId(endNodeIds4T.platforms.node2Id)
        and api.engine.getComponent(endNodeIds4T.platforms.node2Id, api.type.ComponentType.BASE_NODE).position
        or nil
    local trackNode1Position = edgeUtils.isValidAndExistingId(endNodeIds4T.tracks.node1Id)
        and api.engine.getComponent(endNodeIds4T.tracks.node1Id, api.type.ComponentType.BASE_NODE).position
        or nil
    local trackNode2Position = edgeUtils.isValidAndExistingId(endNodeIds4T.tracks.node2Id)
        and api.engine.getComponent(endNodeIds4T.tracks.node2Id, api.type.ComponentType.BASE_NODE).position
        or nil

    local result = {
        platforms = {
            -- these are empty or nil if the station has been snapped to its neighbours
            disjointNeighbourEdgeIds = {
                edge1Ids = {},
                edge2Ids = {}
            },
            -- same
            disjointNeighbourNodeIds = {
                node1Id = nil,
                node2Id = nil,
            },
            stationEndNodeIds = {
                node1Id = endNodeIds4T.platforms.node1Id,
                node2Id = endNodeIds4T.platforms.node2Id,
            },
            stationEndNodePositions = {
                node1 = platformNode1Position ~= nil and { x = platformNode1Position.x, y = platformNode1Position.y, z = platformNode1Position.z } or nil,
                node2 = platformNode2Position ~= nil and { x = platformNode2Position.x, y = platformNode2Position.y, z = platformNode2Position.z } or nil,
            }
        },
        tracks = {
            -- these are empty or nil if the station has been snapped to its neighbours, or if there are no neighbours.
            disjointNeighbourEdgeIds = {
                edge1Ids = {},
                edge2Ids = {}
            },
            -- same
            disjointNeighbourNodeIds = {
                node1Id = nil,
                node2Id = nil,
            },
            stationEndNodeIds = {
                node1Id = endNodeIds4T.tracks.node1Id,
                node2Id = endNodeIds4T.tracks.node2Id,
            },
            stationEndNodePositions = {
                node1 = trackNode1Position ~= nil and { x = trackNode1Position.x, y = trackNode1Position.y, z = trackNode1Position.z } or nil,
                node2 = trackNode2Position ~= nil and { x = trackNode2Position.x, y = trackNode2Position.y, z = trackNode2Position.z } or nil,
            }
        },
    }

    local _getDisjointNeighbourNodeId = function(stationNodeId, stationNodePosition)
        if not(edgeUtils.isValidAndExistingId(stationNodeId)) or stationNodePosition == nil then return nil end

        local nearbyNodeIds = edgeUtils.getNearbyObjectIds(
            transfUtils.position2Transf(stationNodePosition),
            0.001,
            api.type.ComponentType.BASE_NODE
        )
        -- print('getDisjointNeighbourNodes found') debugPrint(nearbyNodeIds)
        for _, nearbyNodeId in pairs(nearbyNodeIds) do
            if edgeUtils.isValidAndExistingId(nearbyNodeId)
            and nearbyNodeId ~= stationNodeId
            and not(arrayUtils.arrayHasValue(frozenNodeIds, nearbyNodeId))
            then
                return nearbyNodeId
            end
        end
        return nil
    end
    result.platforms.disjointNeighbourNodeIds.node1Id = _getDisjointNeighbourNodeId(result.platforms.stationEndNodeIds.node1Id, result.platforms.stationEndNodePositions.node1)
    result.platforms.disjointNeighbourNodeIds.node2Id = _getDisjointNeighbourNodeId(result.platforms.stationEndNodeIds.node2Id, result.platforms.stationEndNodePositions.node2)
    result.tracks.disjointNeighbourNodeIds.node1Id = _getDisjointNeighbourNodeId(result.tracks.stationEndNodeIds.node1Id, result.tracks.stationEndNodePositions.node1)
    result.tracks.disjointNeighbourNodeIds.node2Id = _getDisjointNeighbourNodeId(result.tracks.stationEndNodeIds.node2Id, result.tracks.stationEndNodePositions.node2)

    local _getDisjointNeighbourEdgeIds = function(nodeId)
        local results = {}
        local connectedEdgeIds = edgeUtils.getConnectedEdgeIds({nodeId})
        for _, edgeId in pairs(connectedEdgeIds) do
            if not(arrayUtils.arrayHasValue(frozenEdgeIds, edgeId)) then
                results[#results+1] = edgeId
            end
        end
        return results
    end
    -- result.platforms.disjointNeighbourEdgeIds.edge1Ids = edgeUtils.track.getConnectedEdgeIds({result.platforms.disjointNeighbourNodeIds.node1Id})
    -- result.platforms.disjointNeighbourEdgeIds.edge2Ids = edgeUtils.track.getConnectedEdgeIds({result.platforms.disjointNeighbourNodeIds.node2Id})
    -- result.tracks.disjointNeighbourEdgeIds.edge1Ids = edgeUtils.track.getConnectedEdgeIds({result.tracks.disjointNeighbourNodeIds.node1Id})
    -- result.tracks.disjointNeighbourEdgeIds.edge2Ids = edgeUtils.track.getConnectedEdgeIds({result.tracks.disjointNeighbourNodeIds.node2Id})
    result.platforms.disjointNeighbourEdgeIds.edge1Ids = _getDisjointNeighbourEdgeIds(result.platforms.disjointNeighbourNodeIds.node1Id)
    result.platforms.disjointNeighbourEdgeIds.edge2Ids = _getDisjointNeighbourEdgeIds(result.platforms.disjointNeighbourNodeIds.node2Id)
    result.tracks.disjointNeighbourEdgeIds.edge1Ids = _getDisjointNeighbourEdgeIds(result.tracks.disjointNeighbourNodeIds.node1Id)
    result.tracks.disjointNeighbourEdgeIds.edge2Ids = _getDisjointNeighbourEdgeIds(result.tracks.disjointNeighbourNodeIds.node2Id)

    -- print('_getStationEndEntities4T result =') debugPrint(result)
    return result
end

helpers.getStationEndEntities = function(stationConstructionId)
    print('getStationEndEntities started, conId =', stationConstructionId or 'NIL')
    if not(edgeUtils.isValidAndExistingId(stationConstructionId)) then
        print('ERROR: getStationEndEntities invalid stationConstructionId') debugPrint(stationConstructionId)
        return nil
    end

    local con = api.engine.getComponent(stationConstructionId, api.type.ComponentType.CONSTRUCTION)
    -- con contains fileName, params, transf, timeBuilt, frozenNodes, frozenEdges, depots, stations
    -- print('con =') debugPrint(conData)
    if not(con) or con.fileName ~= _constants.stationConFileName then
        print('ERROR: getStationEndEntities con.fileName =') debugPrint(con.fileName)
        return nil
    end

    local result = {}
    for t = 1, #con.params.terminals do
        result[t] = _getStationEndEntities4T(con, t)
    end

    -- print('getStationEndEntities result =') debugPrint(result)
    return result
end

helpers.getStationEndEntities4T = function(stationConstructionId, t)
    if not(edgeUtils.isValidAndExistingId(stationConstructionId)) then
        print('ERROR: getStationEndEntities4T invalid stationConstructionId') debugPrint(stationConstructionId)
        return nil
    end

    local con = api.engine.getComponent(stationConstructionId, api.type.ComponentType.CONSTRUCTION)
    -- con contains fileName, params, transf, timeBuilt, frozenNodes, frozenEdges, depots, stations
    -- print('con =') debugPrint(conData)
    if not(con) or con.fileName ~= _constants.stationConFileName then
        print('ERROR: getStationEndEntities4T con.fileName =') debugPrint(con.fileName)
        return nil
    end

    if type(t) ~= 'number' or t < 1 or t > #con.params.terminals then
        print('Warning: getStationEndEntities4T received invalid t =') debugPrint(t)
        return nil
    end

    return _getStationEndEntities4T(con, t)
end

helpers.getTrackEdgeIdsBetweenEdgeIdsOLD = function(_edge1Id, _edge2Id)
    -- this function returns the ids in the right sequence, but their node0 and node1 may be scrambled,
    -- depending how the user laid the tracks
    print('getTrackEdgeIdsBetweenEdgeIdsOLD starting, _edge1Id =', _edge1Id, '_edge2Id =', _edge2Id)
    -- the output is sorted by sequence, from edge1 to edge2
    print('one, _edge1Id =', _edge1Id, '_edge2Id =', _edge2Id)
    if not(edgeUtils.isValidAndExistingId(_edge1Id)) then return {} end
    if not(edgeUtils.isValidAndExistingId(_edge2Id)) then return {} end
    print('two')
    if _edge1Id == _edge2Id then return { _edge1Id } end
    print('three')
    local _baseEdge1 = api.engine.getComponent(
        _edge1Id,
        api.type.ComponentType.BASE_EDGE
    )
    local _baseEdge2 = api.engine.getComponent(
        _edge2Id,
        api.type.ComponentType.BASE_EDGE
    )
    if _baseEdge1 == nil or _baseEdge2 == nil then return {} end
    print('four')
    local _baseEdgeTrack2 = api.engine.getComponent(_edge2Id, api.type.ComponentType.BASE_EDGE_TRACK)
    if not(_baseEdgeTrack2) then return {} end
    print('five')
    -- local _trackType2 = _baseEdgeTrack2.trackType
    local _isTrack2Platform = trackUtils.isPlatform(_baseEdgeTrack2.trackType)

    local _isTrackEdgeContiguousTo2 = function(baseEdge)
        return baseEdge.node0 == _baseEdge2.node0 or baseEdge.node0 == _baseEdge2.node1
            or baseEdge.node1 == _baseEdge2.node0 or baseEdge.node1 == _baseEdge2.node1
    end

    local _isTrackEdgesSameTypeAs2 = function(edgeId)
        local baseEdgeTrack = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE_TRACK)
        -- return baseEdgeTrack ~= nil and baseEdgeTrack.trackType == _trackType2
        return trackUtils.isPlatform(baseEdgeTrack.trackType) == _isTrack2Platform
    end

    if _isTrackEdgeContiguousTo2(_baseEdge1) then
        if _isTrackEdgesSameTypeAs2(_edge1Id) then
            print('six')
            if _baseEdge1.node1 == _baseEdge2.node0 then
                print('six point one')
                return { _edge1Id, _edge2Id }
            else
                print('six point two')
                return { _edge2Id, _edge1Id }
            end
        end
        print('seven')
        return {}
    end

    local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()

    local _getEdgesBetween1and2 = function(node0Or1FieldName)
        local baseEdge1 = _baseEdge1
        local edge1Id = _edge1Id
        local edgeIds = { _edge1Id }

        local _fetchEdgeConnectedToNode = function(nodeId)
            local adjacentEdgeIds = _map[nodeId] -- userdata
            if adjacentEdgeIds == nil then
                print('nine')
                return 0
            end
            -- we don't deal with intersections for now
            -- LOLLO NOTE even if we did, the game will have trouble when we bulldoze the tracks,
            -- if some of them cross an intersection
            if #adjacentEdgeIds > 2 then
                print('nine and a half')
                return 0
            end
            for _, edgeId in pairs(adjacentEdgeIds) do -- cannot use adjacentEdgeIds[index] here, it's fucking userdata
                print('ten')
                if not(arrayUtils.arrayHasValue(edgeIds, edgeId)) and _isTrackEdgesSameTypeAs2(edgeId) then
                    print('eleven')
                    edge1Id = edgeId
                    edgeIds[#edgeIds+1] = edge1Id
                    baseEdge1 = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
                    if _isTrackEdgeContiguousTo2(baseEdge1) then
                        print('twelve')
                        edgeIds[#edgeIds+1] = _edge2Id
                        return 2
                    end
                    return 1
                end
            end
            return 0
        end

        local nodeId = baseEdge1[node0Or1FieldName]
        print('nodeId =', nodeId)
        local counter = 0
        while counter < 100 do
            counter = counter + 1
            print('eight, counter =', counter, 'nodeId =', nodeId)
            local fetchResult = _fetchEdgeConnectedToNode(nodeId)
            if fetchResult == 0 then
                print('thirteen')
                return false
            elseif fetchResult == 1 then
                -- make new nodeId
                if nodeId == baseEdge1.node0 then nodeId = baseEdge1.node1 else nodeId = baseEdge1.node0 end
                print('fourteen, new nodeId =', nodeId)
            else
                -- success
                print('fifteen')
                return edgeIds
            end
        end

        return false
    end

    local node0Results = _getEdgesBetween1and2('node0')
    print('node0results =') debugPrint(node0Results)
    if node0Results ~= false then
        if node0Results[1] == _edge1Id then print('sixteen') return node0Results
        else print('seventeen') return arrayUtils.getReversed(node0Results)
        end
    end

    -- nothing good found, try in the opposite direction
    local node1Results = _getEdgesBetween1and2('node1')
    print('node1results =') debugPrint(node1Results)
    if node1Results ~= false then
        if node1Results[1] == _edge1Id then print('eighteen') return node1Results
        else print('nineteen') return arrayUtils.getReversed(node1Results)
        end
    end

    return {}
end

helpers.getTrackEdgeIdsBetweenNodeIdsOLD = function(_node1Id, _node2Id)
-- sometimes, this function returns an empty array when it could actually return something useful
    print('getTrackEdgeIdsBetweenNodeIdsOLD starting')
    print('node1Id =', _node1Id)
    print('node2Id =', _node2Id)
    print('ONE')
    if not(edgeUtils.isValidAndExistingId(_node1Id)) then return {} end
    if not(edgeUtils.isValidAndExistingId(_node2Id)) then return {} end
    print('TWO')
    if _node1Id == _node2Id then return {} end
    print('THREE')

    local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()
    local adjacentEdge1Ids = {}
    local adjacentEdge2Ids = {}
    local _fetchAdjacentEdges = function()
        local adjacentEdge1IdsUserdata = _map[_node1Id] -- userdata
        local adjacentEdge2IdsUserdata = _map[_node2Id] -- userdata
        if adjacentEdge1IdsUserdata == nil then
            print('FOUR')
            return false
        else
            for _, edgeId in pairs(adjacentEdge1IdsUserdata) do -- cannot use adjacentEdgeIds[index] here
                -- arrayUtils.addUnique(adjacentEdge1Ids, edgeId)
                adjacentEdge1Ids[#adjacentEdge1Ids+1] = edgeId
            end
            print('FIVE')
        end
        if adjacentEdge2IdsUserdata == nil then
            print('SIX')
            return false
        else
            for _, edgeId in pairs(adjacentEdge2IdsUserdata) do -- cannot use adjacentEdgeIds[index] here
                -- arrayUtils.addUnique(adjacentEdge2Ids, edgeId)
                adjacentEdge2Ids[#adjacentEdge2Ids+1] = edgeId
            end
            print('SEVEN')
        end

        return true
    end

    if not(_fetchAdjacentEdges()) then print('SEVEN HALF') return {} end
    if #adjacentEdge1Ids < 1 or #adjacentEdge2Ids < 1 then print('EIGHT') return {} end

    if #adjacentEdge1Ids == 1 and #adjacentEdge2Ids == 1 then
        if adjacentEdge1Ids[1] == adjacentEdge2Ids[1] then
            print('NINE')
            return { adjacentEdge1Ids[1] }
        else
            print('TEN')
        --     return {}
        end
    end

    local trackEdgePropsBetweenEdgeIds = helpers.getTrackEdgePropsBetweenEdgeIds(adjacentEdge1Ids[1], adjacentEdge2Ids[1])
    local trackEdgeIdsBetweenEdgeIds = {}
    for _, value in pairs(trackEdgePropsBetweenEdgeIds) do
        trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds+1] = value.entity
    end
    print('trackEdgeIdsBetweenEdgeIds before pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
    -- print('adjacentEdge1Ids =') debugPrint(adjacentEdge1Ids)
    -- print('adjacentEdge2Ids =') debugPrint(adjacentEdge2Ids)
    -- remove edges adjacent to but outside node1 and node2

    -- for _, edgeId in pairs(trackEdgeIdsBetweenEdgeIds) do
    --     local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
    --     print('base edge = ', edgeId) debugPrint(baseEdge)
    -- end

    local isExit = false
    while not(isExit) do
        if #trackEdgeIdsBetweenEdgeIds > 1
        and arrayUtils.arrayHasValue(adjacentEdge1Ids, trackEdgeIdsBetweenEdgeIds[1])
        and arrayUtils.arrayHasValue(adjacentEdge1Ids, trackEdgeIdsBetweenEdgeIds[2]) then
            print('ELEVEN')
            table.remove(trackEdgeIdsBetweenEdgeIds, 1)
            print('trackEdgeIdsBetweenEdgeIds during pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
        else
            print('TWELVE')
            isExit = true
        end
    end
    isExit = false
    while not(isExit) do
        if #trackEdgeIdsBetweenEdgeIds > 1
        and arrayUtils.arrayHasValue(adjacentEdge2Ids, trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds])
        and arrayUtils.arrayHasValue(adjacentEdge2Ids, trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds-1]) then
            print('THIRTEEN HALF')
            table.remove(trackEdgeIdsBetweenEdgeIds, #trackEdgeIdsBetweenEdgeIds)
            print('trackEdgeIdsBetweenEdgeIds during pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
        else
            print('FOURTEEN')
            isExit = true
        end
    end

    -- for _, edgeId in pairs(trackEdgeIdsBetweenEdgeIds) do
    --     local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
    --     print('base edge = ', edgeId) debugPrint(baseEdge)
    -- end
    print('trackEdgeIdsBetweenEdgeIds after pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
    return trackEdgeIdsBetweenEdgeIds
end

helpers.getTrackEdgeIdsBetweenNodeIds = function(_node1Id, _node2Id)
    print('getTrackEdgeIdsBetweenNodeIds starting')
    print('node1Id =', _node1Id) print('node2Id =', _node2Id)
    print('ONE')
    if not(edgeUtils.isValidAndExistingId(_node1Id)) then return {} end
    print('ONE AND A HALF')
    if not(edgeUtils.isValidAndExistingId(_node2Id)) then return {} end
    print('TWO')
    if _node1Id == _node2Id then return {} end
    print('THREE')

    local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()
    local adjacentEdge1Ids = {}
    local adjacentEdge2Ids = {}
    local _fetchAdjacentEdges = function()
        local adjacentEdge1IdsUserdata = _map[_node1Id] -- userdata
        local adjacentEdge2IdsUserdata = _map[_node2Id] -- userdata
        if adjacentEdge1IdsUserdata == nil then
            print('Warning: FOUR')
            return false
        else
            for _, edgeId in pairs(adjacentEdge1IdsUserdata) do -- cannot use adjacentEdgeIds[index] here
                -- arrayUtils.addUnique(adjacentEdge1Ids, edgeId)
                adjacentEdge1Ids[#adjacentEdge1Ids+1] = edgeId
            end
            print('FIVE')
        end
        if adjacentEdge2IdsUserdata == nil then
            print('Warning: SIX')
            return false
        else
            for _, edgeId in pairs(adjacentEdge2IdsUserdata) do -- cannot use adjacentEdgeIds[index] here
                -- arrayUtils.addUnique(adjacentEdge2Ids, edgeId)
                adjacentEdge2Ids[#adjacentEdge2Ids+1] = edgeId
            end
            print('SEVEN')
        end

        return true
    end

    if not(_fetchAdjacentEdges()) then print('FOUR OR SIX') return {} end
    if #adjacentEdge1Ids < 1 or #adjacentEdge2Ids < 1 then print('Warning: EIGHT') return {} end

    if #adjacentEdge1Ids == 1 and #adjacentEdge2Ids == 1 then
        if adjacentEdge1Ids[1] == adjacentEdge2Ids[1] then
            print('NINE')
            return { adjacentEdge1Ids[1] }
        else
            print('TEN')
        end
    end
    -- print('adjacentEdge1Ids =') debugPrint(adjacentEdge1Ids)
    -- print('adjacentEdge2Ids =') debugPrint(adjacentEdge2Ids)

    local _getTrackEdgePropsBetweenEdgeAndNode = function(edgeId, nodeId)
        local edge1IdTyped = api.type.EdgeId.new(edgeId, 0)
        local edgeIdDir1False = api.type.EdgeIdDirAndLength.new(edge1IdTyped, false, 0)
        local edgeIdDir1True = api.type.EdgeIdDirAndLength.new(edge1IdTyped, true, 0)
        local node2Typed = api.type.NodeId.new(nodeId, 0)
        local myPath = api.engine.util.pathfinding.findPath(
            { edgeIdDir1False, edgeIdDir1True },
            { node2Typed },
            {
                api.type.enum.TransportMode.TRAIN,
                -- api.type.enum.TransportMode.ELECTRIC_TRAIN
            },
            _constants.maxWaypointDistance
        )
        local results = {}
        for _, value in pairs(myPath) do
            -- remove non-edge funds, this api can add some nodes to its output. UG TODO.
            local baseEdge = api.engine.getComponent(value.entity, api.type.ComponentType.BASE_EDGE)
            if baseEdge ~= nil then
                results[#results+1] = value.entity
            end
        end
        return results
    end

    local trackEdgeIdsBetweenEdgeIds = _getTrackEdgePropsBetweenEdgeAndNode(adjacentEdge1Ids[1], _node2Id)
    print('trackEdgeIdsBetweenEdgeIds before pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
    -- remove edges adjacent to but outside node1 and node2

    -- for _, edgeId in pairs(trackEdgeIdsBetweenEdgeIds) do
    --     local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
    --     print('base edge = ', edgeId) debugPrint(baseEdge)
    -- end

    local isExit = false
    while not(isExit) do
        if #trackEdgeIdsBetweenEdgeIds > 1
        and arrayUtils.arrayHasValue(adjacentEdge1Ids, trackEdgeIdsBetweenEdgeIds[1])
        and arrayUtils.arrayHasValue(adjacentEdge1Ids, trackEdgeIdsBetweenEdgeIds[2]) then
            print('ELEVEN')
            table.remove(trackEdgeIdsBetweenEdgeIds, 1)
            print('trackEdgeIdsBetweenEdgeIds during pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
        else
            print('TWELVE')
            isExit = true
        end
    end
    -- isExit = false
    -- while not(isExit) do
    --     if #trackEdgeIdsBetweenEdgeIds > 1
    --     and arrayUtils.arrayHasValue(adjacentEdge2Ids, trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds])
    --     and arrayUtils.arrayHasValue(adjacentEdge2Ids, trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds-1]) then
    --         print('THIRTEEN HALF')
    --         table.remove(trackEdgeIdsBetweenEdgeIds, #trackEdgeIdsBetweenEdgeIds)
    --         print('trackEdgeIdsBetweenEdgeIds during pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
    --     else
    --         print('FOURTEEN')
    --         isExit = true
    --     end
    -- end

    -- for _, edgeId in pairs(trackEdgeIdsBetweenEdgeIds) do
    --     local baseEdge = api.engine.getComponent(edgeId, api.type.ComponentType.BASE_EDGE)
    --     print('base edge = ', edgeId) debugPrint(baseEdge)
    -- end
    print('trackEdgeIdsBetweenEdgeIds after pruning =') debugPrint(trackEdgeIdsBetweenEdgeIds)
    if arrayUtils.arrayHasValue(adjacentEdge2Ids, trackEdgeIdsBetweenEdgeIds[#trackEdgeIdsBetweenEdgeIds]) then return trackEdgeIdsBetweenEdgeIds end
    print('Warning: the last edge does not connect, this should never happen')
    return {}
end

helpers.getTrackEdgePropsBetweenEdgeIds = function(edge1Id, edge2Id)
    -- this function returns the ids in the right sequence, but their node0 and node1 may be scrambled,
    -- depending how the user laid the tracks. The output is a table of objects like
    -- [6] = {
    --     new = nil,
    --     entity = 502451,
    --     index = 0, -- this probably points at the edge direction, which depends on how the edge was laid
    --   }
    -- the output is sorted by sequence, from edge1 to edge2

    local _map = api.engine.system.streetSystem.getNode2TrackEdgeMap()

    local _getCleanPath = function(myPath)
        -- UG TODO the path contains node ids, which should not be there: clean them out
        -- this is also useful to output a lua table instead of userdata
        local results = {}
        -- local index = 0
        for _, value in pairs(myPath) do
            -- index = index + 1
            -- if edgeUtils.isValidAndExistingId(value.entity) then
                local baseEdge = api.engine.getComponent(value.entity, api.type.ComponentType.BASE_EDGE)
                if baseEdge ~= nil then
                    -- bar any paths containing joints, allow joints at the ends
                    -- if index == 1
                    -- or index == #myPath
                    -- or ((_map[baseEdge.node0] == nil or #_map[baseEdge.node0] < 3)
                    --     and (_map[baseEdge.node1] == nil or #_map[baseEdge.node1] < 3))
                    -- then
                        results[#results+1] = { entity = value.entity, index = value.index }
                    -- else
                    --     return {}
                    -- end
                    -- print('_map[baseEdge.node0] =') debugPrint(_map[baseEdge.node0])
                -- else
                --     print('WARNING: findPath added something that is not an edge') debugPrint(value)
                end
            -- end
        end

        -- for i = 2, #results-1 do
        --     local baseEdge = api.engine.getComponent(results[i].entity, api.type.ComponentType.BASE_EDGE)
        --     if _map[baseEdge.node0] ~= nil and #_map[baseEdge.node0] > 2 then return {} end
        --     if _map[baseEdge.node1] ~= nil and #_map[baseEdge.node1] > 2 then return {} end
        -- end
        return results
    end

    local _isIdInPath = function(myPath, id)
        for _, value in pairs(myPath) do
            if value.entity == id then return true end
        end
        return false
    end

    print('getTrackEdgePropsBetweenEdgeIds starting')
    print('edge1Id =', edge1Id)
    print('edge2Id =', edge2Id)
    local edge1IdTyped = api.type.EdgeId.new(edge1Id, 0)
    local edgeIdDir1False = api.type.EdgeIdDirAndLength.new(edge1IdTyped, false, 0)
    local edgeIdDir1True = api.type.EdgeIdDirAndLength.new(edge1IdTyped, true, 0)
    local baseEdge2 = api.engine.getComponent(edge2Id, api.type.ComponentType.BASE_EDGE)
    local node2Typed = api.type.NodeId.new(baseEdge2.node0, 0)
    local myPath = api.engine.util.pathfinding.findPath(
        { edgeIdDir1False, edgeIdDir1True },
        { node2Typed },
        {
            api.type.enum.TransportMode.TRAIN,
            -- api.type.enum.TransportMode.ELECTRIC_TRAIN
        },
        _constants.maxWaypointDistance
    )
    print('path =') debugPrint(myPath)
    print('clean path =') debugPrint(_getCleanPath(myPath))
    if #myPath > 0 and _isIdInPath(myPath, edge2Id) then
        return _getCleanPath(myPath)
    end

    node2Typed = api.type.NodeId.new(baseEdge2.node1, 0)
    print('trying again with node2Typed =') debugPrint(node2Typed)
    myPath = api.engine.util.pathfinding.findPath(
        { edgeIdDir1False, edgeIdDir1True },
        { node2Typed },
        {
            api.type.enum.TransportMode.TRAIN,
            -- api.type.enum.TransportMode.ELECTRIC_TRAIN
        },
        _constants.maxWaypointDistance
    )

    print('now I have path =') debugPrint(myPath)
    print('now I have clean path =') debugPrint(_getCleanPath(myPath))
    if #myPath < 1 or not(_isIdInPath(myPath, edge2Id)) then
        print('WARNING: cannot find a path including both edges, all I found was ') debugPrint(myPath)
        return {}
    end
    return _getCleanPath(myPath)
    -- if path[#path].entity ~= edge2Id then -- NO!
    --     path[#path+1] = {new = nil, entity = edge2Id, index = 0}
    -- end
end

helpers.getCentrePlatformIndex_Nearest2_TrackEdgeListMid = function(eventArgs)
    local result = 1
    local trackPlatformDistance = transfUtils.getPositionsDistance(
        eventArgs.centrePlatforms[1].posTanX2[1][1],
        eventArgs.trackEdgeList[eventArgs.trackEdgeListMidIndex].posTanX2[1][1]
    )
    for i = 2, #eventArgs.centrePlatforms do
        local testDistance = transfUtils.getPositionsDistance(
            eventArgs.centrePlatforms[i].posTanX2[1][1],
            eventArgs.trackEdgeList[eventArgs.trackEdgeListMidIndex].posTanX2[1][1]
        )
        if testDistance < trackPlatformDistance then
            trackPlatformDistance = testDistance
            result = i
        end
    end

    return result
end

helpers.getIsTrackOnPlatformLeft = function(leftPlatforms, rightPlatforms,
centrePlatformIndex_Nearest2_TrackEdgeListMid, midTrackEdge)
    local distanceLeft = transfUtils.getPositionsDistance(
        midTrackEdge.posTanX2[1][1],
        leftPlatforms[centrePlatformIndex_Nearest2_TrackEdgeListMid].posTanX2[1][1]
    )
    local distanceRight = transfUtils.getPositionsDistance(
        midTrackEdge.posTanX2[1][1],
        rightPlatforms[centrePlatformIndex_Nearest2_TrackEdgeListMid].posTanX2[1][1]
    )

    if distanceLeft < distanceRight then return true end
    return false
end

return helpers
