# ncc
Neos Create Monocle Components sh script

### Setup:
Put the ncc.sh to your /usr/local/bin/ <br>
Go to PROJECTNAME root directory and call for it <br>

### Usage:
```
ncc -m --css --js -b
```
Output:
```
PROJECTNAME

Creating new Neos component for "PROJECTNAME".
Name your component:
```
Provide component name <br>
```
Teaser
```
Will create new Component directory with Teaser.fusion, Teaser.css (--css) and Teaser.js (--js) files in Presentation/Molecule (-m) with sample content, and will open browser with monocle preview page (-b)

### Syntax:
```ncc -[p | i] -[ a | m | o | c] -[h | v] -[b]```<br>
  
```-[h | v]``` System: Help or Version<br>
```-[p | i]``` Type: Presentation or Integration (-p by default)<br>
```-[b]``` Browse Google Chrome after creation<br>
```-[ a | m | o | c]``` Size: Atom, Molecule, Organism or Component(deprecated) (-c by default)<br>
```--[css | js]``` Extra files: Include extra css or js files<br>
