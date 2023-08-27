#!/bin/bash

# SCRIPT ARGUMENTS

# directory of the code
G4_COH_LAR_DIR=$1

# location of file with "FileID" numbers for booking purposes
FILEID_LIST_PATH=$2
# if you need a new file with sequtial numbers, do seq

# project directory
PROJECT_DIR=$3

# working dir for logs, macros
WORKDIR=$4

# output dir for output files
OUTPUTDIR=$5

# NUM EVENTS
NUMEVENTS=1000

# -----------------------
# Setup the job numbers
# -----------------------

# jobid is just the slurm array id
jobid=${SLURM_ARRAY_TASK_ID}

# line number we will read from the "FileID" file @ FILEID_LIST_PATH
let lineno=${jobid}+1

# we get a file id from the fileid list to run
# use sed to dump out file id at the given line, assign output to fileid variable
let fileid=`sed -n ${lineno}p ${FILEID_LIST_PATH}`

# we will use this fileid to label output file, logs, etc.
# so we need a string version
zfileid=`printf %06d ${fileid}`

# -------------------------
# Make a working directory
# -------------------------
workdir_folder=`printf g4_coh750_cosmicgen_jobid%03d_fileid%06d ${jobid} ${fileid}`
workdir_path=${WORKDIR}/${workdir_folder}
mkdir -p $workdir_path

# --------------------------
# Make output directory
# --------------------------
# For file system health, we do not want to put more than 100 files in a folder
let subdir1_no=${fileid}%100
let subdir2_no=(${fileid}%10000)/100
let subdir3_no=${fileid}/10000
subdir=`printf %03d/%02d ${subdir3_no} ${subdir2_no}`
echo "subdir: ${subdir}"

# ----------------------
# Setup the environment
# ----------------------
# Note: we assume we are already in the container

cd $G4_COH_LAR_DIR

# set paths to ROOT and GEANT4
source setup_container.sh

# set other sim environment paths
source setenv.sh

# go back to the workdir
cd $workdir_path

# ------------------------
# Make the macro file
# ------------------------

# define the output file name
outputname=`printf g4_cohlar_cosmicgen_fileid%s.root ${zfileid}`

# define the macro name
macname=`printf run_cosmic_event_store_fileid%s.mac ${zfileid}`

# cp the macro file to the working directory
cp $PROJECT_DIR/run_cosmic_event_store_template.mac $macname

# replace lines in the template macro
sedcmd1="s|XXXXXX|${NUMEVENTS}|g"
sedcmd2="s|YYYYYY|${outputname}|g"
sedcmd3="s|ZZZZZZ|${G4_COH_LAR_DIR}/macro|g"

#echo $sedcmd1
#echo $sedcmd2
#echo $sedcmd3

sed -i $sedcmd1 $macname
sed -i $sedcmd2 $macname
sed -i $sedcmd3 $macname

# ----------------------
# define logfile
# ---------------------
logfile_path=`printf ${WORKDIR}/log_jobid%d_fileid%d.txt ${jobid} ${fileid}`

mkdir -p $OUTPUTDIR/$subdir/
cenns.exe -m $macname &> $logfile_path
cp $outputname $OUTPUTDIR/$subdir/
ls -lh $OUTPUTDIR/$subdir/$outputname >> $logfile_path

