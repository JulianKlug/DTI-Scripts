#!/bin/sh

#  Extract ROI.sh
#  
#
#  Created by Julian on 8/15/16.
#
#Enter ROI coordinates
main_dir="/Users/path/to/your/directory"
cd ${main_dir}


X=45
Y=74
Z=51

#Enter sphere radius
R=5

Groups="A B"

if [ ! -d ROI_Analysis ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir ROI_Analysis
cd ROI_Analysis

if [ ! -d Analysis.txt ]; then
touch Analysis.txt
fi

fi

for zzGR in ${Groups} ; do

cd ${main_dir}/group${zzGR}

    fslmaths ${zzGR}_meanFA.nii.gz -mul 0 -add 1 -roi $X 1 $Y 1 $Z 1 0 1 ACCpoint -odt float
    fslmaths ACCpoint -kernel sphere $R -fmean ACCsphere -odt float

    fslmaths ACCsphere -thr 0.0019 -bin ACCsphere_bin

    echo "Group: " ${zzGR} >> ${main_dir}/Analysis.txt
    fslstats ACCsphere_bin -V
    fslstats ${zzGR}_meanFA.nii.gz -k ACCsphere_bin -V
    fslstats ${zzGR}_meanFA.nii.gz -k ACCsphere_bin -M >> ${main_dir}/Analysis.txt

done
