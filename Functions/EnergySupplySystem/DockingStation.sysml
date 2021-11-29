package DockingStation {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the charging
    station of the vacuum cleaner robot
    =======================================================================
    */    
    
    import PortDef::*;
    import Signals::*;
    
    part def Station {
        part charger : Charger;
    }
    
    part def Charger {
        port energy        : PowerInOutPort;
        port emergencyStop : ~BooleanSignal;
        port powerSignal   : ~PowerSignal;
    }
    
    part charger : Charger;
    
}
