awk -F',' '{
  sum = 0;
  for (i = 2; i <= 9; i++) {
    sum += $i;
  }
  if (sum >= 48) {
    print;
  }
}' AlaNor.counts.csv > AlaNor.counts_res.csv
