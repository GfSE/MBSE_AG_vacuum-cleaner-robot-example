package 'energy_supply_types' {

	import ScalarValues::*;
  import Signals::ControllerSignals::*;

  doc /*
    =======================================================================
    This package defines basic datatypes used throughout the EnergySupply
    and related components
    =======================================================================
    */  


  // TODO: Should we use SI units?

  /// DATA TYPES ///////////////////////////////////////////////////////////////
  
  item def ElectricalEnergy;

	/// PORTS ////////////////////////////////////////////////////////////////////
	
	port def EnergyInOutPort {
	  inout item e : ElectricalEnergy; // TODO: units?
	}
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real;
    // TODO: Muss es hier ein flow feature geben
    // in ??? wert : Real; 
  }
  
  port def BatteryLevelColorPort {
    attribute color : LED_COLOR;
  }

 /// CONNECTIONS ///////////////////////////////////////////////////////////////
  
  connection def WhySoComplicated {
    end : ScalarValues::Real;
    end : ScalarValues::Real;
  }
    
  connection def EnergyToEnergy {
    end : ElectricalEnergy;
    end : ElectricalEnergy;
  }
  
}