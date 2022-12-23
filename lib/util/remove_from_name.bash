#!/bin/bash
# This script change names of all files in the search_dir so that token is removed
search_dir=../../assets/Sounds2
target_dir=../../assets/sound
token=" (mp3cut.net)"
for entry in "$search_dir"/*
do
  entryNew="${entry/$token/}"

  mv "$entry" $entryNew

done