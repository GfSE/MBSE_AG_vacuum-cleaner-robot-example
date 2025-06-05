package <VRSC> VRS_Context {
    part def VRS_Context{
        part system :'Robotic Vacuum Cleaner'::RoboticVacuumCleaner;
        part environment : VRS_Actors::Environment;
        part battery : VRS_Actors::Battery;
        part navigation : VRS_Actors::NavigationSystem;
        part vacuuming : VRS_Actors::VacuumingSystem;
        part controller : VRS_Actors::Controller;
        
        connect environment to system;
        connect battery to system;
        connect navigation to system;
        connect vacuuming to system;
    }
}