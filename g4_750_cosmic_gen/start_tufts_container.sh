#!/bin/bash

container=/cluster/tufts/wongjiradlabnu/coherent/singularity-geant4-10.02.p03-ubuntu20.02.simg

module load singularity/3.5.3

singularity shell --bind /cluster/tufts/:/cluster/tufts/,/tmp:/tmp $container
