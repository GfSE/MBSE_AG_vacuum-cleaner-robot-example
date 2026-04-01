# SysML v2 Modeling Conventions


## 1. Naming Conventions

### 1.1 Definitions
* Use **CamelCase** with an **uppercase first letter** for all definitions:
  * `part def`, `interface def`, `state def`, `requirement def`, etc.
* **Examples:**
```sysml
part def VehicleDefinition {...}
interface def EngineInterface {...}
state def OperationalState {...}
```

### 1.2 Usages / Instances
* Use camelCase with a lowercase first letter for all instances/usages:
  * part, interface, state, etc.
* Examples:
```sysml
part myVehicle : VehicleDefinition {...}
interface engineControl : EngineInterface {...}
```

### 1.3 Packages
* Package names should be lowercase with underscores as separators.
* Do not use spaces.
* Examples:
```sysml
package vehicle_components {...}
package propulsion_system {...}
```

### 1.4 Artifact Names
* Principle: Names should be meaningful and unique; avoid abbreviations without explanation.

## 2. Imports
* Default: use private imports.
  * Public imports only if usage across multiple modules/packages is required.
* Example:
```sysml
import private common_components;
```

## 3. Artifact Organization
* Every artifact should be clearly assigned to a package.
* Hierarchy: Packages should reflect the system structure (e.g., functional areas, subsystems).
* Example (must be applied to domain and concrete use case of the system model):
```sysml
root_package
│
├─ system_definitions
│   ├─ parts
│   ├─ interfaces
│   └─ states
│
├─ use_cases
├─ requirements
└─ tests
```

## 4. General and Additional Recommendations
* Clearly distinguish between definitions and instances
* Prefer compositional relationships over loose connections
* Visibility: Export only what is necessary (private/public)
* Use of constraints to ensure consistency
* Traceability: Every instance or element should be (indirectly) linked to a requirement.
* Naming consistency: Instances and definitions should be consistently named across packages.
  * No spaces in names
  * No special characters except underscore (_) in packages
  * Comments / Documentation: Use comments for all definitions to improve readability

## ToDo: Systems Enginering Methodology


  
