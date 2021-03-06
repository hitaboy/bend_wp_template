#!/bin/sh

mainOptions () {
  # reset

  echo "                      ___           ___          _____    "
  echo "       _____         /  /\         /__/\        /  /::\   "
  echo "      /  /::\       /  /:/_        \  \:\      /  /:/\:\  "
  echo "     /  /:/\:\     /  /:/ /\        \  \:\    /  /:/  \:\ "
  echo "    /  /:/~/::\   /  /:/ /:/_   _____\__\:\  /__/:/ \__\:|"
  echo "   /__/:/ /:/\:| /__/:/ /:/ /\ /__/::::::::\ \  \:\ /  /:/"
  echo "   \  \:\/:/~/:/ \  \:\/:/ /:/ \  \:\~~\~~\/  \  \:\  /:/ "
  echo "    \  \::/ /:/   \  \::/ /:/   \  \:\  ~~~    \  \:\/:/  "
  echo "     \  \:\/:/     \  \:\/:/     \  \:\         \  \::/   "
  echo "      \  \::/       \  \::/       \  \:\         \__\/    "
  echo "       \__\/         \__\/         \__\/                  "
  echo " "
  echo "You need to have gnu-sed (brew install gnu-sed)"
  echo " "
  echo "----------------------------------"
  echo "-- Select modules to initialize --"
  echo "----------------------------------"
  echo " "
  echo " "
  c="@import '../base/scss/$1/$1';"
  j="import $1 from './modules/$1.js'"
  j2="global.main.$1 = new $1()"
  PS3='Please enter your choice: '
  options=("Header module" "Slideshow module" "Grid module" "Quit")
  select opt in "${options[@]}"
  do
    case $opt in
      "Header module")
        PS3='Please enter your choice: '
        headerOptions=("Install" "Uninstall" "Back")
        select optH in "${headerOptions[@]}"
        do
          case $optH in
            "Install")
              echo "Installing $1 module"
              echo "Copying files"
              grep -q -F "$c" src/scss/base.scss || echo "$c" >> src/scss/base.scss
              grep -q -F "$j'" src/js/web_app.js || gsed "s#var global#$j\n&#g" src/js/web_app.js > src/js/web_app.js_temp
              mv src/js/web_app.js_temp src/js/web_app.js
              grep -q -F "$j2" src/js/web_app.js || gsed "s#global.main.resetModules()#$j2\n  &#g" src/js/web_app.js > src/js/web_app.js_temp
              mv src/js/web_app.js_temp src/js/web_app.js
              mkdir templates/blocks/header/
              cp src/base/templates/header/back_custom.php templates/blocks/header/back.php
              ;;
            "Uninstall")
              echo "Uninstalling $1 module"
              echo "Deleting files"
              grep -vwE "$c" src/scss/base.scss > src/scss/base.scss_temp
              mv src/scss/base.scss_temp src/scss/base.scss
              grep -vwE "$j" src/js/web_app.js > src/js/web_app.js_temp
              mv src/js/web_app.js_temp src/js/web_app.js
              grep -vwE "  $j2" src/js/web_app.js > src/js/web_app.js_temp
              mv src/js/web_app.js_temp src/js/web_app.js
              ;;
            "Back")
              mainOptions
              ;;
            *) echo invalid headerOptions;;
          esac
        done
        ;;
      "Slideshow module")
        echo "Initializing Slideshow module"
        ;;
      "Grid module")
        echo "Initializing Grid module"
        ;;
      "Quit")
        exit 0
        ;;
      *) echo invalid option;;
    esac
  done
}

mainOptions $1
