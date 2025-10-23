#!/bin/sh -e
sysctl net.ipv4.ipfrag_time=3
sysctl net.ipv4.ipfrag_high_thresh=134217728 # (128 MB)
exit 0
