package <VRSUC> VRS_UseCases {
    doc /* Anwendungsfälle des Saugroboters aus Sicht des Nutzers. */

    private import 'Robotic Vacuum Cleaner'::*;
    private import VRS_Actors::*;

    use case def CleanFloor {
        doc /* Der Nutzer startet den Roboter. Der Roboter saugt den Boden selbstständig
             * und fährt danach zurück zur Ladestation. */

        subject robot : RoboticVacuumCleaner;

        actor user : User;
        actor room : Environment;

        objective {
            doc /* Der Boden ist sauber, und der Roboter steht wieder in der Ladestation. */
        }

        first start;
        then action startCleaning {
            doc /* Der Nutzer startet die Reinigung. */
        }
        then action vacuumFloor {
            doc /* Der Roboter fährt den Raum ab und saugt dabei den Boden. */
        }
        then action returnToDock {
            doc /* Der Roboter fährt zurück zur Ladestation. */
        }
        then done;
    }
}
