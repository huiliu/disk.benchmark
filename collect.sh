#!/bin/bash


DISK=sda
THREADS="1 2 4"
TEST_MODE="rndrd" #    rndrw    rndwr    seqrd    seqrewr  seqwr"

for test_mode in $TEST_MODE
do
    OUTPUT_FILE_CPU=summary.${test_mode}.cpu
    OUTPUT_FILE_DISK=summary.${test_mode}.disk
    for thread in $THREADS
    do
        echo '          %user   %nice %system %iowait  %steal   %idle' >> $OUTPUT_FILE_CPU
        grep -A1 'avg-cpu:' $1/iostat.${test_mode}.${thread}.res | sed -r '/(^avg)|(--)/d' >> $OUTPUT_FILE_CPU
        echo -e "\n" >> $OUTPUT_FILE_CPU

        echo 'Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util' >> $OUTPUT_FILE_DISK
        grep -E "\<$DISK\>" $1/iostat.${test_mode}.${thread}.res >> $OUTPUT_FILE_DISK
        echo -e "\n" >> $OUTPUT_FILE_DISK
    done
done
