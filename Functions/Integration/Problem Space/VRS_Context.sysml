package <VRSC> VRS_Context {
    part def VRS_Context{
        part system :'Robotic Vacuum Cleaner'::RoboticVacuumCleaner;
        part environment : VRS_Actors::Environment;
        part loadingEnvironment : VRS_Actors::'Loading Environment';

        connect environment to system;
        connect loadingEnvironment to system;
    }
}