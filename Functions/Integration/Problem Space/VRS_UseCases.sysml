package <VRSUC> VRS_UseCases {
    private import 'Robotic Vacuum Cleaner'::*;

    use case def 'Vacuming'{
        subject roboticVacuumCleaner : RoboticVacuumCleaner;

        actor controller : RoboticVacuumCleaner;

        objective{
            doc /*
            The vacuuming robot autonomously cleans the floor by navigating its 
            * environment, 
            * detecting carpets for optimized suction, 
            * and handling low-battery situations by returning to its charging station when necessary.*/
        }

        first start;
        then action doCheckSuctionChamber;
        then action doCheckBatteryCharge;
        then action roboticVacuumCleaner:RoboticVacuumCleaner::doClean;
        //wem gehört die action "doClean" -> Robotic VaccumCleaner
        then action doCleanSuctionChamber;
        then action doRechargeBattery;
        then done; // sysml v1 -> Flow Final
    }
}
