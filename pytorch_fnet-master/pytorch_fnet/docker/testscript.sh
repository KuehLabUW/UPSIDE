#!/bin/bash
#A simple script

B= 'testscript.sh'
A= $(cd "$(dirname $B)"/.. && pwd):/root/projects/pytorch_fnet \
echo "$A" 


