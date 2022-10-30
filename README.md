# ncc
Neos Create Monocle Components sh script

### Setup:
1. Put the ncc.sh to your /usr/local/bin/ <br>
Or just use it as:
```
./ncc.sh setup
```
2. Go to PROJECT_NAME root directory and call for it <br>

### Usage:
```
ncc TestComponent -m --css --js -b
```
Output:
```
PROJECT_NAME

Creating new Neos component for "PROJECT_NAME".

First time usage of "Presentation" component type.
"Presentation" directory for components is created.

First time usage of "Molecule" size.
"Molecule" directory for components is created.

Component directory was created in:
Presentation/Molecule/TestComponent
File Presentation/Molecule/TestComponent/TestComponent.fusion was created.
File Presentation/Molecule/TestComponent/TestComponent.css was created.
File Presentation/Molecule/TestComponent/TestComponent.js was created.
```
Will create new Component directory with TestComponent.fusion, TestComponent.css (--css) and TestComponent.js (--js) files in Presentation/Molecule (-m) with sample content, and will open browser with monocle preview page (-b)

### Syntax:
```ncc component_name [ setup ] -[ p | i ] -[ a | m | o | c] -[ h | v ] -[ b ]```<br>

### Options:

---
#### System:
Install script globally<br>
```setup``` <br><br>
Help or Version<br>
```-[ h | v ]```<br>

---
#### Type: 
Presentation or Integration (-p by default)<br>
```-[ p | i ]```<br>

---
#### Size: 
Atom, Molecule, Organism or Component(deprecated) (-c by default)<br>
```-[ a | m | o | c ]``` <br>

---
#### Extras:
Include extra css or js files<br>
```--[ css | js ]``` <br><br>
Browse Google Chrome after creation<br>
```-[ b ]``` <br>
