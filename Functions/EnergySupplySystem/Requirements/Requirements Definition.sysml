package RoboCleanRequirements {
	
	import ISQ::*;
	import SI::*;
	
	requirement def <'1'> StoreEnergyReq {
	doc /* The energy supply system must store energy. */

	action def StoreEnergy; 	// ??:Can an action have an attribute? Or does the attribute have to treated separately?
	attribute def TotalCapacity;
	attribute def ChargeCurrent;
	}
	
	requirement def <'2'> ProvidePower {
	doc /* The energy supply system must provide the required power to the electic consumers. */

	action def ProvidePower;
	attribute def Voltage;
	attribute def DischargeCurrent;
	}
	
	requirement def <'3'> BatteryProtection {
	doc /* The energy supply system must protect the battery. */

		// ??:Is such a nesting reasonable?
		action def UndervoltateProtection {
			
			// ??:Should this be a requirement or an action?
			requirement def <'3.1'> CellVoltageMeasurement {
			doc /* The voltage level of each cell has to measured. */
			}
		}
		
		// ??: How to refer to Req 3.1?
		action def OvervoltateProtection;
		
		action def OverheatingProtection {
			
			// ??:Should this be a requirement or an action?
			requirement def <'3.3'> CellTemperatureMeasurement {
			doc /* The temperature of each cell has to measured. */
			}
		}
	}
}