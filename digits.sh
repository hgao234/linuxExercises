#!/bin/bash

sum=0
regex='^[01]+$'

for i in {1000..2000}; do    
    if [[ $i =~ $regex ]]; then
        sum=$((sum + i))
    fi
done

echo "The sum is: $sum"
