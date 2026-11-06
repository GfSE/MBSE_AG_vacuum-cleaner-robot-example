package <VRSA> VRS_Actors {
    doc /* Akteure und Umgebung des Saugroboters. */

    part def User {
        doc /* Person, die den Roboter bedient. */
    }

    part def Environment {
        doc /* Raum, in dem der Roboter saugt: Boden, Hindernisse, Ladestation. */
    }

    part def Battery;
    part def NavigationSystem;
    part def VacuumingSystem;
    part def Controller;

}
