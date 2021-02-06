package 'EnergySupply' {
  import EnergySupplyTypes::*;

	part def Battery {
	  port energyIn : EnergyInPort;
	  port energyOut : EnergyOutPort;
	  
	  attribute capacity : ScalarValues::Real;
	}
}