
package VacuumCleanerSystem {
    package BaseArchitecture {
        part def Battery {
            attribute capacity;
        }

        part def VacuumCleaner {
            part battery : Battery;
        }
    }

    package Requirements {
        requirement <REQ1> operationTime {
            subject vc : BaseArchitecture::Battery;
            require constraint {
                vc.capacity >= 42
            }
        }
    }

    package ProductArchitecture {

        part def RoboticVacuumCleaner :> BaseArchitecture::VacuumCleaner {
            part chassis;
            part :>> battery {
                attribute :>> capacity = 50;
            }
        }

        satisfy Requirements::REQ1 by RoboticVacuumCleaner::battery;
    }
}

