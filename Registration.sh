#!/bin/sh

#  Registration.sh
#  
#
#  Created by Julian on 8/12/16.
#
# Register FA and MD images to FMRIB standard image
# Reference image (MNI152_T1_1mm.nii.gz) must be in main study directory

subjs="01 02 03 04 05 06"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"
cd ${main_dir}

for zzVAR in ${subjs} ; do

cd ${main_dir}/${zzVAR}

#fslreorient2std dti_FA.nii.gz dti_FA_reor
flirt -in dti_FA -ref ${main_dir}/MNI152_T1_1mm.nii.gz -out dti_FA_reg

#fslreorient2std dti_MD.nii.gz dti_MD_reor
flirt -in dti_MD -ref ${main_dir}/MNI152_T1_1mm.nii.gz -out dti_MD_reg


done
