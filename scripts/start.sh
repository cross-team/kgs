#!/bin/bash

./scripts/wait-for-it -s -t 0 $DB_HOST:5432 -- 
./build/app start