# DTI-Scripts
A selection of scripts to guide and automate DTI analysis with FSL

## Tools:
•	Osirix – organize data
•	Dcm2niix – convert dicom to nifti
    from: https://github.com/rordenlab/dcm2niix
    needs to be installed and added to path
•	FSL – analyze data

## Steps

1. Extract nifti, bvals and bvecs from dicoms: 
    - Use the dcm2niix command line tool on dicom folder
    - place example.nii, example.bval and example.bvec in this subject's folder
    - Rename output to exampleSubject.nii, exampleSubject.bval and exampleSubject.bvec (or however your subject is named)

2. Organize your study directory:
    - Subject data should be in subject folder (ex: /Ana/subject1)
    - The subject folder and the subject's data should have the same name
    - Bvals, Bvecs and .nii files should be in every subject's folder (ex: /Ana/subject1/subject1.nii)

3. Compute DTI
    - Open the DTI_Computation.sh file
    - Modify the line 'subjs="subj01 subj02"' to list your subjects (ex: subjs="subject1 subject2 subject3")
    - Modify the line 'main_dir="/your/path/to/main/directory"' to point to the study directory (ex: main_dir="/Users/example/Ana")
    - Copy Paste the modified script into your terminal and run it (this might take some time)

4. View DTI images
    - Use fsleyes to view the computed images

4. ROI Data Extraction
    - Open the singleSubROI.sh file in ROI_Analysis/singleSubject/automaticROI
    - Modify the line 'subjs="subj01"' to match to your subject
    - Modify the line main_dir="/your/path/to/main/directory" to match your study directory
    - Modify the line ROIname="n8_R" to match your ROI
    - In fsleyes, identify the coordinates of your ROI and enter them into the singleSubROI.sh 
    - Copy the first part (until the checkpoint) into your editor and execute it - a window will open
    - Verify the position of the ROI. 
    - If it is correctly place, copy paste the rest of the file in your terminal and execute it. Otherwise repeat from start and change coordinates.
    - Data is saved in Analysis/Analysis.txt

