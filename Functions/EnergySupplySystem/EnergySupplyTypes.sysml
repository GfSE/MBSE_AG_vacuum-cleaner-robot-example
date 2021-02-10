package 'EnergySupplyTypes' {

	import ScalarValues::*;

  // units?

  item def ElectricalEnergy;
  
  enum def COLOR {
    RED;
    YELLOW;
    GREEN;
  }

	/**
	 * Ports 
	 */
	port def EnergyInPort {
	  in item e : ElectricalEnergy; // units
	}
	
	port def EnergyOutPort {   
    out item energyOut : ElectricalEnergy; // ~
  }
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real;
    // in ??? wert : Real; 
  }
  
  port def BatteryLevelColorPort {
    attribute color : COLOR;
  }

 /**
  * Connections
  */
  
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