#!/bin/bash
name=$(mktemp)
wvPS Spas.doc $name
lpr $name
