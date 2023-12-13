#!/bin/bash

# Create directories
mkdir -p './../db/pubmlst/klebsiella'

# Download files
curl --output './../db/pubmlst/klebsiella/klebsiella.txt' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/schemes/1/profiles_csv'
curl --output './../db/pubmlst/klebsiella/infB.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/infB/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/pgi.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/pgi/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/mdh.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/mdh/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/rpoB.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/rpoB/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/phoE.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/phoE/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/tonB.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/tonB/alleles_fasta'
curl --output './../db/pubmlst/klebsiella/gapA.tfa' 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/loci/gapA/alleles_fasta'

echo "Data downloaded successfully!"
