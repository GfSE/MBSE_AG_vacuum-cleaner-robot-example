#!/bin/bash

FILENAME="Integration"
OUTPUT="$FILENAME.sysml"

# Clear previous output file if it exists
rm -f "$OUTPUT"

# Get all *.sysml files in the current directory
cat *.sysml > "$OUTPUT"

# general Signals and Ports from "Solution Space" root
cat "Solution Space"/*.sysml >> "$OUTPUT"

# Define subfolders inside "Solution Space"
folders=(
  "Ports&Signals"
  "EnergySupplySystem"
  "NavigationSystem"
  "ControllerSystem"
  "VacuumingSystem"
  "NavigationSystem/Bumber"
  "NavigationSystem/DriveController"
  "NavigationSystem/Engine"
  "NavigationSystem/InfraredController"
  "NavigationSystem/LaserTower"
)

# Loop through and concatenate each folder's *.sysml files
for folder in "${folders[@]}"; do
  path="Solution Space/$folder"
  if [ -d "$path" ]; then
    cat "$path"/*.sysml >> "$OUTPUT"
  else
    echo "Warning: Folder '$path' does not exist, skipping."
  fi
done

echo "Integration complete. Output saved to $OUTPUT"
