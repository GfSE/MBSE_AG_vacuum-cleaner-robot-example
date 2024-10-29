package 'BLI' {
  import PortDef::*;
  import Signals::*;
  import Signals::ControllerSignals::*;
  import EnergySupplyTypes::*;

  part def LED {   
    // Ports
    port ledSignal 			: LEDSignal; 
    port requriedEnergy : EnergyInOutPort;
  }

	action def setColor{
    in color : LED_COLOR; 
 	  language "Java"
	  /* 
	   * Here, we could pollute our model with actual Java code for a 
	   * robot-specific middleware / implementation. With this being out of 
	   * scope of this example, the body of this opaque method is empty.
	   */
	}
}