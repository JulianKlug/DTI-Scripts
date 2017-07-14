DTI_Computation#!/bin/sh

#  DTI_Computation.sh
#  
#
#  Created by Julian on 8/12/16.
#

#To make this excecutable:
#Put me in your /home/bin/, and make me executable with chmod a+rwx DTI_Computation.

#Preprocessing: b0 extraction, brain extraction, eddy-correction
#Processing: DTI estimation

subjs="subj01 subj02"
#Put your subject folders in here

#Write your main directory here
main_dir="/your/path/to/main/directory"
cd ${main_dir}

#Extract b0
for zzVARroi in ${subjs} ; do
echo "Extracting b0 image for ${zzVARroi}"
fslroi ${zzVARroi}/${zzVARroi}.nii ${zzVARroi}/nodif.nii.gz 0 1
done

#Extract brain
for zzVARbet in ${subjs} ; do
echo "Betting nodif image for ${zzVARbet}"
cd ${main_dir}/${zzVARbet}/
bet nodif.nii.gz nodif_brain.nii.gz -m -f 0.1
done

cd ${main_dir}

#### If pre eddy correction visualisation for vector examination is necessary

#for zzVARdti in ${subjs} ; do
#echo "Running Pre eddy dtifit for ${zzVARdti}"
#cd ${main_dir}/${zzVARdti}
#
#if [ ! -d Pre_ec ]; then
## Control will enter here if $DIRECTORY doesn't exist.
#mkdir Pre_ec
#fi
#
#dtifit -k ${zzVARdti}.nii.gz -m nodif_brain_mask.nii.gz -r ${zzVARdti}.bvecs -b ${zzVARdti}.bvals -o Pre_ec/dti_pre_ec
#echo "Close fslview aafter examination"
#fslview dti_pre_ec_FA.nii.gz
#done

for zzVARec in ${subjs} ; do
echo "${zzVARec} eddy correcting"
eddy_correct ${zzVARec}/${zzVARec}.nii ${zzVARec}/${zzVARec}"ec".nii.gz 0
done

## Specify bvals/bvecs versus bval/bvec
for zzVARdti in ${subjs} ; do
echo "Running dtifit for ${zzVARdti}"
cd ${zzVARdti}/
dtifit -k ${zzVARdti}"ec".nii.gz -m nodif_brain_mask.nii.gz -r ${zzVARdti}.bvec -b ${zzVARdti}.bval -o dti
cd ${main_dir}
done


echo "End"


cd ${main_dir}
