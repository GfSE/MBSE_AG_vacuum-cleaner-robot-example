package 'BLI' {
  import PortDef::*;
  import Signals::*;

  part def LED {   
    // data flows
    port ledSignal : LEDSignal; 
	}

	action def setColor(in color : LED_COLOR) {
	 language "Java"
	 /* 
	  * Here, we could pollute our model with actual Java code for a 
	  * robot-specific middleware / implementation. With this being out of 
	  * scope of this example, the body of this opaque method is empty.
	  */
	}
}