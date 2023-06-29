#!/bin/bash
#PBS -q gpu@meta-pbs.metacentrum.cz
#PBS -l walltime=4:0:0
#PBS -l select=1:ncpus=32:ngpus=1:mem=200gb:scratch_local=20gb
#PBS -N IV114_barcode_analysis

trap 'clean_scratch' TERM EXIT # Clean SCRATCH memory in case of error

# SCRATCHDIR = local working directory (fast SSDs)
cd $SCRATCHDIR || exit 1

module add guppy-6.0.6-gpu
module add python36-modules-gcc # for NanoPlot
module add porechop-0.2.4
module add kraken2-1.2
module add flye-2.8

export STORAGE_DIR=/storage/brno2/home/xmisenko # Home directory with persistent data

# Copy from long-term storage to local working directory
ln -s $STORAGE_DIR/iv114-metagenomic-assembly $SCRATCHDIR/iv114-metagenomic-assembly
ln -s $STORAGE_DIR/data $SCRATCHDIR/data
ln -s $STORAGE_DIR/results $SCRATCHDIR/results
ln -s $STORAGE_DIR/kraken_db $SCRATCHDIR/kraken_db

# Makefile variables
export RESULTS_DIR=$SCRATCHDIR/results
export DATA_DIR=$SCRATCHDIR/data
export KRAKEN_DB=$SCRATCHDIR/kraken_db/maxikraken2_1903_140GB


cd iv114-metagenomic-assembly

for DATA in barcode05 barcode06 barcode09 barcode10
do
    make TARGET=$DATA
done
