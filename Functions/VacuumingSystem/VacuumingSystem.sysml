package 'Vacuuming System' {
	// mit dem neusten Pilot (frisch von Git, commit 81df3ba, 15.03.2021) und Eclipse 2021-03 Modeling, werfen die Imports keine Fehler mehr!
	private import 'BrushSystem'::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import 'VacuumingTypes'::*;
	
	
	part def VacuumingSystem{
		part bs : BrushSystem;
		part sd : SuctionDevice;
		part fs : FilterSystem;
	}
}