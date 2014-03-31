#!/bin/sh

sed -i -r -n 's|installing ([^.]*)\.\.\..*|\1|p' check

for i in $(cat check); do grep "^$i:" rebuild.txt && echo $i; done
