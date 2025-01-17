local constants = require('lollo_freestyle_train_station.constants')
local edgeUtils = require('lollo_freestyle_train_station.edgeUtils')
local logger = require('lollo_freestyle_train_station.logger')
local stringUtils = require('lollo_freestyle_train_station.stringUtils')

local _progressWindowId = 'lollo_freestyle_station_progress_window'
local _stationPickerWindowId = 'lollo_freestyle_station_picker_window'
local _warningWindowId = 'lollo_freestyle_station_warning_window_no_goto'
local _warningWindowWithGotoId = 'lollo_freestyle_station_warning_window_with_goto'
local _waypointDistanceWindowId = 'lollo_freestyle_station_waypoint_distance_window'

local _texts = {
    goBack = _('GoBack'),
    goThere = _('GoThere'), -- cannot put this directly inside the loop for some reason
    join = _('Join'),
    noJoin = _('NoJoin'),
    stationPickerWindowTitle = _('StationPickerWindowTitle'),
    wait4Join = _('Wait4Join'),
    warningWindowTitle = _('WarningWindowTitle'),
    waypointDistanceWindowTitle = _('WaypointDistanceWindowTitle'),
}

local _windowXShift = 40
local _windowYShift = 40

local guiHelpers = {
    isShowingProgress = false,
    isShowingWarning = false,
    isShowingWarningWithGoTo = false,
    isShowingWaypointDistance = false,
    moveCamera = function(position)
        local cameraData = game.gui.getCamera()
        game.gui.setCamera({position[1], position[2], cameraData[3], cameraData[4], cameraData[5]})
    end
}

---@param text string
---@param title string
---@param onCloseFunc function
guiHelpers.showProgress = function(text, title, onCloseFunc)
    guiHelpers.isShowingProgress = true

    local layout = api.gui.layout.BoxLayout.new('VERTICAL')
    local window = api.gui.util.getById(_progressWindowId)
    if window == nil then
        window = api.gui.comp.Window.new(title or _texts.warningWindowTitle, layout)
        window:setId(_progressWindowId)
    else
        window:setContent(layout)
        window:setVisible(true, false)
    end

    layout:addItem(api.gui.comp.TextView.new(text))

    -- window:setHighlighted(true)
    window:setMinimumSize(api.gui.util.Size.new(400, 70))
    -- local uiContentRect = api.gui.util.getGameUI():getContentRect()
    -- window:setPosition(uiContentRect.w - _windowXShift, uiContentRect.h - _windowYShift)
    window:setPosition(500, 200) -- easier and quicker
    -- window:addHideOnCloseHandler()
    window:onClose(
        function()
            guiHelpers.isShowingProgress = false
            window:setVisible(false, false)
            if type(onCloseFunc) == 'function' then onCloseFunc() end
        end
    )
end

---@param isTheNewObjectCargo boolean
---@param stations table<any>
---@param eventId string
---@param joinEventName string
---@param noJoinEventName string|nil
---@param eventArgs table<any>
---@param onClickFunc? function
guiHelpers.showNearbyStationPicker = function(isTheNewObjectCargo, stations, eventId, joinEventName, noJoinEventName, eventArgs, onClickFunc)
    -- print('showNearbyStationPicker starting')
    local layout = api.gui.layout.BoxLayout.new('VERTICAL')
    local window = api.gui.util.getById(_stationPickerWindowId)
    if window == nil then
        window = api.gui.comp.Window.new(_texts.stationPickerWindowTitle, layout)
        window:setId(_stationPickerWindowId)
    else
        window:setContent(layout)
        window:setVisible(true, false)
    end

    local function addJoinButtons()
        if type(stations) ~= 'table' then return end

        local components = {}
        for _, station in pairs(stations) do
            local name = api.gui.comp.TextView.new(station.uiName or station.name or '')
            local cargoIcon = station.isCargo
                and api.gui.comp.ImageView.new('ui/icons/construction-menu/category_cargo.tga')
                or api.gui.comp.TextView.new('')
            local passengerIcon = station.isPassenger
                and api.gui.comp.ImageView.new('ui/icons/construction-menu/category_passengers.tga')
                or api.gui.comp.TextView.new('')

            local gotoButtonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
            gotoButtonLayout:addItem(api.gui.comp.ImageView.new('ui/design/window-content/locate_small.tga'))
            gotoButtonLayout:addItem(api.gui.comp.TextView.new(_texts.goThere))
            local gotoButton = api.gui.comp.Button.new(gotoButtonLayout, true)
            gotoButton:onClick(
                function()
                    guiHelpers.moveCamera(station.position)
                    -- game.gui.setCamera({con.position[1], con.position[2], 100, 0, 0})
                end
            )

            local joinButtonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
            joinButtonLayout:addItem(api.gui.comp.ImageView.new('ui/design/components/checkbox_valid.tga'))
            joinButtonLayout:addItem(api.gui.comp.TextView.new(_texts.join))
            local joinButton = api.gui.comp.Button.new(joinButtonLayout, true)
            joinButton:onClick(
                function()
                    if type(onClickFunc) == 'function' then onClickFunc() end
                    logger.print('guiHelpers 120')
                    if not(stringUtils.isNullOrEmptyString(joinEventName)) then
                        eventArgs.join2StationConId = station.id
                        api.cmd.sendCommand(api.cmd.make.sendScriptEvent(
                            string.sub(debug.getinfo(1, 'S').source, 1),
                            eventId,
                            joinEventName,
                            eventArgs
                        ))
                    end
                    window:setVisible(false, false)
                end
            )

            components[#components + 1] = {name, cargoIcon, passengerIcon, gotoButton, joinButton}
        end

        if #components > 0 then
            local guiStationsTable = api.gui.comp.Table.new(#components, 'NONE')
            guiStationsTable:setNumCols(5)
            for _, value in pairs(components) do
                guiStationsTable:addRow(value)
            end
            layout:addItem(guiStationsTable)
        end
    end

    local function addNoJoinButton()
        local buttonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
        buttonLayout:addItem(api.gui.comp.ImageView.new('ui/design/components/checkbox_invalid.tga'))
        buttonLayout:addItem(api.gui.comp.TextView.new(_texts.noJoin))
        local button = api.gui.comp.Button.new(buttonLayout, true)
        button:onClick(
            function()
                -- print('string.sub(debug.getinfo(1, \'S\').source, 1) =') debugPrint(string.sub(debug.getinfo(1, 'S').source, 1))
                -- the following dumps
                -- print('string.sub(debug.getinfo(1, \'S\').source, 2) =') debugPrint(string.sub(debug.getinfo(2, 'S').source, 1))
                -- print('string.sub(debug.getinfo(1, \'S\').source, 3) =') debugPrint(string.sub(debug.getinfo(3, 'S').source, 1))
                -- print('string.sub(debug.getinfo(1, \'S\').source, 4) =') debugPrint(string.sub(debug.getinfo(4, 'S').source, 1))
                if type(onClickFunc) == 'function' then onClickFunc() end
                logger.print('guiHelpers 160')
                if not(stringUtils.isNullOrEmptyString(noJoinEventName)) then
                    api.cmd.sendCommand(api.cmd.make.sendScriptEvent(
                        string.sub(debug.getinfo(1, 'S').source, 1),
                        eventId,
                        noJoinEventName,
                        eventArgs
                    ))
                end
                window:setVisible(false, false)
            end
        )
        layout:addItem(button)
    end

    local function addWait4JoinNotice()
        layout:addItem(api.gui.comp.TextView.new(_texts.wait4Join))
    end

    local function addGoBackToWrongObjectButton()
        if not(edgeUtils.isValidAndExistingId(eventArgs.platformWaypoint1Id)) then return end

        local newObjectPosition = edgeUtils.getObjectPosition(eventArgs.platformWaypoint1Id)
        if newObjectPosition ~= nil then
            local buttonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
            buttonLayout:addItem(api.gui.comp.ImageView.new('ui/design/window-content/arrow_style1_left.tga'))
            buttonLayout:addItem(api.gui.comp.TextView.new(_texts.goBack))
            local button = api.gui.comp.Button.new(buttonLayout, true)
            button:onClick(
                function()
                    -- UG TODO this dumps, ask UG to fix it
                    -- api.gui.util.CameraController:setCameraData(
                    --     api.type.Vec2f.new(wrongObjectPosition[1], wrongObjectPosition[2]),
                    --     100, 0, 0
                    -- )
                    -- x, y, distance, angleInRad, pitchInRad
                    guiHelpers.moveCamera(newObjectPosition)
                    -- game.gui.setCamera({wrongObjectPosition[1], wrongObjectPosition[2], 100, 0, 0})
                end
            )
            layout:addItem(button)
        end
    end

    addJoinButtons()
    addNoJoinButton()
    addWait4JoinNotice()
    addGoBackToWrongObjectButton()

    -- window:setHighlighted(true)
    local position = api.gui.util.getMouseScreenPos()
    window:setPosition(position.x + _windowXShift, position.y + _windowYShift)
    window:onClose(
        function()
            logger.print('guiHelpers 215')
            -- do not do anything!
            -- if not(stringUtils.isNullOrEmptyString(noJoinEventName)) then
            --     api.cmd.sendCommand(api.cmd.make.sendScriptEvent(
            --         string.sub(debug.getinfo(1, 'S').source, 1),
            --         eventId,
            --         noJoinEventName,
            --         eventArgs
            --     ))
            -- end
            window:setVisible(false, false)
        end
    )
end

---@param text string
---@param onCloseFunc function
guiHelpers.showWarning = function(text, onCloseFunc)
    guiHelpers.isShowingWarning = true

    local layout = api.gui.layout.BoxLayout.new('VERTICAL')
    local window = api.gui.util.getById(_warningWindowId)
    if window == nil then
        window = api.gui.comp.Window.new(_texts.warningWindowTitle, layout)
        window:setId(_warningWindowId)
    else
        window:setContent(layout)
        window:setVisible(true, false)
    end

    layout:addItem(api.gui.comp.TextView.new(text))

    window:setHighlighted(true)
    window:setMinimumSize(api.gui.util.Size.new(400, 70))
    -- local uiContentRect = api.gui.util.getGameUI():getContentRect()
    -- window:setPosition(uiContentRect.w - _windowXShift, uiContentRect.h - _windowYShift)
    window:setPosition(500, 400) -- easier and quicker
    -- window:addHideOnCloseHandler()
    window:onClose(
        function()
            guiHelpers.isShowingWarning = false
            window:setVisible(false, false)
            if type(onCloseFunc) == 'function' then onCloseFunc() end
        end
    )
end

---@param text string
---@param wrongObjectId? integer
---@param similarObjectsIds? table<integer>
guiHelpers.showWarningWithGoto = function(text, wrongObjectId, similarObjectsIds)
    logger.print('guiHelpers.showWarningWithGoto starting, text =', text or 'NIL')
    guiHelpers.isShowingWarningWithGoTo = true

    local layout = api.gui.layout.BoxLayout.new('VERTICAL')
    local window = api.gui.util.getById(_warningWindowWithGotoId)
    if window == nil then
        window = api.gui.comp.Window.new(_texts.warningWindowTitle, layout)
        window:setId(_warningWindowWithGotoId)
        logger.print('the window does not exist yet, _warningWindowWithGotoId =', _warningWindowWithGotoId)
    else
        window:setContent(layout)
        window:setVisible(true, false)
        logger.print('the window exists already, _warningWindowWithGotoId =', _warningWindowWithGotoId)
    end

    layout:addItem(api.gui.comp.TextView.new(text))

    local function addGotoOtherObjectsButtons()
        if type(similarObjectsIds) ~= 'table' then return end

        local wrongObjectIdTolerant = wrongObjectId
        if not(edgeUtils.isValidAndExistingId(wrongObjectIdTolerant)) then wrongObjectIdTolerant = -1 end

        for _, otherObjectId in pairs(similarObjectsIds) do
            if otherObjectId ~= wrongObjectIdTolerant and edgeUtils.isValidAndExistingId(otherObjectId) then
                local otherObjectPosition = edgeUtils.getObjectPosition(otherObjectId)
                if otherObjectPosition ~= nil then
                    local buttonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
                    buttonLayout:addItem(api.gui.comp.ImageView.new('ui/design/window-content/locate_small.tga'))
                    buttonLayout:addItem(api.gui.comp.TextView.new(_texts.goThere))
                    local button = api.gui.comp.Button.new(buttonLayout, true)
                    button:onClick(
                        function()
                            -- UG TODO this dumps, ask UG to fix it
                            -- api.gui.util.CameraController:setCameraData(
                            --     api.type.Vec2f.new(otherObjectPosition[1], otherObjectPosition[2]),
                            --     100, 0, 0
                            -- )
                            -- x, y, distance, angleInRad, pitchInRad
                            guiHelpers.moveCamera(otherObjectPosition)
                            -- game.gui.setCamera({otherObjectPosition[1], otherObjectPosition[2], 100, 0, 0})
                        end
                    )
                    layout:addItem(button)
                end
            end
        end
    end
    local function addGoBackToWrongObjectButton()
        if not(edgeUtils.isValidAndExistingId(wrongObjectId)) then return end

        local wrongObjectPosition = edgeUtils.getObjectPosition(wrongObjectId)
        if wrongObjectPosition ~= nil then
            local buttonLayout = api.gui.layout.BoxLayout.new('HORIZONTAL')
            buttonLayout:addItem(api.gui.comp.ImageView.new('ui/design/window-content/arrow_style1_left.tga'))
            buttonLayout:addItem(api.gui.comp.TextView.new(_texts.goBack))
            local button = api.gui.comp.Button.new(buttonLayout, true)
            button:onClick(
                function()
                    -- UG TODO this dumps, ask UG to fix it
                    -- api.gui.util.CameraController:setCameraData(
                    --     api.type.Vec2f.new(wrongObjectPosition[1], wrongObjectPosition[2]),
                    --     100, 0, 0
                    -- )
                    -- x, y, distance, angleInRad, pitchInRad
                    guiHelpers.moveCamera(wrongObjectPosition)
                    -- game.gui.setCamera({wrongObjectPosition[1], wrongObjectPosition[2], 100, 0, 0})
                end
            )
            layout:addItem(button)
        end
    end
    addGotoOtherObjectsButtons()
    addGoBackToWrongObjectButton()

    window:setHighlighted(true)
    local position = api.gui.util.getMouseScreenPos()
    logger.print('window position (without shifts) =') logger.debugPrint(position)
    window:setPosition(position.x + _windowXShift, position.y + _windowYShift)
    -- window:addHideOnCloseHandler()
    window:onClose(
        function()
            logger.print('guiHelpers.showWarningWithGoto closing')
            guiHelpers.isShowingWarningWithGoTo = false
            window:setVisible(false, false)
        end
    )
end

---@param distance number
guiHelpers.showWaypointDistance = function(distance)
    guiHelpers.isShowingWaypointDistance = true

    local text = tostring((_texts.waypointDistanceWindowTitle .. " %.0f m"):format(distance))
    local content = api.gui.layout.BoxLayout.new('VERTICAL')
    local window = api.gui.util.getById(_waypointDistanceWindowId)
    if window == nil then
        window = api.gui.comp.Window.new(_texts.waypointDistanceWindowTitle, content)
        window:setId(_waypointDistanceWindowId)
    else
        window:setContent(content)
        window:setVisible(true, false)
    end

    content:addItem(api.gui.comp.TextView.new(text))

    local position = api.gui.util.getMouseScreenPos()
    window:setPosition(position.x + _windowXShift, position.y + _windowYShift)

    -- make title bar invisible without that dumb pseudo css
    window:getLayout():getItem(0):setVisible(false, false)

    window:onClose(
        function()
            logger.print('guiHelpers 374')
            guiHelpers.isShowingWaypointDistance = false
            window:setVisible(false, false)
        end
    )
end

---@param onCloseFunc function
guiHelpers.hideProgress = function(onCloseFunc)
    if guiHelpers.isShowingProgress then -- only for performance
        guiHelpers.isShowingProgress = false

        local window = api.gui.util.getById(_progressWindowId)
        if window ~= nil then
            window:setVisible(false, false)
            if type(onCloseFunc) == 'function' then onCloseFunc() end
        end
    end
end

-- guiHelpers.hideStationPicker = function()
--     local window = api.gui.util.getById(_stationPickerWindowId)
--     if window ~= nil then
--         window:setVisible(false, false)
--     end
-- end

---@param onCloseFunc? function
guiHelpers.hideWarning = function(onCloseFunc)
    if guiHelpers.isShowingWarning then -- only for performance
        guiHelpers.isShowingWarning = false

        local window = api.gui.util.getById(_warningWindowId)
        if window ~= nil then
            window:setVisible(false, false)
            if type(onCloseFunc) == 'function' then onCloseFunc() end
        end
    end
end

guiHelpers.hideWarningWithGoTo = function()
    if guiHelpers.isShowingWarningWithGoTo then -- only for performance
        guiHelpers.isShowingWarningWithGoTo = false

        local window = api.gui.util.getById(_warningWindowWithGotoId)
        if window ~= nil then
            window:setVisible(false, false)
        end
    end
end

guiHelpers.hideWaypointDistance = function()
    if guiHelpers.isShowingWaypointDistance then -- only for performance
        guiHelpers.isShowingWaypointDistance = false

        local window = api.gui.util.getById(_waypointDistanceWindowId)
        if window ~= nil then
            logger.print('guiHelpers 431')
            window:setVisible(false, false)
        end
    end
end

return guiHelpers
