#!/bin/bash
FILENAME="Integration"
cat *.sysml > $FILENAME.sysml

# general Signals and Ports
cat ../*.sysml >> $FILENAME.sysml

# "VacuumingSystem" mit Errors
for folder in "Ports&Signals" "EnergySupplySystem" "NavigationSystem" "ControllerSystem" "VacuumingSystem" "NavigationSystem/Bumber" "NavigationSystem/DriveController" "NavigationSystem/Engine" "NavigationSystem/InfraredController" "NavigationSystem/LaserTower"; do
    cat $folder/*.sysml >> $FILENAME.sysml
done
