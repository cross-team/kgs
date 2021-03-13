#!/bin/bash

./scripts/wait-for-it -s -t 0 db:5432 -- 
./build/app start