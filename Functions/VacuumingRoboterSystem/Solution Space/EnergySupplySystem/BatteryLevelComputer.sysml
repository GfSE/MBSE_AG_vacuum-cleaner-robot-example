package ess_processor {

	private import Signals::*;
	private import ScalarValues::*;
	private import ControllerSignals::*;
	private import Signals::BatterySignals::BatterySignal;
	private import RobotPortDefs::*;

  /**
   * This part takes a BatterySignal as input and translates it into a 
   * color to be shown by the LED of EnergySupplySystem
   */
	part def BatteryLevelComputer {
     
	  // Ports
      port energyDemand : ~EnergyDistributionCommand; // in
      port chargeCmd : ChargeCommand; // out
	  port energyLevel : EnergyRegulation; // out

    // Attributes  
    attribute batteryCapacity : Real = 1000; 
    
    // Behavior
    // Realized through a StateChart which takes inputs from the incoming port 
    // and part attribute. Produces a return value to outgoing port ledSig.
    exhibit state BatteryLevelComputerStates {
      in  ref maxBatCap     = batteryCapacity; // 'this' would be nice
      //out ref ledSig {color = computedColor;}
    }
    
	}
	
	/**
	 * As actions need to be instnatiated somewhere, we leverage a very small
	 * statechart to perform the actual computations.
	 */
	state def BatteryLevelComputerStates {
	  entry; then x;  // Initial state x
	  
	  // Definition of state x instantiates action 
	  state x { 
	    entry act {batCap; maxBatCap; computedColor;}
	  }  
	}

	action act : ComputeBatteryInfo{batCap; maxBatCap; computedColor;}
	
	/**
	 * The action ComputeBatteryInfo delegates to the calculation CalcBatteryLevel
	 */
	action def ComputeBatteryInfo{in  batteryCapacity    : Real;
	                              in  maxBatteryCapacity : Real;
	                              out batteryColor       : LED_COLOR = CalcBatteryLevel(batteryCapacity, maxBatteryCapacity);
	}
	
	calc def CalcBatteryLevel{
		in energy : Real; 
		in capacity : Real; 
        
		energy / capacity
    }

}