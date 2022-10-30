#!/bin/sh

############################################################
# Help                                                     #
############################################################
Help() {
  # Display Help
  echo "Description of the script functions."
  echo
  echo "Syntax:"
  echo "ncc COMPONENT_NAME [setup] -[p | i] -[ a | m | o | c] -[h | v] -[b]"
  echo
  echo "setup                                     // Install the component"
  echo "-[h | v]                                  // System: Help or Version"
  echo "-[p | i]                                  // Type: Presentation or Integration"
  echo "-[b]                                      // Browse Google Chrome after creation"
  echo "-[ a | m | o | c]                         // Size: Atom, Molecule, Organism or Component(deprecated)"
  echo "--[css | js]                              // Extra files: Include extra css or js files"
  exit 1
}
############################################################
# Print GPL license notification                           #
############################################################
License() {
  echo "This program is free software: you can redistribute it and/or modify"
  echo "it under the terms of the GNU General Public License as published by"
  echo "the Free Software Foundation, either version 3 of the License, or"
  echo "(at your option) any later version."
  echo
  echo "This program is distributed in the hope that it will be useful,"
  echo "but WITHOUT ANY WARRANTY; without even the implied warranty of"
  echo "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"
  echo "GNU General Public License for more details."
  echo
  echo "You should have received a copy of the GNU General Public License"
  echo "along with this program.  If not, see <http://www.gnu.org/licenses/>."
  exit 1
}
############################################################
# Print software version                                   #
############################################################
Version() {
  echo "Version 1.1"
  exit 1
}
############################################################
# Install script                                           #
############################################################
Setup() {
  echo "Installing NCC..."
  cp ncc.sh /usr/local/bin
  echo "Installing NCC... Done"
  exit 1
}

# CHECK IS COMMAND PROVIDED
if [ -z "$1" ]; then
  echo "No command provided"
  Help
  else
    component_name=$1
fi

# READ SYSTEM FLAGS
while [ -n "$1" ]; do # while loop starts
  case "$1" in
  -[Hh] | --[Hh][Ee][Ll][Pp])
    Help
    break
    ;;
  -[Ll])
    License
    break
    ;;
  -[Vv])
    Version
    break
    ;;
  [Ss][Ee][Tt][Uu][Pp])
    Setup
    break
    ;;
  *)
    break
    ;;
  esac
done

# READ PROJECT NAME FROM .ddev/config.yaml
project_name=$(head -n 1 "${PWD}/.ddev/config.yaml")
project_name=$(echo "$project_name" | sed 's/.*\ \(.*\)/\1/')
project_name_lowercase=$(echo "$project_name" | sed 's/.*\ \(.*\)/\1/' | tr '[:upper:]' '[:lower:]')
echo "$project_name"

# IS SCRIPT RUNNING IN THE PROJECT ROOT DIRECTORY
if [ -d "${PWD}/.idea" ] && [ -d "${PWD}/DistributionPackages" ]; then
  echo
else
  echo "ERROR: Seems like you are not in the project root directory. Run this scrip only from root directory."
  exit 1
fi

# READ COMPONENT NAME
echo "Creating new Neos component for \"$project_name\"."
if [ -z "$component_name" ]; then
  echo "ERROR: \"$component_name\" is not valid component name. Please provide new component name."
  read -p "Component name: " component_name
fi

component_name_without_specials=$(echo "$component_name" | tr -dc '[:alnum:]\n\r')

if [ "$component_name" != "$component_name_without_specials" ]; then
  echo "Component name contains special characters. Would you like to change it to: ${component_name_without_specials} [y]. Or provide new name."

  read component_name_changed_right

  if [ "$component_name_changed_right" = 'y' ] || [ "$component_name_changed_right" = 'Y' ]; then
    component_name="$component_name_without_specials"
    echo "Component name was changed to: \"$component_name\""
  else
    component_name="$component_name_changed_right"

    # READ COMPONENT NAME WHILE IT DOES NOT CONTAIN SPECIAL CHARACTERS
    while [ "$component_name" != "$(echo "$component_name" | tr -dc '[:alnum:]\n\r')" ]; do
      echo "Wrong name, don't use special characters:"
      read component_name
    done
    echo "Component name was set to: \"$component_name\""
  fi
fi

# SET DEFAULTS
help="false"
project_dir_name="${PWD##/*/}"
browse="false"
component_type="Presentation"
component_size="Component"
is_css_required="false"
is_js_required="false"
is_component_exists="false"
is_component_fusion_exists="false"
is_component_css_exists="false"
is_component_js_exists="false"

# READ VAR FLAGS
while [ -n "$1" ]; do # while loop starts
  case "$1" in
  -[Ii] | --[Ii][Nn][Tt][Ee][Gg][Rr][Aa][Tt][Ii][Oo][Nn])
    component_type="Integration"
    shift
    ;;
  -[Pp] | --[Pp][Rr][Ee][Ss][Ee][Nn][Tt][Aa][Tt][Ii][Oo][Nn])
    component_type="Presentation"
    shift
    ;;
  -[Cc] | --[Cc][Oo][Mm][Pp][Oo][Nn][Ee][Nn][Tt])
    component_size="Component"
    shift
    ;;
  -[Aa] | --[Aa][Rt][Oo][Mm])
    component_size="Atom"
    shift
    ;;
  -[Mm] | --[Mm][Oo][Ll][Ee][Cc][Uu][Ll][Ee])
    component_size="Molecule"
    shift
    ;;
  -[Oo] | --[Oo][Rr][Gg][Aa][Nn][Ii][Ss][Mm])
    component_size="Organism"
    shift
    ;;
  --[Cc][Ss][Ss] | --[Ss][Tt][Yy][Ll][Ee])
    is_css_required="true"
    shift
    ;;
  --[Jj][Ss] | --[Ss][Cc][Rr][Ii][Pp][Tt])
    is_js_required="true"
    shift
    ;;
  -[Bb] | --[Bb][Rr][Oo][Ww][Ss][Ee])
    browse="true"
    shift
    ;;
  --)
    break
    ;;
  *)
    shift
    ;;
  esac
done

# SET MAIN VARS
debug_mode=0
component_local_path="DistributionPackages/CodeQ.Site/Resources/Private/Fusion"
component_path="${PWD}/${component_local_path}/${component_type}/${component_size}"

# IS COMPONENT EXISTS
if [ -d "${component_path}/${component_name}" ]; then
  echo
  echo "NOTICE: Component ${component_name} is already exist in"
  echo "${component_local_path}/${component_type}/${component_size}"
  is_component_exists="true"
else

  # IS COMPONENT TYPE DIRECTORY EXISTS
  if [ ! -d "${PWD}/${component_local_path}/${component_type}" ]; then
    echo
    echo "First time usage of \"${component_type}\" component type."
    echo "\"${component_type}\" directory for components is created."
    mkdir "${PWD}/${component_local_path}/${component_type}"
  fi

  # IS COMPONENT SIZE DIRECTORY EXISTS
  if [ ! -d "${PWD}/${component_local_path}/${component_type}/${component_size}" ]; then
    echo
    echo "First time usage of \"${component_size}\" size."
    echo "\"${component_size}\" directory for components is created."
    mkdir "${PWD}/${component_local_path}/${component_type}/${component_size}"
  fi

  echo
  echo "Component directory was created in:"
  echo "${component_type}/${component_size}/${component_name}"
  mkdir "${component_path}/${component_name}"
fi
############################################################
# CREATE CSS FILE                                          #
############################################################
MakeCSS() {
  css_class=$(echo "$component_name" | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')

  # css file default content TODO: read from config file
  css_content=".${css_class} {

}"

  # create css file
  css_file="${component_path}/${component_name}/${component_name}.css"
  touch "$css_file"
  printf "%s\n\t" "$css_content" >"$css_file"
  echo "File ${component_type}/${component_size}/${component_name}/${component_name}.css was created."
}
############################################################
# CREATE JS FILE                                           #
############################################################
MakeJS() {
  # js file default content TODO: read from config file
  js_content="export default class ${component_name} {
    static init() {
        Array.from(document.querySelectorAll('.${css_class}')).forEach(element => {
            new ${component_name}(element);
        });
    }

    classes = {
        node: '${css_class}'
    }

    constructor(element) {
        if (!element) return;

    }
}"

  # create js file
  js_file="${component_path}/${component_name}/${component_name}.js"
  touch "$js_file"
  printf "%s\n\t" "$js_content" >"$js_file"
  echo "File ${component_type}/${component_size}/${component_name}/${component_name}.js was created."
}
############################################################
# CREATE FUSION FILE                                       #
############################################################
MakeFusion() {
  # fusion file default content TODO: read from config file
  fusion_content="prototype(CodeQ.Site:${component_type}.${component_size}.${component_name}) < prototype(Neos.Fusion:Component) {
    @styleguide {
        props {

        }
    }

    @propTypes {

    }

    renderer = afx\`

    \`
}"

  #  create fusion file
  fusion_file="${component_path}/${component_name}/${component_name}.fusion"
  touch "$fusion_file"
  printf "%s\n\t" "$fusion_content" >"$fusion_file"
  echo "File ${component_type}/${component_size}/${component_name}/${component_name}.fusion was created."
}
############################################################
# Main program                                             #
############################################################

# HELP INFORMATION
if [ "$help" = "true" ]; then
  Help
  exit 1
fi

# VERSION
if [ "$license" = "true" ]; then
  License
  exit 1
fi

# VERSION
if [ "$version" = "true" ]; then
  Version
  exit 1
fi

# CHECK IF FUSION FILE EXISTS
if [ -f "${component_path}/${component_name}/${component_name}.fusion" ]; then
  echo
  echo "NOTICE: Fusion file \"${component_name}\" is already exist in"
  echo "${component_local_path}"
  is_component_fusion_exists="true"
fi

# CHECK IS JS FILE EXISTS
if [ -f "${component_path}/${component_name}/${component_name}.js" ] && [ $is_js_required = "true" ]; then
  echo
  echo "NOTICE: Js file \"${component_name}\" is already exist in"
  echo "${component_local_path}"
  is_component_js_exists="true"
fi

# CHECK IS CSS FILE EXISTS
if [ -f "${component_path}/${component_name}/${component_name}.css" ] && [ $is_css_required = "true" ]; then
  echo
  echo "NOTICE: Css file \"${component_name}.css\" is already exist in"
  echo "${component_local_path}"
  is_component_css_exists="true"
fi

# FUSION
if [ ! "$is_component_fusion_exists" = "true" ]; then
  MakeFusion "$component_type"
fi

# CSS
if [ "$is_css_required" = "true" ] && [ ! "$is_component_css_exists" = "true" ]; then
  MakeCSS
fi

# JS
if [ "$is_js_required" = "true" ] && [ ! "$is_component_js_exists" = "true" ]; then
  MakeJS
fi

############################################################
# DEBUG                                                    #
############################################################
Debug() {
  echo
  echo "DEBUG component_path: $component_path"
  echo "DEBUG is_component_exists: $is_component_exists"
  echo "DEBUG component_name: $component_name"
  echo "DEBUG component_type: $component_type"
  echo "DEBUG component_size: $component_size"
  echo "DEBUG is_css_required: $is_css_required"
  echo "DEBUG is_js_required: $is_js_required"
}

# DEBUG
if [ $debug_mode = 1 ]; then
  Debug
  exit 1
fi

## open component fusion file via phpstorm
url="https://${project_name_lowercase}.ddev.site/monocle/preview/index?prototypeName=CodeQ.Site%3A${component_type}.${component_size}.${component_name}&sitePackageKey=CodeQ.Site"

# Open browser
if [ $browse = "true" ]; then
  open -a "Google Chrome.app" "$url"
fi

# Open phpstorm
if [ $is_component_fusion_exists = "true" ]; then
  /usr/local/bin/phpstorm.sh "${component_path}/${component_name}/${component_name}.fusion"
else
  /usr/local/bin/phpstorm.sh --line 13 "${component_path}/${component_name}/${component_name}.fusion"
fi
