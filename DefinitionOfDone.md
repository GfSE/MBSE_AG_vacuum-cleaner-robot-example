## What and why
 
<!-- One subsystem or one topic per PR. What did you change, and why? -->
 
**Scope:** <!-- e.g. Solution Space / NavigationSystem -->
 
## Affected files outside the scope
 
<!-- Every file outside the scope that you had to touch, or that now references something new.
     Write "none" if there are none. -->
 
## Open points
 
<!-- Decisions that are still open or need the group (link the issue if there is one).
     Write "none" if there are none. -->
 
---
 
## Definition of Done
 
### Model validity
- [ ] Every reference resolves: no imports of packages that don't exist, no usages typed by definitions that don't exist
- [ ] No ambiguous names: the same definition name is not imported from two packages
- [ ] No duplicate definitions: no new port def, item def or interface def that already exists elsewhere
- [ ] `Integration.sysml` regenerated with `integrate.sh`
### Conventions ([ModelingConventions.md](https://github.com/GfSE/MBSE_AG_vacuum-cleaner-robot-example/blob/master/ModelingConventions.md))
- [ ] Definitions `UpperCamelCase`, usages `lowerCamelCase`, packages `lowercase_with_underscores`
- [ ] Imports are `private`
### Documentation
Use `doc /* ... */`, not a plain `/* ... */` comment: `doc` belongs to the element it documents, a plain comment only annotates it. Notes (`//`) are not part of the model at all.
- [ ] Every **package** has a `doc`: what the package contains
- [ ] Every **`part def`** has a `doc`: what the part is and what it is responsible for
- [ ] Every **`port def`** has a `doc`: what is transferred, and who sends and who receives
### Ports and connections
- [ ] Port defs are defined from the **sender's** perspective (`out`); the receiver uses the conjugated port (`~`)
- [ ] `bind` for delegation (outer port of the owner ↔ port of its own part, same direction)
- [ ] `interface` / `connect` between sibling parts (sender → receiver, opposite direction)
- [ ] Every outer port is connected inside: no dangling ports
### Hygiene
- [ ] No dead code: no definitions without a usage, no empty `action def` / `attribute def` placeholders
- [ ] No commented-out model code
- [ ] No `TODO` without an issue or an entry under "Open points"
- [ ] The `legacy` folder is untouched
### Review
- [ ] Reviewed and approved by at least one member of the working group who is not the author
 