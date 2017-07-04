#!/bin/sh

#  ROI.py
#
#
#  Created by Julian on 8/17/16.
#
#Single subject analysis

subjs="01 03"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"
cd ${main_dir}



ROIname="IC_R"

modalities="FA_reg MD_reg"
ref_vol="FA_reg"

X=96
Y=92
Z=53

#Enter sphere radius
R=3


for zzSUB1 in ${subjs} ; do

cd ${main_dir}/${zzSUB1}/ROI_Analysis

#Edit your base volume for drawing ROI manually
fslmaths ${zzSUB1}${ref_vol}.nii.gz -mul 0 -add 1 -roi $X 1 $Y 1 $Z 1 0 1 ${ROIname}"_"${ref_vol}"_point".nii.gz -odt float
fslmaths ${ROIname}"_"${ref_vol}"_point".nii.gz -kernel sphere $R -fmean ${ROIname}"_"${ref_vol}_sphere -odt float

thresh=`fslstats ${ROIname}"_"${ref_vol}_sphere -M`
fslmaths ${ROIname}"_"${ref_vol}_sphere -thr ${thresh} -bin ${ROIname}"_"${ref_vol}_sphere_bin

done

for zzSUB1 in ${subjs} ; do
cd ${main_dir}/${zzSUB1}/ROI_Analysis
echo "Check mask postion. Then close the window or ctrl+z then bg"
fslview ${zzSUB1}${ref_vol}.nii.gz ${ROIname}"_"${ref_vol}_sphere_bin.nii.gz -l Red-Yellow &
done

#
### If manually executing, pause here and check results
#

for zzSUB1 in ${subjs} ; do
cd ${main_dir}/${zzSUB1}/ROI_Analysis

if [ ! -f Analysis.txt ]; then
touch Analysis.txt
echo "Subject:" ${zzSUB1} >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
echo "" >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
fi


echo "ROI:" ${ROIname} >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
echo "Ref-volume:" "dti_"${ref_vol}".nii.gz" >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
echo "Center (X,Y,Z):" ${X} "," ${Y} "," ${Z}>> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
echo "Radius:" ${R} >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt

for mod in ${modalities} ; do
echo -n ${mod} " " >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt
fslstats ${ROIname}"_"${ref_vol}_sphere_bin -V
fslstats ${zzSUB1}${mod}.nii.gz -k ${ROIname}"_"${ref_vol}_sphere_bin -V
fslstats ${zzSUB1}${mod}.nii.gz -k ${ROIname}"_"${ref_vol}_sphere_bin -M >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt

done

echo "" >> ${main_dir}/${zzSUB1}/ROI_Analysis/Analysis.txt

done



