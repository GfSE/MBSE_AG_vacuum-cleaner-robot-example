#!/bin/bash
FILENAME="Integration"
cat *.sysml > $FILENAME.sysml


# "VacuumingSystem" mit Errors
for folder in "EnergySupplySystem" "NavigationSystem" ; do
    cat ../$folder/*.sysml >> $FILENAME.sysml
done