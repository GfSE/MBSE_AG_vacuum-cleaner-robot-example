package 'EnergySupplyTypes' {

	import ScalarValues::*;

  // TODO:
  // Wollen wir SI-Einheiten verwenden?

  /// DATA TYPES ///////////////////////////////////////////////////////////////
  
  item def ElectricalEnergy;
  
  enum def COLOR {
    RED;
    YELLOW;
    GREEN;
  }

	/// PORTS ////////////////////////////////////////////////////////////////////
	
	port def EnergyInOutPort {
	  inout item e : ElectricalEnergy; // units
	}
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real;
    // in ??? wert : Real; 
  }
  
  port def BatteryLevelColorPort {
    attribute color : COLOR;
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
  
  connection def ColorToColor {
    end : COLOR;
    end : COLOR;
  }

}