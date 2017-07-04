#!/bin/sh

#  singleSubROI.sh
#
#
#  Created by Julian on 8/17/16.
#
# Single subject analysis

# Takes a sphere and estimates average values of region
# Results are saved in Analysis.txt

# Execute code only up to checkpoint to verify right placement of ROI.
# Execute second part only after verification

subjs="subj01"
#Put your subject folders in here

#Write your main directory here
main_dir="/your/path/to/main/directory"
cd ${main_dir}/${subjs}

#Specify modalities to be analysed here
modalities="FA MD"

#specify modality that has been used as reference for coordinate estimation here
ref_vol="FA"


## IMPORTANT
# Input ROIname and coordinates here:
ROIname="n8_R"
X=22
Y=116
Z=32

#Enter sphere radius
R=1



if [ ! -d ROI_Analysis ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir ROI_Analysis
fi

if [ ! -f ROI_Analysis/Analysis.txt ]; then
touch ROI_Analysis/Analysis.txt
echo "Subject:" ${subjs} >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
fi

osascript -e 'display notification "Creating ROI '"$ROIname"' for '"$subjs"'" with title "ROI-analysis"'

#Edit your base volume for drawing ROI manually
fslmaths dti_${ref_vol}.nii.gz -mul 0 -add 1 -roi $X 1 $Y 1 $Z 1 0 1 ${ROIname}"_"${ref_vol}"_point".nii.gz -odt float
fslmaths ${ROIname}"_"${ref_vol}"_point".nii.gz -kernel sphere $R -fmean ${ROIname}"_"${ref_vol}_sphere -odt float

thresh=`fslstats ${ROIname}"_"${ref_vol}_sphere -M`
fslmaths ${ROIname}"_"${ref_vol}_sphere -thr ${thresh} -bin ${ROIname}"_"${ref_vol}_sphere_bin

echo "Check mask postion. Then close the window or ctrl+z then bg"
if [ ! -f *sphere_bin.nii.gz ]; then
fslview_deprecated dti_${ref_vol}.nii.gz dti_MD.nii.gz ${ROIname}"_"${ref_vol}_sphere_bin.nii.gz -l Red-Yellow
else
fslview_deprecated dti_${ref_vol}.nii.gz dti_MD.nii.gz *sphere_bin.nii.gz -l Red-Yellow
fi

#
## IMPOTANT: CHECKPOINT

### If manually executing, pause here and check results

## IMPORTANT
#

osascript -e 'display notification "Processing ROI '"$ROIname"' for '"$subjs"'" with title "ROI-analysis"'

echo "ROI:" ${ROIname} >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "Ref-volume:" "dti_"${ref_vol}".nii.gz" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "Center (X,Y,Z):" ${X} "," ${Y} "," ${Z}>> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
echo "Radius:" ${R} >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

for mod in ${modalities} ; do
echo -n ${mod} " " >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
fslstats ${ROIname}"_"${ref_vol}_sphere_bin -V
fslstats dti_${mod}.nii.gz -k ${ROIname}"_"${ref_vol}_sphere_bin -V
fslstats dti_${mod}.nii.gz -k ${ROIname}"_"${ref_vol}_sphere_bin -M >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt

done

echo "" >> ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt
open ${main_dir}/${subjs}/ROI_Analysis/Analysis.txt




