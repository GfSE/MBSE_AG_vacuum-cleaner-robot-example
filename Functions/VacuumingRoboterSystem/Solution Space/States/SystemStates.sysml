package SystemStates {

    // Actions used by the state machine
    action senseStimulus {out noStimulus : Boolean;}

    action AudioOutput {in newState : String;}

    // State machine implementing r4–r10
    state def SystemStates {

        //in Bearbeitung
        satisfy GroundStates by SystemStates;   // Ground states
        satisfy <'r5'>;   // Activation from EnergySaving
        satisfy <'r6'>;   // Activation from Deactivated
        satisfy <'r7'>;   // Transition to EnergySaving
        satisfy <'r8'>;   // Transition to Deactivated
        satisfy <'r9'>;   // Audio output after state change
        satisfy <'r10'>;  // Audio output content

        entry; then SystemDeactivated;

        state SystemDeactivated
            {
            entry AudioOutput { newState := "System Deactivated"; }
            }
        // r6: Deactivated -> Active (powerOn & SoC > 5 %)
        accept PowerOnSignal
            if battery.stateOfCharge > 0.05 
        then SystemActive;


        state SystemActive
            {
            entry AudioOutput { newState := "System Active"; }
            do senseStimulus;
            }

        // r7: Active -> EnergySaving after 120 s without stimulus
        accept after 120 [s]
            then SystemEnergySaving;


        state SystemEnergySaving 
            {
            entry AudioOutput { newState := "System Energy Saving"; }
            do senseStimulus;
            }
        // r5: EnergySaving -> Active (powerOn & SoC > 5 %)
        accept PowerOnSignal
            first SystemEnergySaving
            if battery.stateOfCharge > 0.05
            then SystemActive;
             
        // r8: EnergySaving -> Deactivated after 168 h without stimulus
        accept after 168 [h]
           then SystemDeactivated;
    }





}
