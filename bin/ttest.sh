#!/bin/bash

# Input format: each line consists of 2 attributes: 
#               label value
#
# Test options:
#    alternative=t|l|g    change direction of test (two-tailed, less, greater)

if [ $# != 2 ] 
then 
  echo "usage: $0 <file a> <file b>"
  echo ""
  echo "Format of input file is:"
  echo "  'label value'"
  echo ""
  echo "Commands to get input data format:"
  echo "  trec_eval -m map -nq qrels run | awk '{print \$2,\$3}'"
  echo "  gdeval.pl -j 4 -k 20 qrels run | sed -e 1d -e \\\$d | awk '{print \$2,\$3}'"
  echo "  rbp_eval -WHTq -p 0.9 qrels run | awk '{print \$4,\$8}'"
  echo ""
  exit 1
fi

paste -d' ' $1 $2 | cut -d' ' -f 1,2,4 > tt

echo "
inp <- scan('tt', list('',0,0))
sysA <- inp[[2]]
sysB <- inp[[3]]
x <- t.test(sysA,sysB,var.equal=TRUE,paired=TRUE,alternative='t')
x
" | R --quiet --vanilla --slave
rm tt
