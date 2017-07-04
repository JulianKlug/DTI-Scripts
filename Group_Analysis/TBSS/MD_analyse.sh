#!/bin/sh

#  MD_analyse.sh
#  
#
#  Created by Julian on 8/10/16.
#

#Put me in your /home/bin/, and remember to make me executable with chmod a+rwx MD_analyse.

#Run the full TBSS analysis (see other scripts) on your FA data first.

subjs="01 02 03 04"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"
cd ${main_dir}/tbss

if [ ! -d MD ]; then
# Control will enter here if $DIRECTORY doesn't exist.
mkdir MD
fi

for VARsubj in ${subjs} ; do

# MD file is renamed FA so that tbss algorithm works
echo "Copying MD image for ${VARsubj}"
cp ${main_dir}/${VARsubj}/dti_MD.nii.gz ${main_dir}/tbss/MD/${VARsubj}"_FA".nii.gz


done

cd ${main_dir}/tbss

tbss_non_FA MD


cd ${main_dir}/tbss/stats

randomise -i all_MD_skeletonised -o tbss_MD -m mean_FA_skeleton_mask -d design.mat -t design.con -n 500 --T2 -V

fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green \
-b .3,.7 tbss_MD_tstat1 -l Red-Yellow -b 1.5,3 tbss_MD_tfce_corrp_tstat1 \
-l Blue-Lightblue -b 0.949,1 &

echo "End"
