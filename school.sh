#!/bin/bash
cat Property_Tax_Roll.csv |
grep 'MADISON SCHOOLS' |
cut -d, -f7 |
{
  awk '{
    sum += $1; n++
  }
  END {
    printf "sum=%d\naverage=%.6f\n", sum, sum / n
  }'
}
