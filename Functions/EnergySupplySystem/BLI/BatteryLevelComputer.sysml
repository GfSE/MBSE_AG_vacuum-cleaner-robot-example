package 'BLI' {
	import EnergySupplyTypes::*;

	part def BatteryLevelComputer {
	   // physical flows
    port energyIn : EnergyInPort;
    // data flows
    port batteryLevel : RelativeBatteryLevelOutPort;
    
    attribute capacity : ScalarValues::Real = 1000;
    
    action reallyDoBatteryLevelCalc : ReallyDoBatteryLevelCalc(in e, in c, out lvl) {
      
      calc level : BatteryLevelCalc(e, c) return lvl; 
    }
    
    
	}
	
	action def ReallyDoBatteryLevelCalc(in  energy   : Real, 
	                                    in  capacity : Real,
	                                    out batLev   : Real) {
    // action calls calculation
    calc doesItNeedANameAnyway : BatteryLevelCalc(energy, capacity)
        return batLev;
	  
	}
	
	calc def BatteryLevelCalc(eng : Real, cap : Real) {
	  eng / cap
	}
}