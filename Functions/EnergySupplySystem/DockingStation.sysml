package DockingStation {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the charging
    station of the vacuum cleaner robot
    =======================================================================
    */    
    
    private import PortDef::*;
    private import Signals::*;
    private import Signals::ControllerSignals::PowerSignal;
    
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
