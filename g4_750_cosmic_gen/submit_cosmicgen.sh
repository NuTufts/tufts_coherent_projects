#!/bin/bash

# slurm submission script for making larmatch training data

#SBATCH --job-name=cohlar750_cosmic
#SBATCH --output=cohlar750_cosmic_test.log
#SBATCH --mem-per-cpu=4000
#SBATCH --time=8:00:00
#SBATCH --array=1-99
#SBATCH --cpus-per-task=1
#SBATCH --partition=batch,preempt,wongjiradlab
##SBATCH --partition=preempt
##SBATCH --partition=wongjiradlab
##SBATCH --gres=gpu:p100:3
##SBATCH --partition ccgpu
##SBATCH --gres=gpu:t4:1
##SBATCH --nodelist=ccgpu01

container=/cluster/tufts/wongjiradlabnu/coherent/singularity-geant4-10.02.p03-ubuntu20.02.simg
G4_COH_LAR_DIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/g4-coh-ar-750/
FILEID_LIST_PATH=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/fileid.list
PROJECT_DIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/
WORKDIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/workdir/
OUTPUTDIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/output/

module load singularity/3.5.3

srun singularity exec -B /cluster/tufts:/cluster/tufts ${container} bash -c "cd ${PROJECT_DIR} && source node_job_cosmic_gen.sh $G4_COH_LAR_DIR $FILEID_LIST_PATH $PROJECT_DIR $WORKDIR $OUTPUTDIR"

