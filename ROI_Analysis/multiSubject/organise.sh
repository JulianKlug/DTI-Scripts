#!/bin/sh

#  ROI.py
#
#
#  Created by Julian on 8/17/16.
#
#Single subject analysis

subjs="01 02 03 04 05 06"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"
cd ${main_dir}



for varSUB in ${subjs}; do
cd ${main_dir}/${varSUB}

if [ ! -d ROI_Analysis ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir ROI_Analysis
fi

cp stats/all_FA.nii.gz ROI_Analysis/${varSUB}FA_reg.nii.gz
cp stats/all_MD.nii.gz ROI_Analysis/${varSUB}MD_reg.nii.gz


done


