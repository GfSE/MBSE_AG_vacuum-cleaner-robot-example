package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    import PortDef::*;
    import Signals::*;
    import DockingStation::*;
    import BatteryLevelComputer:*;

    
    /* Part definitions */
    
    part def EnergySupplySystem {
        // Parts
        part bat : Battery;
        part cpu : CPU;
        part led : LED;

        // Ports
        port requiredEnergy : PowerInOutPort; // in

        // Connections
        interface : RequiredEnergyInterface connect
            src => requiredEnergy to
            tgt => bat::requiredEnergy;

        interface : PowerInterface connect
            src => bat:energy to
            tgt => cpu:requriedEnergy;        

        interface : PowerInterface connect
            src => bat:energy to
            tgt => led:requriedEnergy;

        interface : BatterySignalInterface connect
            src => bat::batSig to
            tgt => cpu::batSig;

        interface : LEDSignalInterface connect
            src => cpu::ledSig to
            tgt => led::ledSig;


    }
    
}
