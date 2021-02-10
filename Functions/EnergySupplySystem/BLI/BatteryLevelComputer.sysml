package 'BLI' {
	import EnergySupplyTypes::*;

	part def BatteryLevelComputer {
	   // physical flows
    port energyIn : EnergyInPort;
    // data flows
    port batteryLevel : BatteryLevelColorPort;
    port batteryLevelColor : BatteryLevelColorPort;
    
    attribute capacity : ScalarValues::Real = 1000;
    
    /** Wie kommt die Action nun an die Port-Werte? */
    
    action computeThings : ComputeThings
    
	}
	
	// statechart
	
	/* vv Das hier wirkt recht kompliziert vv */
	
	action def ComputeThings(in  energy   : ScalarValues::Real, 
                           in  capacity : ScalarValues::Real,
                           out batLev   : ScalarValues::Real,
                           out color : EnergySupplyTypes::COLOR) {
    
    bind compBatLev::energy = energy;
    bind compBatLev::capacity = capacity;
    bind compBatLev::batLev = batLev;
    
    /* Muss man die Parameter hier wirklich wiederholen?  
     */
    action compBatLev : ComputeBatteryLevel(in  energy   : ScalarValues::Real, 
                                            in  capacity : ScalarValues::Real,
                                            out batLev   : ScalarValues::Rea);
                                            
    bind compBatLev:batLev to compBatLevCol:batLev; 
                                            

    action compBatLevCol(in  batlev : ScalarValues::Real
                         out color : EnergySupplyTypes::COLOR);

    /* Ist der Port batteryLevelColor hier wirklich sichtbar? 
     * Wie starkt schränkt das wieder Wiederverwendbarkeit von dieser
     * Action Def ein?
     * */
    bind compBatLevCol::color to batteryLevelColor;  
                             
  }
	
	calc def BatteryLevelCalc(eng : Real, cap : Real) {
    eng / cap
  }
	
	action def ComputeBatteryLevel(in  energy   : ScalarValues::Real, 
	                               in  capacity : ScalarValues::Real,
	                               out batLev   : ScalarValues::Real) {
    // action calls calculation
    calc doesItNeedANameAnyway : BatteryLevelCalc(energy, capacity)
        return batLev;
	  
	}

	action def ComputeBatteryLevelColor(in  batlev : ScalarValues::Real
	                                    out color : EnergySupplyTypes::COLOR) {
	  
	}
	
	//  calc für ComputeBatteryLevelColor fehlt
}