package 'BLI' {
	import EnergySupplyTypes::*;

	part def BatteryLevelComputer {
	   // physical flows
    port energyIn : EnergyInOutPort;
    // data flows
    port batteryLevel : BatteryLevelColorPort;
    port batteryLevelColor : BatteryLevelColorPort;
    
    attribute capacity : ScalarValues::Real = 1000;
    
    // TODO: 
    //  Zuweisung besitmmt falsch weil hier Attributen Ports zugewiesen werden
    exhibit BatteryLevelComputerStates {
      in ref  en = energyIn;
      in ref  cn = capactiy; // 'this' wäre praktisch
      out ref batteryLevel = bl;
      out ref batteryLevelColor = co;
      
    }
    
	}
	
	/// STATES ///////////////////////////////////////////////////////////////////
	
	// Statechart: Weil die Definition von Actions mit Calculations und deren
	// Werteübergabe schlecht gelöst ist, gibt es nur eine Action und nur einen
	// Zustang, d.h. im Kern: a [epsilon] / berechneAlles --> b

	state def BatteryLevelComputerStates {
	  entry: then a;
	  
	  state a {
	    // TODO: ist die Syntax hier korrekt oder müssen die Typen wieder
	    // mit anegeben werden?
	    entry act : ActComputeBatteryInfo(en, ca, bl, co);
	  }
	  
	  // TODO: 
	  // Wie gelangen die Berechnungsergebnisse batteryLevel und color
	  // nun in die ausgehenden Ports?
	  
	  // Transition von a zu sich selbst.
	  accept true then a;
	  
	}
	
  /// ACTIONS //////////////////////////////////////////////////////////////////
	
	action def ActComputeBatteryInfo(in  energy       : Real, 
	                                 in  capacity     : Real,
	                                 out batteryLevel : Real,
	                                 out color        : COLOR) {
	                                    
    // Die Aktion delegiert nun an eine Berechnung
    
    // TODO: 
    // Muss diese benannt sein?
    calc doesItNeedANameAnyway : CalcBatteryLevel(energy, capacity)
      return batteryLevel = ???; 
        // TODO: Wie kommt man an das Ergebnis von doesItNeedANameAnyway ? 
        
    calc nameNeccessary : CalcBatteryLevelColor(batteryLevel)
      return color = ???; 
      
      // TODO: 
      Wie kommt man an das Ergebnis von nameNeccessary ?
	}

	/// CALCULATTIONS ////////////////////////////////////////////////////////////
	
	calc def CalcBatteryLevel(energy   : ScalarValues::Real, 
	                           capacity : ScalarValues::Real) {
   return energy / capacity
  }
  
  calc def CalcBatteryLevelColor(batteryLevel   : ScalarValues::Real) {
    atttribute resultingColor = COLOR::YELLOW;
    // TODO: 
    // Wie das wohl funktioniert?
    // 
    // if (batteryLevel < 0.2)
    //  resultingColor = COLOR::RED;
    // if (batteryLevel > 0.8)
    //   resultingColor = COLOR::GREEN;
    return resultingColor;
  }
}