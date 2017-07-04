#!/bin/sh

#  Copy_FA.sh
#  
#
#  Created by Julian on 8/10/16.
#

#Put me in your /home/bin/, and remember to make me executable with chmod a+rwx Copy_FA.

#Copy each subject's FA image to the TBSS directory

#If you want to copy other images too, e.g. MD images, then repeat the for loop below, changing "dti_FA.nii.gz" to "dti_MD.nii.gz".

groupA="01 02"
groupB="03 04"
#Put your subject folders in here

#Write your main directory here
main_dir="/Users/julian/documents/DTI_Project/test2.5"
cd ${main_dir}

if [ ! -d FA_A ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir FA_A
fi

if [ ! -d FA_B ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir FA_B
fi

for zzVARcopy in ${groupA} ; do
echo "Copying FA image for ${zzVARcopy}"
cp ${zzVARcopy}/dti_FA.nii.gz FA_A/${zzVARcopy}"_FA".nii.gz
done

for zzVARcopy in ${groupB} ; do
echo "Copying FA image for ${zzVARcopy}"
cp ${zzVARcopy}/dti_FA.nii.gz FA_B/${zzVARcopy}"_FA".nii.gz
done


echo "End"
