package EnergySupply {
    doc /*
    =======================================================================
    The following SysML v2 package specifies the energy
    supply system of the vacuum cleaner robot
    =======================================================================
    */    
    
    private import PortDef::*;
    private import Signals::*;

    private import ESS_Processor::*;
    private import ESS_Bat::Battery;
    private import ESS_Reg::*;
    private import ESS_Charge::*;
  	private import Signals::BatterySignals::BatterySignal;
    private import RobotPortDefs::*;

    
    /* Part definitions */
    // The Energy supply system provides the electical energy for the robot vacuum cleaner
    part def EnergySupplySystem {
        // Parts
        part chr : Charger;
        part bat : Battery;
        part cpu : BatteryLevelComputer;
        part reg : VoltageRegulator;

        // Ports
        port sig : ~EnergyDistributionCommand; // in
        port requiredEnergy : PowerInOutPort; // in
        port providedEnergy : PowerInOutPort; // out
        
       

        // Connections
        interface connect
            src ::> requiredEnergy to
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> sig to
            tgt ::> cpu.energyDemand;   

        interface connect
            src ::> reg.providedEnergy to
            tgt ::> providedEnergy;   

        // connect sub-components
        interface connect
            src ::> cpu.chargeCmd to
            tgt ::> chr.chargeCmd;   

        interface connect
            src ::> cpu.energyLevel to
            tgt ::> reg.tgtVoltage;   

        interface connect
            src ::> chr.batPlug to  
            tgt ::> bat.requriedEnergy;   

        interface connect
            src ::> bat.providedEnergy to 
            tgt ::> reg.batEnergy;   

    }
    
}
