#!/bin/sh

#
#
#  Created by Julian on 8/17/16.
#
#Single subject analysis

subjs="pt868"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/your/directory"
cd ${main_dir}/${subjs}


modalities="FA MD"

#ROI files should be ROIname.nii
ROInames="manual_IC_L manual_IC_R"


for ROIname in ${ROInames} ; do

if [ ! -d ROI_Analysis ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir ROI_Analysis
fi

osascript -e 'display notification "Creating ROI '"$ROIname"' for '"$subjs"'" with title "ROI-analysis"'
if [ ! -f ROI_Analysis/Analysis.txt ]; then
touch ROI_Analysis/Analysis.txt
echo "Subject:" ${subjs} >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
fi


osascript -e 'display notification "Processing ROI '"$ROIname"' for '"$subjs"'" with title "ROI-analysis"'

echo "ROI:" ${ROIname} >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "Selection: manual" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

for mod in ${modalities} ; do
echo -n ${mod} " " >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

fslstats ${ROIname}.nii.gz -V
fslstats dti_${mod}.nii.gz -k ${ROIname}.nii.gz -V
fslstats dti_${mod}.nii.gz -k ${ROIname}.nii.gz -M >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

done

echo "" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

done

open ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt


