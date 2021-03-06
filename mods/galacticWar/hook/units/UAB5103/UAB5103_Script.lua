--#****************************************************************************
--#**
--#**  File     :  /cdimage/units/UAB5103/UAB5103_script.lua
--#**  Author(s):  John Comes, David Tomandl
--#**
--#**  Summary  :  Aeon Quantum Gate Beacon Unit
--#**
--#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--#****************************************************************************

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

UAB5103 = Class(AStructureUnit) {
    FxTransportBeacon = {'/effects/emitters/red_beacon_light_01_emit.bp'},
    FxTransportBeaconScale = 0.4,

    OnStopBeingBuilt = function(self)
        AStructureUnit.OnStopBeingBuilt(self)
        for k, v in self.FxTransportBeacon do
            self.Trash:Add(CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(self.FxTransportBeaconScale))
        end
    end,
}

TypeClass = UAB5103