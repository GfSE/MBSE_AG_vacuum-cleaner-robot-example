package 'EnergySupplyTypes' {

	import ScalarValues::*;

  item def ElectricalEnergy;

	/**
	 * Ports 
	 */
	port def EnergyInPort {
	  in item e : ElectricalEnergy;
	}
	
	port def EnergyOutPort {   
    in item energyOut : ElectricalEnergy;
  }
  
  port def RelativeBatteryLevelInPort {
    attribute voltageInPercent : ScalarValues::Real; 
  }
  
  port def RelativeBatteryLevelOutPort {
    attribute voltageInPercent : ScalarValues::Real; 
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

}