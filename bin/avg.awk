#!/usr/bin/awk -f

BEGIN {
    if (ARGC < 2) {
        print "usage: avg.awk <column>" > "/dev/stderr"
        exit 1
    }
    column = ARGV[1]
    ARGV[1] = ""
    avg = 0.0
    label = "Average"
}

{
    avg += $column
}

END {
    if (NR) {
        printf "%s: %.4f\n", label, avg / NR
    }
}
