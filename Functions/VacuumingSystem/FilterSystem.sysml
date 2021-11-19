package FilterSystem {
	private import SI::*; // SI-Import funktioniert nach clean import
	private import ISQMechanics::*; // Mass
	private import ISQSpaceTime::*; // Volume
	import VacuumingTypes::*;
	import Definitions::*; // no nested import required
	import Signals::*;
	
	package Definitions {
		//To avoid nested imports;
		import PortDefinitions::*;
		import InterfaceDefinitions::*;
		import ItemDefinitions::*;
		import PartDefinitions::*;
		
		package InterfaceDefinitions {
			
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
				port usageLevel : Signals::NumericSignal; 
				port dirtyAir: InternalAirPort;
				port cleanAir : ExternalAirPort;
				port debrisOut : DebrisPort;
			}
			part def Tank {
				attribute mass;// :> ISQMechanics::mass; //fehler beu der Typangabe
				attribute volume :> ISQSpaceTime::volume;
				enum fillLevel : FillLevel;
				// Vom Filter in den Tank
				port debrisIn : DebrisPort;
				// Zum Tank säubern
				port debrisOut : DebrisPort;	
				port fillState : FillStatePort;
			}
			
			part def FilterSystem{
				perform action filterSys;
				port airIn : InternalAirPort;
				port airOut : ExternalAirPort;
				port debrisOut : DebrisPort;
				exhibit state filterState;
				port fillState : FillStatePort;
				
			}
		}
	}
	package PartsTree {
		part filterSystem : FilterSystem { 
			part tank:Tank{
				attribute redefines mass=0.5[kg];
				attribute redefines volume=0.001[m^3]; // liter [l] nicht als Einheit vorhanden?
				port redefines debrisIn;
				port redefines fillState;
			}
			part fil:Filter{
				port redefines debrisOut;
			}
			
			interface : VacuumingTypes::InterfaceDefinitions::Debris connect supplierPort => fil::debrisOut to consumerPort => tank::debrisIn;
			interface : VacuumingTypes::InterfaceDefinitions::FillStateLevel connect src => tank::fillState to tgt => fillState;
		}
	}
}