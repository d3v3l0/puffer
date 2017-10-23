#!/bin/bash -ex
# this is a hack
pwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z $test_tmpdir ];then
    test_tmpdir="test_tmp/"
    mkdir -p $test_tmpdir
fi

DAALA=$(pwd)/../ssim/daala_tools
D_SSIM=dump_ssim
D_FSSIM=dump_fastssim
SSIM=$(pwd)/../ssim/ssim
FILE1="files/frame1.y4m"
FILE2="files/frame2.y4m"
OUTPUT1=$test_tmpdir/"out_ssim1"
OUTPUT2=$test_tmpdir/"out_ssim2"

# make daala files
cd $DAALA/
make
cd $pwd

# run the ssim test
$SSIM $FILE1 $FILE2 $OUTPUT1
result1=$(tail -n 1 $OUTPUT1)

# run the daala tools
truth1=$($DAALA/$D_SSIM $FILE1 $FILE2 | tail -n 1)

if [ "$result1" != "$truth1" ]
then
    exit 1
fi

# test fast ssim
$SSIM -x $FILE1 $FILE2 $OUTPUT2
result2=$(tail -n 1 $OUTPUT2)
truth2=$($DAALA/$D_FSSIM $FILE1 $FILE2 | tail -n 1)

if [ "$result2" != "$truth2" ]
then
    exit 1
fi

