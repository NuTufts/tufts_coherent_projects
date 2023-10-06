#!/bin/bash

# setup ROOT and GEANT4 in cenns10geant4 dependencies container
# see https://github.com/nutufts/coherent-containers for more information
# On the TUFTS cluster, the container is located at 
# /cluster/tufts/wongjiradlab/coherent/geant4_v10.6.03.simg

source /usr/local/root/bin/thisroot.sh 
source /usr/local/geant/geant4.10.06.p03/bin/geant4.sh

G4_COH_LAR_DIR=/cluster/tufts/wongjiradlabnu/twongj01/coherent/g4-coh-ar-750/
export COH_PROJECT_BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $G4_COH_LAR_DIR
source setenv.sh

cd $COH_PROJECT_BASEDIR
