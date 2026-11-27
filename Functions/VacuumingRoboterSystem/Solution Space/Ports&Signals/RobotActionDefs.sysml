package RobotActionDefs {
    doc /* Funktionen des Roboters. Hier definiert, in den Subsystemen ausgeführt (perform)
         * und im Use Case CleanFloor referenziert.
         * Ablageort vorläufig: gehört bei RFL auf die F-Ebene (mit Ordnerstruktur klären). */

    private import ScalarValues::*;

    // Controller

    action def StartCleaning {
        doc /* Nimmt den Startbefehl des Nutzers entgegen und startet die Reinigung. */
    }

    action def SystemsCheck {
        doc /* Prüft vor dem Losfahren: Batterie ausreichend, Staubbehälter nicht voll,
             * Verbindung zu den Subsystemen steht. */
        out attribute ready : Boolean;
    }

    // Navigation

    action def DriveRoute {
        doc /* Fährt den Raum ab. Weicht dabei Hindernissen aus. */
    }

    action def ReturnToDock {
        doc /* Fährt zurück zur Ladestation und dockt an. */
    }

    // Saugsystem

    action def Vacuum {
        doc /* Löst Schmutz mit den Bürsten, saugt ihn an und sammelt ihn im Behälter. */
    }
}
