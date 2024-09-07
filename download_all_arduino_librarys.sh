#!/bin/bash
wget https://raw.githubusercontent.com/arduino/library-registry/main/repositories.txt

mkdir library_database
cd library_database

echo "Downloading all librarys to folder"

cat ../repositories.txt | while read url; do git clone $url; done

echo "Finsished downloading librarys"
