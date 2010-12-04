#!/bin/bash
browser()
 {
  if ps -A | \grep -cs chrome ; then
     google-chrome
  elif ps -A | \grep -c firefox ; then
     firefox ;
  else
     google-chrome
  fi
  }
