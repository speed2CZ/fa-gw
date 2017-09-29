function CheckVictory(scenarioInfo)
    local categoryCheck = victoryCategories[scenarioInfo.Options.Victory]
    if not categoryCheck then return end

    -- tick number we are going to issue a victory on.  Or nil if we are not.
    local victoryTime = nil
    local potentialWinners = {}

    while true do
        -- Look for newly defeated brains and tell them they're dead
        local stillAlive = {}
        for _, brain in ArmyBrains do
            if not brain:IsDefeated() and not ArmyIsCivilian(brain:GetArmyIndex()) and not brain:IsSupport() then -- GW Addition: and not brain:IsSupport()
                if CountCurrentUnits(brain,categoryCheck) == 0 then
                    brain:OnDefeat()
                else
                    table.insert(stillAlive, brain)
                end
            end
        end

        -- uh-oh, there is nobody alive... It's a draw.
        if table.empty(stillAlive) then
            CallEndGame()
            return
        end

        -- check to see if everyone still alive is allied and is requesting an allied victory.
        local win = true
        local draw = true
        for i, brain in stillAlive do
            if not brain.OfferingDraw then
                draw = false
            end

            if not (draw or win) then break end

            for j, other in stillAlive do
                if i ~= j then
                    if not brain.RequestingAlliedVictory or not IsAlly(brain:GetArmyIndex(), other:GetArmyIndex()) then
                        win = false
                        break
                    end
                end
            end
        end

        local callback = nil
        if win then
            local equal = table.equal(stillAlive, potentialWinners)
            if not equal then
                victoryTime = GetGameTimeSeconds() + 5
                potentialWinners = stillAlive
            end

            if equal and GetGameTimeSeconds() >= victoryTime then
                callback = 'OnVictory'
            end
        elseif draw then
            callback = 'OnDraw'
        else
            victoryTime = nil
            potentialWinners = {}
        end

        if callback then
            for _, brain in stillAlive do
                brain[callback](brain)
            end

            CallEndGame()
            return
        end

        WaitSeconds(3)
    end
end