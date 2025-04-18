package Signals {
    doc /*
    =======================================================================
    The following SysML v2 package DEFINES
    multiple signal ports and interfaces
    =======================================================================
    */  
    
    private import ScalarValues::*;
    private import ISQ::*;
    
    /* Primitive and basic signals */
    
    port def BooleanSignal {
        out attribute val : Boolean;
    }
    
    interface def BooleanSignalInterface {
        end src : BooleanSignal;
        end tgt : ~BooleanSignal;
    }
    
    port def NumericSignal {
        out attribute val : Real;
    }
    
    interface def NumericSignalInterface {
        end src : NumericSignal;
        end tgt : ~NumericSignal;
    }
    
    
    /* Customized and advanced signals of the different sub-systems */
    
    package ControllerSignals {

        port def PowerSignal {
            out attribute constantCurrent :> totalCurrent;
            out attribute constantVoltage :> voltage;
        }

        interface def PowerSignalInterface {
            end src : PowerSignal;
            end tgt : ~PowerSignal;
        }

        port def DriverUnitControlSignal {
            out attribute forwards : Boolean;
            out attribute left : Boolean;
            out attribute right : Boolean;
        }
    
        interface def DriverUnitControlInterface {
            end src : DriverUnitControlSignal;
            end tgt : ~DriverUnitControlSignal;
        }
        
        port def LEDSignal {
            out color : LED_COLOR;
        }

        interface def LEDInterface {
            end src : LEDSignal;
            end tgt : ~LEDSignal;
        }

        enum def LED_COLOR {
            RED;
            YELLOW;
            GREEN;
        }

    }
    
    package BatterySignals {

        private import Signals::ControllerSignals::*;
        
        port def PowerInOutPort{
            inout attribute :> ISQMechanics::power; 
        }

        interface def PowerInterface {
            end supplierPort : PowerInOutPort;
            end consumerPort : PowerInOutPort;
        }
        
        /* wurde in "out" umbenannt, da konjugation sinnvoller ist*/
        port def VacuumSystemPowerOutPort {
            out attribute suctionPower :> ISQMechanics::power;
            out attribute brushPower :> ISQMechanics::power; 
        }
        
        interface def VacuumSystemPowerInterface {
            end supplierPort : VacuumSystemPowerOutPort;
            end consumerPort : VacuumSystemPowerOutPort;
        }

        port def LEDSignal {
            inout attribute color : LED_COLOR;
        }

        interface def LEDSignalInterface {
            end supplierPort : LEDSignal;
            end consumerPort : LEDSignal;
        }

        port def BatterySignal { // @Ralf: hier bitte ergänzen
            // current capactity of battery
            inout attribute curBatCapacity : Real; 

        }

        interface def BatterySignalInterface {
            end supplierPort : BatterySignal;
            end consumerPort : BatterySignal;
        }
    }
    
    
    

}