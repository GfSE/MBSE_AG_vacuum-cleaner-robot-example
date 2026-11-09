package ess_processor {

	private import ISQ::*; // International System of Quantities
	private import SI::*;
	private import Signals::*;
	private import ScalarValues::*;
	private import ControllerSignals::*;
	private import Signals::BatterySignals::BatterySignal;
	private import RobotPortDefs::*;
	private import properties::*;

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
    attribute batteryCapacity : ISQ::ElectricChargeValue default = BLC_BATTERY_CAPACITY [SI::ampere * SI::hour];
	attribute batteryNominalVoltage : ISQ::ElectricPotentialValue := BLC_BATTERY_NOMINAL_VOLTAGE [SI::volt];
	attribute batteryLevel : ISQ::ElectricChargeValue;
    
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
		in maxBatCap : ISQ::ElectricChargeValue;
		in batteryLevel : ISQ::ElectricChargeValue;

	    first start then lowCharge;

		state lowCharge;
        accept when (batteryLevel / maxBatCap) > BLC_BATTERY_LOW_CHARGE_TRESHOLD
		  then mediumCharge;
		  

		state mediumCharge;
		accept when (batteryLevel / maxBatCap) <= BLC_BATTERY_LOW_CHARGE_TRESHOLD
		  then lowCharge;
        accept when (batteryLevel / maxBatCap) > BLC_BATTERY_HIGH_CHARGE_TRESHOLD
		  then highCharge;
		
		
		state highCharge;
        accept when (batteryLevel / maxBatCap) <= BLC_BATTERY_HIGH_CHARGE_TRESHOLD
		  then mediumCharge;

	
	}

	/**
	 * As actions need to be instantiated somewhere, we leverage a very small
	 * statechart to perform the actual computations.
	 */
	state def BatteryLevelComputerStates2 {
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