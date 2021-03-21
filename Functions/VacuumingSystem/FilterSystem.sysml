package FilterSystem {
	private import SI::*; // SI-Import funktioniert nach clean import
	private import ISQMechanics::*; // Mass
	private import ISQSpaceTime::*; // Volume
	import Definitions::*; // no nested import required
	

	//import VacuumingTypes::*; // auch mit neuem RC dateiübergreifender Import nicht möglich
	
	package Definitions {
		//To avoid nested imports;
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import ItemDefinitions::*;
		import PartDefinitions::*;
		
		package PortDefinitions {
			//Ports (temporarily taken from VacuumTypes)
			port def ExternalAirPort {
				// Wenn nur out/in/inout genommen wird, übernimmt er den Definitionstyp
				// In sysml/src/examples/'Vehicle Example'/VehicleDefinitions.sysml (2020-12 Pilot) wird nur out verwendet
				// item für sachen die 'fließen' oder extern beeinflusst werden
				out item externalAir {
					attribute volume :> ISQSpaceTime::volume; // Einheiten werden dann erst den spezifisch verwendeten Werten gegeben
				}	
			}
		
			port def InternalAirPort {
				in item internalAir{
					attribute volume :> ISQSpaceTime::volume;
				} 
			}
		
			port def DebrisPort {
				inout item debris {
					attribute volume :> ISQSpaceTime::volume;
					attribute mass :> ISQMechanics::mass;
				}
			}
		}

		package InterfaceDefinitions {
			// Interface complementary to suction device
			interface def AirExchange {
				end supplierPort : ExternalAirPort;
            	end consumerPort : ExternalAirPort;
			}
			interface def AirIn {
				end supplierPort : InternalAirPort;
            	end consumerPort : InternalAirPort;
			}
			interface def DebrisOut {
				end supplierPort : DebrisPort;
            	end consumerPort : DebrisPort;
			}
		}
		
		package ItemDefinitions {
			enum def FillLevel {
				enum empty;
				enum full;
				enum halfFull;
			}
			enum def UsageLevel {
				enum used;
				enum new;
			}
			item def ExternalAir;
			item def InternalAir;
		}
		
		package PartDefinitions {
			part def Filter {
				enum usageLevel : UsageLevel; 
				port dirtyAir: InternalAirPort;
				port cleanAir : ExternalAirPort;
			}
			part def Tank {
				attribute mass :> ISQMechanics::mass;
				attribute volume :> ISQSpaceTime::volume;
				enum fillLevel : FillLevel;
				// Vom Filter in den Tank
				port debrisIn : DebrisPort;
				// Zum Tank säubern
				port debrisOut : DebrisPort;	
			}
			
			part def FilterSystem{
				perform action filterSys;
				port airIn : InternalAirPort;
				port airOut : ExternalAirPort;
				exhibit state filterState;
				
			}
		}
	}
	package PartsTree {
		part filterSystem : FilterSystem { 
			part tank:Tank{
				attribute redefines mass=0.5@[kg];
				attribute redefines volume=0.001@[m^3]; // liter [l] nicht als Einheit vorhanden?
			}
			part fil:Filter;
			// @TODO: clean up port --> currently no sense here
			//bind fil::cleanAir=airOut;
			//interface airExchange:AirExchange 
			//connect fil::dirtAir to tank::debrisIn;
			
		}
	}
}