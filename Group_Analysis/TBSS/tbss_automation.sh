#!/bin/sh

#  tbss_automation.sh
#  
#
#  Created by Julian Klug on 8/9/16.
#
#   Instructions
#   the dti_FA.nii.gz files of all subjects are regrouped in the tbss directory
#   nothing else should be in the tbss directory

subjs="groupB groupA"
#Put your subject folders in here

#Write your main directory here
main_dir="/path/to/directory"
cd ${main_dir}


#run tbss preproccessing on all NIFTI files of the tbss directory
cd ${main_dir}/tbss

tbss_1_preproc *.nii.gz

cd ${main_dir}/tbss/FA/slicesdir
open index.html
echo "Images in browser should seem reasonable. Else, consider retrying with tweaked parameters."
echo "Close browser tab, when finished."

#
echo "This will take ~ 10min per subject."

cd ${main_dir}/tbss
tbss_2_reg -T

#if the subjects are all young children
#tbss_2_reg -n

#
tbss_3_postreg -S

cd ${main_dir}/tbss/stats
echo "Skeleton should be reasonably aligned. Else, consider retrying with tweaked parameters."
echo "mean_FA and mean_FA_skeleton in fslview can be closed after viewing them."
fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA -l Red-Yellow -b .2,.6 &
fslview all_FA mean_FA_skeleton -l Green -b .2,.6

#
cd ${main_dir}/tbss
tbss_4_prestats 0.2

cd ${main_dir}/tbss/stats
echo "Enter design-parameters and save design as 'design'"
echo "Be careful, by default the subjects are attributed to the groups by order of subject number."
echo "Change Timeseries design to Higher-level / non-timeseries design. Change the number of inputs to the number of subjects (you may have to press Return after typing in the number) and then use the wizard to setup the two-group unpaired t-test. Reduce the number of contrasts to 2 (we're not interested in the group means on their own). Finally, save the design as filename design."
echo "Then close de Glm_Gui"
Glm_gui

randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask \
-d design.mat -t design.con --T2

fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green \
-b .3,.7 tbss_tstat1 -l Red-Yellow -b 1.5,3 tbss_tfce_corrp_tstat1 \
-l Blue-Lightblue -b 0.949,1 &

#unthresholded data view
#fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green -b 0.2,0.8 tbss_tstat1 -l Red-Yellow -b 3,6 tbss_tstat2 -l Blue-Lightblue -b 3,6

#thresholded data view
#fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green \
#-b .3,.7 tbss_tfce_corrp_tstat2 -l Red-Yellow -b 0.95,1 tbss_tfce_corrp_tstat1 \
#-l Blue-Lightblue -b 0.949,1 &



## or
#
#randomise -i all_FA_skeletonised -o tbss -m mean_FA_skeleton_mask \
#-d design.mat -t design.con -c 1.5
#
#fslview $FSLDIR/data/standard/MNI152_T1_1mm mean_FA_skeleton -l Green \
#-b .3,.7 tbss_tstat1 -l Red-Yellow -b 1.5,3 tbss_clustere_corrp_tstat1 \
#-l Blue-Lightblue -b 0.949,1 &





