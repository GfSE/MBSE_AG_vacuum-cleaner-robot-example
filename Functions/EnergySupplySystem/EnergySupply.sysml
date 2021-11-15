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

    
    /* Part definitions */
    
    part def EnergySupplySystem {
        part battery    : Battery;
        part cpu        : CPU;
        part led        : LED;
    }
    
    part def Battery {
        port energy     : PowerInOutPort;
        port current    : VoltageSignal;
        port tmp        : Temperature;
    }
    
    part def CPU {
        part blc        : BatteryLevelComputer;
        port energy     : PowerInOutPort;
    }
    
    part def BatteryLevelComputer {
        port current    : ~VoltageSignal;
        port tmp        : ~Temperature;
        
        port emergencyStop : BooleanSignal;
        port powerSignal   : PowerSignal;

        port motorConsumption : ~AmpereHourConsumption;
        port fanConsumption   : ~AmpereHourConsumption;
        
        port batteryLevel : NumericSignal;
        port led : LEDSignal;
        
        // Behavior goes here ...
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
