package 'Vacuuming System' {
	// @TODO: Hier dann mit neuem RC prüfen, ob der import funktioniert (mit und ohne Anführungsstriche prüfen)
	import 'BrushSystem'::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import 'VacuumingTypes'::*;
	
	part def VacuumingSystem{
		part bs : BrushSystem::'Structure'::BrushSystem;
		part sd : SuctionDevice::'Structure'::SuctionDevice;
		part fs : FilterSystem::'Structure'::FilterSystem;
	}
}