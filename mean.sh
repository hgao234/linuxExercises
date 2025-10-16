#! /bin/bash
# usage: ./mean.sh <column> [file.csv]
# function: given the column number (required) and an optional CSV file name, skip the header, calculate the mean of the column.
# if only the column number is given and the input is from an interactive terminal, prompt you to input the file path; input q to exit.
# if the input is from a pipe/redirect (non-interactive stdin), read from stdin.

# ------- parameter check -------
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "usage: ./mean.sh <column> [file.csv]" >&2
  exit 1
fi

col="$1"

# ------- determine the input source -------
if [ $# -eq 2 ]; then
  # if a file name is given, use it directly
  file="$2"
  if [ ! -r "$file" ]; then
    echo "Error: cannot read '$file'." >&2
    exit 2
  fi
else
  # if only the column number is given
  if [ -t 0 ]; then
    # if the input is from an interactive terminal, prompt you to input the file path (can press q to exit)
    while :; do
      printf "input the CSV file path (or press q to exit): "
      IFS= read -r file
      case "$file" in
        q|Q)
          echo "exited."
          exit 0
          ;;
      esac
      if [ -r "$file" ]; then
        break
      else
        echo "cannot read '$file'." >&2
      fi
    done
  else
    # if the input is from a pipe/redirect (non-interactive stdin), read from stdin
    file="/dev/stdin"
  fi
fi

# ------- calculate the mean -------
cut -d',' -f "$col" "$file" | tail -n +2 | {
  sum=0
  n=0
  while IFS= read -r x; do
    # assume the column is numeric
    sum=$(echo "$sum + $x" | bc -l)
    n=$((n+1))
  done
  echo "$sum / $n" | bc -l
}
