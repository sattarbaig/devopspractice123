#!/bin/sh
for i in $@
do
  yum install $i -y
done
