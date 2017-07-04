#!/bin/sh

#  Get_mean_FA.sh
#  
#
#  Created by Julian on 8/10/16.
#
#
#   Instructions
#   the dti_FA.nii.gz files of all subjects are regrouped in the FA_A and FA_B directory
#   nothing else should be in these directories

groups="FA_A FA_B"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"

for gr in ${groups} ; do
cd ${main_dir}/${gr}

#run tbss preproccessing on all NIFTI files of the gr (FA_A then FA_B) directory

tbss_1_preproc *.nii.gz

cd ${main_dir}/${gr}/FA/slicesdir
open index.html
echo "Images in browser should seem reasonable. Else, consider retrying with tweaked parameters."
echo "Close browser tab, when finished."

#
echo "This will take ~ 10min per subject."

cd ${main_dir}/${gr}
tbss_2_reg -T

#if the subjects are all young children
#tbss_2_reg -n

#
tbss_3_postreg -S

cd ${main_dir}/${gr}/stats
echo "Skeleton should be reasonably aligned. Else, consider retrying with tweaked parameters."
echo "mean_FA and mean_FA_skeleton in fslview can be closed after viewing them."
fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA -l Red-Yellow -b .2,.6

done

cd ${main_dir}
fslview /FA_A/stats/mean_FA.nii.gz /FA_B/stats/mean_FA.nii.gz &

#




