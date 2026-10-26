package ess_processor {

	private import ISQ::*; // International System of Quantities
	private import SI::*;
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
    attribute batteryCapacity : ISQ::ElectricChargeValue = 1000 [SI::ampere * SI::hour];
	attribute batteryNominalVoltage : ISQ::ElectricPotentialValue = 12 [SI::volt];
    
    // Behavior
    // Realized through a StateChart which takes inputs from the incoming port 
    // and part attribute. Produces a return value to outgoing port ledSig.
    exhibit state BatteryLevelComputerStates {
      in  ref maxBatCap     = batteryCapacity; // 'this' would be nice
      // out ref ledSig {color = computedColor;}
    }
    
	}
	
	/**
	 * As actions need to be instantiated somewhere, we leverage a very small
	 * statechart to perform the actual computations.
	 */
	state def BatteryLevelComputerStates {
	  entry; then x;  // Initial state x
	  
	  // Definition of state x instantiates action 
	  state x { 
	    entry act {x_usedEnergy; x_batCapacity; x_batNominalVoltage; x_computedIndicatorColor;}
	  }  
	}

	action act : IndicateBatterySOC{usedEnergy; batCapacity; batNominalVoltage; computedIndicatorColor;}
	
	/**
	 * The action IndicateBatterySOC delegates to the calculation CalcBatteryLevel
	 */
	action def IndicateBatterySOC{in  energy    : ISQ::ElectricChargeValue;
	                              in  nominalBatteryCapacity : ISQ::ElectricChargeValue;
								  in  nominalBatteryVoltage: ISQ::ElectricPotentialValue;
								  out batteryIndicatorColor	: LED_COLOR = CalcSOC(energy, nominalBatteryCapacity, nominalBatteryVoltage);
	}
	
	calc def CalcSOC{
		in usedEnergy 		: ISQ::EnergyValue; 
		in nominalCapacity 	: ISQ::ElectricChargeValue; 
		in nominalVoltage 	: ISQ::ElectricPotentialValue;
        
		usedEnergy / (nominalCapacity * nominalVoltage)
    }

}