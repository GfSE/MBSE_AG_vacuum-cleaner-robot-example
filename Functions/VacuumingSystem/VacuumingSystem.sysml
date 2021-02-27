package 'Vacuuming System' {
	// @TODO: auch mit neuem RC hier kein Import möglich (Linux-Test)
	private import 'BrushSystem'::*;
	import SuctionDevice::*;
	import FilterSystem::*;
	import 'VacuumingTypes'::*;
	
	
	part def VacuumingSystem{
		part bs : BrushSystem::'Structure'::BrushSystem;
		part sd : SuctionDevice::'Structure'::SuctionDevice;
		part fs : FilterSystem::'Structure'::FilterSystem;
	}
}