# Writes all sound files names to a given file

search_dir=../../assets/sounds
to_file=sound_files.txt
for entry in "$search_dir"/*
do
  entryNew="${entry// /_}"
  entryNew="${entryNew/[.a-zA-Z]*\//}"
  echo $entryNew >> $to_file

done