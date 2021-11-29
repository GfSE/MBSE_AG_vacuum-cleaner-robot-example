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
        part battery    : Battery;
        part cpu        : CPU;
        part led        : LED;
    }
    
    part def Battery {
        port energy     : PowerInOutPort;
        port current    : VoltageSignal;
        port temp       : Temperature;
    }
    
    /**
     * The CPU performs computations of the EnergySupplySystem. To this end
     * it has two parts taking care of battery management and indicating the
     * current battery level to the user.
     */
    part def CPU {
        // Parts
        part blc        : BatteryLevelComputer;
        part bms        : BatteryMangementSystem;

        // Ports
        port energy     : PowerInOutPort;
        port batSig     : BatterySignal;
    }
    
    part def LED {
        port cmd : LEDSignal;
    }
    
    
    /* Part instances */
    
    part ess : EnergySupplySystem {
        interface : PowerInOutInterface connect
            src => battery::energy to
            tgt => cpu::energy;
        
        interface : VoltageSignalInterface connect
            src => battery::current to
            tgt => cpu::blc::current;
        
        interface : TemperatureInterface connect
            src => battery::tmp to
            tgt => cpu::blc::tmp;
        
        interface : TemperatureInterface connect
            src => battery::tmp to
            tgt => cpu::blc::tmp;
        
        interface : LEDInterface connect
            src => cpu::blc::led to
            tgt => led::cmd;
        
        interface : PowerInOutInterface connect
            src => charger::energy to
            tgt => battery::energy;
        
        interface : BooleanSignalInterface connect
            src => cpu::blc::emergencyStop to
            tgt => charger::emergencyStop;
        
        interface : PowerSignalInterface connect
            src => cpu::blc::powerSignal to
            tgt => charger::powerSignal;
        
    /* Interfaces that would be available if we knew the other parts */
    
    /*
        interface : AmpereHourConsumptionInterface connect
            src => motor::consumption to
            tgt => cpu::blc::motorConsumption;
    
        interface : AmpereHourConsumptionInterface connect
            src => fan::consumption to
            tgt => cpu::blc::fanConsumption;
    */
    
    }
    
}
