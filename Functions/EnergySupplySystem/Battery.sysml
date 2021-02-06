package 'EnergySupply' {
  import EnergySupplyTypes::*;

	part def Battery {
	  port energyIn : EnergyInPort;
	  port energyOut : EnergyOutPort;
	}
}