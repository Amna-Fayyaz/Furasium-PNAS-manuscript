#!/usr/bin/env python3
import sys

headers = []
sample2sequence = {}

for line in sys.stdin:
    line = line.strip()
    if line.startswith('##'):
        continue
    if line.startswith('#CHROM'):
        headers = line.split('\t')
        continue
    data = line.split('\t')
    alleles = [data[3]] + data[4].split(',')
    for i in range(9, len(data)):
        if data[i].startswith('.'):
            allele = '-'
        else:
            allele = alleles[int(data[i])]
        if allele is None:
            raise ValueError("couldn't figure out allele for " + line)
        if i not in sample2sequence:
            sample2sequence[i] = ""
        sample2sequence[i] += allele

for i in range(9, len(headers)):
    print(">" + headers[i])
    print(sample2sequence[i])
