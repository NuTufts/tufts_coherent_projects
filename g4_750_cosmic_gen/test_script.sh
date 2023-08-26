#!/bin/bash

export SLURM_ARRAY_ID=4

G4_COH_LAR_DIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/g4-coh-ar-750/
FILEID_LIST_PATH=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/fileid.list
PROJECT_DIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/
WORKDIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/workdir/
OUTPUTDIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/tufts_coherent_projects/g4_750_cosmic_gen/output/

source node_job_cosmic_gen.sh $G4_COH_LAR_DIR $FILEID_LIST_PATH $PROJECT_DIR $WORKDIR $OUTPUTDIR
