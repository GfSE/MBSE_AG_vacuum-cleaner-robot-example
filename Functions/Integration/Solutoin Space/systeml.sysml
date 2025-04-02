package 'System'{

    private import 'Robotic Vacuum Cleaner'::*;
    private import Requirement::*;
    private import 'Use Cases'::*;

    // Usage of RoboticVacuumCleaner
    part system : RoboticVacuumCleaner{
        requirement req1 : LowBattery;
        satisfy req1 by EnergySystem.bat;
        satisfy req1.LowBattery_Navigation by NavigationSystem;

        use case UC1 : Vacuming{
            subject :>> roboticVacuumCleaner = self;
        }

        //wenn die Satisfy beziehung dem NavigationSystem gehört
        part :>>NavigationSystem {
            satisfy req1.LowBattery_Navigation;
        }

    }
}