package <VRSSA> VRS_SystemArchitecture{

    private import 'Robotic Vacuum Cleaner'::*;
    private import VRSRE::*;
    private import VRSUC::*;

    // Usage of RoboticVacuumCleaner
    part System : RoboticVacuumCleaner{
        requirement req1 : LowBattery{
            actor ::> VRSA::Environment;
        }
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