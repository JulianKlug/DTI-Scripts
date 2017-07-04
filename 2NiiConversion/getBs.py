

main_dir=""

outputDir=""

file = "yourfile.dcm"
ext = "*.dcm"
fileloc = main_dir + file


import dicom
import struct
import numpy as np
import sys
import glob
import os

ds=dicom.read_file(file,force='force')

bval=ds[0x0019,0x100c].value

# BV=' '.join(str(i) for i in ds[0x0019,0x100e].value)

# bvec=struct.unpack('ddddhc',BV)
# bvec=struct.unpack('>ddd',BV)

bvec=ds[0x0019,0x100e].value

img_plane_position=ds[0x0020, 0x0037].value
bvec=np.array(bvec)
# find the three orthoganal bases for the image plane
V1=np.array([float(img_plane_position[0]),float(img_plane_position[1]),float(img_plane_position[2])])
V2=np.array([float(img_plane_position[3]),float(img_plane_position[4]),float(img_plane_position[5])])
V3=np.cross(V1,V2)
# Convert bvec to this plane by projecting the vector to V1,V2 and V3
pbvec=np.zeros(3)
pbvec[0]=np.dot(V1,bvec)
pbvec[1]=np.dot(V2,bvec)
pbvec[2]=np.dot(V3,bvec)


bvalList,bvecList = [], []

# for  dicom_file in sorted(glob.glob(os.path.join(main_dir,ext))):
for  dicom_file in sorted(glob.glob(ext)):
    print dicom_file
    info=dicom.read_file(dicom_file,force='force')
    #print info
    bval=info[0x0019,0x100c].value
    bvalList.append(str(bval))
    if info[0x0019,0x100d].value=='NONE':
        bvec=[0,0,0]
    else:
        inf=' '.join(str(i) for i in info[0x0019,0x100e].value)

        # buffer=struct.unpack('ddd',info[0x0019,0x100e].value)
        buffer=info[0x0019,0x100e].value
        img_plane_position=info[0x0020, 0x0037].value
        vec=np.array(buffer)
        V1=np.array([float(img_plane_position[0]),
        float(img_plane_position[1]),float(img_plane_position[2])])
        V2=np.array([float(img_plane_position[3]),
        float(img_plane_position[4]),float(img_plane_position[5])])
        V3=np.cross(V1,V2)
        bvec=np.zeros(3)
        bvec[0]=np.dot(V1,vec)
        bvec[1]=np.dot(V2,vec)
        bvec[2]=np.dot(V3,vec)
        bvecList.append(bvec)

        #write output to bvals and bvecs
        bvals, bvecs = open(os.path.join(outputDir,'01.bvals'), 'w'), open(os.path.join(outputDir,'01.bvecs'), 'w')
        bvals.write(' '.join(bvalList))
        bvecs.write(' '.join([str(bvecX[0]) for bvecX in bvecList]) + '\n')
        bvecs.write(' '.join([str(bvecY[1]) for bvecY in bvecList]) + '\n')
        bvecs.write(' '.join([str(bvecZ[2]) for bvecZ in bvecList]))
        bvals.close()
        bvecs.close()
