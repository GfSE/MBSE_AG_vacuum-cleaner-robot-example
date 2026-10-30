package properties {
    private import ScalarValues::*;
    private import ISQ::*;

    // Controller System
    // ...

    // Energy Supply System
    attribute BLC_BATTERY_CAPACITY : ISQ::ElectricChargeValue = 1000 [SI::ampere * SI::hour];
	attribute BLC_BATTERY_NOMINAL_VOLTAGE : ISQ::ElectricPotentialValue = 12 [SI::volt];
    attribute BLC_BATTERY_LOW_CHARGE_TRESHOLD : Real = 0.2;
    attribute BLC_BATTERY_HIGH_CHARGE_TRESHOLD : Real = 0.75;
    // ...


    // Navigation System
    // ...

    // Vacuuming System
    // ...



}