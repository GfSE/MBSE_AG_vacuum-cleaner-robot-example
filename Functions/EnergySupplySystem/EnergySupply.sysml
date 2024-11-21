package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    private import PortDef::*;
    private import Signals::*;
    private import DockingStation::*;
    private import BatteryLevelComputer::*;
    private import 'Energy Supply System'::*;
    private import EnergySupplyProcessor::*;
    private import BLI::LED;

    
    /* Part definitions */
    // The Energy supply system provides the electical energy for the robot vacuum cleaner
    part def EnergySupplySystem {
        // Parts
        part bat : Battery;
        part cpu : CPU;
        part led : LED;

        // Ports
        port requiredEnergy : PowerInOutPort; // in

        // Connections
      /*  interface : RequiredEnergyInterface connect
            src ::> requiredEnergy to
            tgt ::> bat::requiredEnergy;*/

        interface : PowerInterface connect
            src ::> bat::providedEnergy to
            tgt ::> cpu::requriedEnergy;        

        interface : PowerInterface connect
            src ::> bat::providedEnergy to
            tgt ::> led::requriedEnergy;

    }
    
}
