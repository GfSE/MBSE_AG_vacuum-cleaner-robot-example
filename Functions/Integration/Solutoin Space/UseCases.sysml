package 'Use Cases' {
    private import 'Robotic Vacuum Cleaner'::*;

    use case def 'Vacuming'{
        subject roboticVacuumCleaner : RoboticVacuumCleaner;

        actor controller : RoboticVacuumCleaner;

        // Add Doc

        first start;
        then action doClean; //wem gehört die action "doClean" -> Robotic VaccumCleaner
        then done; // sysml v1 -> Flow Final
    }
}
