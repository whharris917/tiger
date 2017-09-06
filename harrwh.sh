#!/bin/sh

#PBS -N harrwh_job2
#PBS -l select=10:ncpus=12:mpiprocs=12
#PBS -l place=scatter:excl
#PBS -l walltime=01:00:00
#PBS -mea
#PBS -M whharris@ncsu.edu
#PBS -A harrwh_project2

cd /home/harrwh/projects/tiger
source /etc/profile.d/modules.sh
module load use.moose
module load moose-dev-gcc

mpiexec ./tiger-opt -i ./3DHomogenizedK_new.i
echo "done"

