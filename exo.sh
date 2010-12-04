#!/bin/bash

# tmpdir
dir='/tmp'

# Download documents
wget "http://planetquest.jpl.nasa.gov/" -O ${dir}/jpl
wget "http://exoplanet.eu/catalog.php" -O ${dir}/encyclopedia

# Extrakt Data
jpl=$(cat ${dir}/jpl | grep currentPlanetCount | grep span | cut -d\> -f3 | head -c 3)
encyclopedia=$(cat ${dir}/encyclopedia | grep '<td valign="bottom"><font size="4">' | cut -d'>' -f 4 | head -c 3)

# Remove files
rm ${dir}/jpl
rm ${dir}/encyclopedia

if [ "$1" != "-s" ] ; then
  # Display
  echo "Anzahl der Exoplaneten:"
  echo "laut Daten des JPL: $jpl"
  echo "laut Daten der Extrasolar Planets Encyclopaedia: $encyclopedia"
else
  echo "JPL: $jpl"
  echo "Encyc.: $encyclopedia"
fi
