package 'EnergySupplyTypes' {

	import ScalarValues::*;

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
	  in item e : ElectricalEnergy;
	}
	
	port def EnergyOutPort {   
    in item energyOut : ElectricalEnergy;
  }
  
  port def RelativeBatteryLevelPort {
    attribute voltageInPercent : ScalarValues::Real; 
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