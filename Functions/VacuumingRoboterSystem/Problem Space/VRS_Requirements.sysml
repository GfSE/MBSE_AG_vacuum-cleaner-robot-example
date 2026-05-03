package <VRSRE> VRS_Requirements {

    // Top-level requirement
    requirement def <'r1'> LowBattery{
        doc /*When the robot's battery level falls below 10%,
        it shall automatically navigate to the nearest charging station to recharge*/

        // subject : <Battery of ProblemSpace>
        subject : ESS_Bat::Battery;

        //create actor
        actor : VRSA::Battery;
        
        

        // Subsystem-specific requirements
        //no def needed for subrequirements
        requirement<'r1.1'> LowBattery_Navigation {
        doc /* The Navigation System shall determine the nearest charging station
               and generate a path to reach it. */
        subject : Navigation::navigation;
        //create actor
        actor : VRSA::NavigationSystem; //falsch?
    }
    }



    requirement def <'r2'> CarpetDetected{
        doc /* When the robot detects a carpeted surface,
        it shall automatically increase the vacuum speed to its maximum level
         to ensure optimal cleaning performance.*/
    }

    requirement def <'r4'> GroundStates {
        doc /* The system shall define exactly three allowed ground states:
        'System Active', 'System Energy Saving', and 'System Deactivated'. */
    }

    requirement def <'r5'> ActivationFromEnergySaving {
        doc /* When the system receives a power-on signal and the battery state of charge
        is greater than 5%, the system shall transition to the ground state 'System Active'
        within 100 ms, provided it was previously in the ground state 'System Energy Saving'. */
    }

    requirement def <'r6'> ActivationFromDeactivated {
        doc /* When the system receives a power-on signal and the battery state of charge
        is greater than 5%, the system shall transition to the ground state 'System Active'
        within 100 ms, provided it was previously in the ground state 'System Deactivated'. */
    }

    requirement def <'r7'> TransitionToEnergySaving {
        doc /* When the system is in the ground state 'System Active' and no stimulus is
        detected for 120 s according to the specification 'Stimulus Definition XYZ',
        the system shall transition to the ground state 'System Energy Saving' within 100 ms. */
    }

    requirement def <'r8'> TransitionToDeactivated {
        doc /* When the system is in the ground state 'System Energy Saving' and no stimulus is
        detected for 168 h according to the specification 'Stimulus Definition XYZ',
        the system shall transition to the ground state 'System Deactivated' within 100 ms. */
    }

    requirement def <'r9'> AudioOutputAfterStateChange {
        doc /* After each transition into any ground state, the system shall generate
        an audio output via the integrated speaker within 1 s. */
    }

    requirement def <'10'> AudioOutputContent {
        doc /* The audio output shall contain the text
        'The robot is in the state <GroundState>' in the currently configured system language,
        where <GroundState> is replaced by the new ground state. */
    }


}