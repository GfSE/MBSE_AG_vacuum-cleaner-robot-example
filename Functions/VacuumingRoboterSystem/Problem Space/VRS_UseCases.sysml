package <VRSUC> VRS_UseCases {
    doc /* Anwendungsfälle des Saugroboters aus Sicht des Nutzers. */

    private import ScalarValues::*;
    private import 'Robotic Vacuum Cleaner'::*;
    private import VRS_Actors::*;

    use case def CleanFloor {
        doc /* Der Nutzer startet den Roboter. Der Roboter prüft sich, saugt den Boden
             * selbstständig und fährt zurück zur Ladestation. Ist der Raum noch nicht
             * fertig, setzt er die Reinigung danach fort. */

        subject robot : RoboticVacuumCleaner;

        actor user : User;
        actor room : Environment;

        objective {
            doc /* Der Boden ist sauber, und der Roboter steht wieder in der Ladestation. */
        }

        first start;
        then perform robot.ControllerSystem.startCleaning;
        then perform robot.ControllerSystem.systemsCheck;
        then decide;
            if systemsCheck.ready then continueCleaning;
            else reportError;

        merge continueCleaning;
        then action vacuumFloor {
            doc /* Der Roboter fährt den Raum ab, parallel dazu saugt das Saugsystem.
                 * Endet, wenn der Raum sauber ist, die Batterie nicht mehr reicht,
                 * der Staubbehälter voll ist oder ein Fehler auftritt.
                 * Das Erkennen dieser Bedingungen ist Aufgabe des Controllers. */
            out attribute roomClean : Boolean;

            perform robot.NavigationSystem.driveRoute;
            perform robot.vacuumingSystem.vacuum;

            first start;
            then fork;
                then driveRoute;
                then vacuum;
            first driveRoute then endCleaning;
            first vacuum then endCleaning;
            join endCleaning;
            then done;
        }
        then perform robot.NavigationSystem.returnToDock;
        then decide;
            if vacuumFloor.roomClean then done;
            else continueCleaning;

        action reportError {
            doc /* Der Roboter meldet dem Nutzer, warum er nicht starten kann. */
        }
        then done;
    }
}
