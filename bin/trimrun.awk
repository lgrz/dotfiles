#!/usr/bin/awk -f

# Trim run file to top-k

BEGIN {
    if (ARGC < 2) {
        print "usage: trimrun.awk [top-k] <run file>" > "/dev/stderr"
        exit 1
    }
    k = 1000
    last_topic = ""
    count = 0

    if (ARGC == 3) {
        k = ARGV[1] + 0
        ARGV[1] = ""
    }
}

{
    curr_topic = $1
    if (curr_topic != last_topic) {
        count = 1
        last_topic = curr_topic;
    } else {
        count += 1
    }

    if (count > k) {
        next
    }

    print $0
}
