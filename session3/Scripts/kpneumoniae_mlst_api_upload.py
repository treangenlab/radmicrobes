#!/usr/bin/env python3
# Upload contigs file to PubMLST K. pneumoniae species identifier via RESTful API
# Written by Keith Jolley
# Adapted by William Shropshire
# Copyright (c) 2018, University of Oxford
# Licence: GPL3

import sys, requests, argparse, base64, json

parser = argparse.ArgumentParser()
parser.add_argument('--file', '-f', type=str, default='contigs.fasta', help='assembly contig filename (FASTA format)')
args = parser.parse_args()

def main():
    uri = 'https://bigsdb.pasteur.fr/api/db/pubmlst_klebsiella_seqdef/schemes/1/sequence'
    with open(args.file, 'r') as x: 
        fasta = x.read()
    
    payload = {"base64": True, "details": True, "sequence": base64.b64encode(fasta.encode()).decode()}
    response = requests.post(uri, json=payload)
    
    if response.status_code == requests.codes.ok:
        data = response.json()
        fields = data.get('fields', {})
        if not fields:
            print("No match")
            sys.exit(0)
        
        st = fields.get('ST')
        if st is not None:
            print("ST: " + str(st))
        else:
            print("No ST information in the response")
        
        exact_matches = data.get('exact_matches', {})
        for gene, matches in exact_matches.items():
            allele_ids = ", ".join(str(match.get('allele_id')) for match in matches)
            print(f"\nExact Matches for {gene}: {allele_ids}")
                
    else:
        print(response.text)

if __name__ == "__main__":
    main()