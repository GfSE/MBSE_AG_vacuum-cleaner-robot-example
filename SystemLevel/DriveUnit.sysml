package 'DriveUnit' { //Spaces lead to problems in %show
    import ScalarValues::*;
    import ISQ::*;
    import SI::*;
    
    
    package Requirements {
        
        requirement def id 'Req001' MaximaleMasse {
        
            doc /* This is a textual requirement */
            
            attribute masseIST:MassValue; // MassValue comes from imported ISQ package
            attribute masseSOLL:MassValue; 
            
            require constraint {masseIST <= masseSOLL}
        }
        
        requirement def id 'Req002' Lenken {
        
            doc /* Das System muss in der Lage sein die Richtung zu wechseln */
            
            attribute lenkwinkel:Real;
                        
        }
        
        requirement def id 'Req003' Beschleunigen {
        
            doc /* Das System muss in der Lage sein zu beschleunigen und mit mindestens 0,5 km/h und maximal 1km/h zu fahren */
            
            attribute maximaleBeschleunigung:Real;
            attribute maximaleGeschwindigkeit:Real;
            
            subject motor;
                        
        }
                
    }
    
    package systemsEngineeringDomain {
        
        package ports {
         
            port def FMatter {
                in item matterIn;
                out item matterOut;
            }

            port def FEnergy {
                in item energyIn;
                out item energyOut;
            }

            port def FSignal {
                in item signalIn;
                out item signalOut;
            }
            
        }
            
        package seAbstractionLayers {

            part def Function {
                port FMatter;
                port FEnergy;
                port FSignal;
            }
            
            part def logicalThing {
                port FMatter;
                port FEnergy;
                port FSignal;
            }
            
            part def physicalThing {
                attribute cdb_object_id;
            }
            
        }
             
    }
    
    package functionalArchitecture {
        import systemsEngineeringDomain::*;
        import systemsEngineeringDomain::seAbstractionLayers::*;
        import systemsEngineeringDomain::ports::*;
        
        interface def energySupply {
            end supplierPort : FEnergy;
            end consumerPort : FEnergy;
        }
        
        part functionalArchitecture {

            part Beschleunigen : Function {
                port redefines FEnergy;
            }

            part EnergieSpeichern : Function {
                port redefines FEnergy;
            }
            
            interface : energySupply connect supplierPort => EnergieSpeichern::FEnergy to consumerPort => Beschleunigen::FEnergy;

        }
    }
    
    package logicalArchitecture {
        
        import ScalarValues::*;
        import ISQ::*;
        //import ISQ::Electromagnetism::*; // Für import von voltage
        import SI::*; 
        
        /* part defs für Definition von logischen Elementen 
        
        - Motor
        - Lasertower
        - Bumper 
        - Infrarotdiode (Kommunikation mit der PSU)
        - Ladekontakt
        - Drive Controller
        -- Steuern
        -- Orientieren
        - tire
        
        */
        
        part def logicalDriveUnit;        
        
        part def dcMotor {
            attribute maxTorque :> ISQ::torque; // maximales Drehmoment
            attribute rpm0 : Real; // Nenndrehzahl
            attribute voltage :> ISQ::voltage; // Voltage;
            
            port powerSupply;
            port torque;
             
        }
        
        part def Lasertower {
            attribute distance : Real; // abstand in meter
            attribute distanceAngle : Real; // vinkel der zum abstand gemessen wurden
            attribute motor; // für das rotieren

            port position;
            port powerSupply;
        }

        part def Bumber {
            attribute isContact : Real;

            port contact;
        }

        part def Infrarotdiode {
            attribute isPSU : Real;
            attribute psuDistance : Real;

            port psu;
        }

        part def testInheritance :> dcMotor; // Dies ist eine echte Vererbung
        
        /* part Instanzierung 
        - Motor links
        - Motor Rechts
        - 1x Lasertower
        - 1x Bumper
        - Infrarot zur Kommunikation
        - Ladekontakt +
        - Ladekontakt -
        - 2x tire
        
        */
        
        part driveUnit : logicalDriveUnit {
            part motor1 : dcMotor;
            part motor2 : dcMotor;
        }
        
        part orientation : Lasertower;

        part collision : Bumber;

        part psuDetection : Infrarotdiode;
       
        //satisfy Beschleunigen by driveUnit; // Funktioniert noch nicht
        
    }
    
}



    
