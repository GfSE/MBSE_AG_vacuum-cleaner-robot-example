package 'Vacuuming System' {
	//import BrushSystem::*;
	//import SuctionDevice::*;
	//import FilterSystem::*;
	
	part def VacuumingSystem{
		part bs : BrushSystem::'Structure'::BrushSystem;
		part sd : SuctionDevice::'Structure'::SuctionDevice;
		part fs : FilterSystem::'Structure'::FilterSystem;
	}
}