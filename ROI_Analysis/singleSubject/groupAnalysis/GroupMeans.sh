#!/bin/sh

#  GroupMeans.sh
#  
#
#  Created by Julian Klug on 8/12/16.
#
groupA=()
groupB=("03" "04")
#Put your subject folders in here

#Write your main directory here
main_dir="/Users/path/to/your/directory"
cd ${main_dir}


#### Group B

    if [ ! -d groupB ]; then
        # Control will enter here if $DIRECTORY doesn't exist.
        mkdir groupB
    fi

for zzVAR in ${groupB[@]} ; do
        cp ${zzVAR}/dti_FA_reg.nii.gz groupB/${zzVAR}dti_FA_reg.nii.gz
    done

    cd ${main_dir}/groupB

fslmaths ${groupB[0]}dti_FA_reg.nii.gz -add ${groupB[1]}dti_FA_reg.nii.gz B_FA

    for (( i=2; i<${#groupB[@]}; i++ )); do

fslmaths B_FA.nii.gz -add ${i}dti_FA_reg.nii.gz B_FA


done

fslmaths B_FA.nii.gz -div ${#groupB[@]} B_meanFA

#### Group A

if [ ! -d groupA ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir groupA
fi

for zzVAR in ${groupA[@]} ; do
cp ${zzVAR}/dti_FA_reg.nii.gz groupA/${zzVAR}dti_FA_reg.nii.gz
done

cd ${main_dir}/groupA

fslmaths ${groupA[0]}dti_FA_reg.nii.gz -add ${groupA[1]}dti_FA_reg.nii.gz A_FA

for (( i=2; i<${#groupA[@]}; i++ )); do

fslmaths A_FA.nii.gz -add ${i}dti_FA_reg.nii.gz A_FA


done

fslmaths A_FA.nii.gz -div ${#groupA[@]} A_meanFA
