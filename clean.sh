#!/bin/sh

echo "--------clean-------"
make clean

echo "-----clean Prefs------"
cd releasepreferences
make clean
rm -rf obj/*
cd ..

echo "------clean Tweak------"
cd tweak
make clean
rm -rf obj/*
cd ..
