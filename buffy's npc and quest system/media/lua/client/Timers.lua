MxUtils = MxUtils or {}

MxUtils.IntervalTimers = MxUtils.IntervalTimers or {}

--[[
    Usage example:
    
    local intervalTimerID = MxUtils.createIntervalTimer(5000, function()
        print("5 seconds have elapsed!")
    end)
    
    MxUtils.deleteIntervalTimer(intervalTimerID)
]]
MxUtils.createIntervalTimer = function(intervalInMilliseconds, intervalElapsedEventHandler, runOnce)
    local id = #MxUtils.IntervalTimers + 1
    local lastIntervalTime = math.floor(os.time() * 1000)

    MxUtils.IntervalTimers[id] = function(tickCounter)
        local time = math.floor(os.time() * 1000)
        if os.difftime(time, lastIntervalTime + intervalInMilliseconds) >= 0 then
            if runOnce then
                MxUtils.deleteIntervalTimer(id)
            end
            lastIntervalTime = time
            intervalElapsedEventHandler(id)
        end
    end

    -- Other events to consider
    -- Events.OnRenderTick.Add(MxUtils.IntervalTimers[id])
    -- Events.OnTickEvenPaused.Add(MxUtils.IntervalTimers[id])
    Events.OnTick.Add(MxUtils.IntervalTimers[id])

    return id
end



MxUtils.deleteIntervalTimer = function(id)
    if MxUtils.IntervalTimers[id] then
        Events.OnTick.Remove(MxUtils.IntervalTimers[id])
        MxUtils.IntervalTimers[id] = nil
    else
        print(string.format("WARNING: Unknown interval timer id %s", tostring(id)))
    end
end