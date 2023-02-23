import sys

# Dictionary to store single-copy conserved genes
single_copy_conserved = {}

# List to store input file names
input_files = sys.argv[1:]

# Count the number of input files
num_files = len(input_files)

# Iterate over input files
for input_file in input_files:
    with open(input_file, 'r') as f:
        # Count the number of genes in the input file
        gene_count = 0
        for line in f:
            if line.startswith('# Busco id'):
                gene_count += 1
        
        # Read the input file again and identify single-copy conserved genes
        with open(input_file, 'r') as f:
            for line in f:
                if not line.startswith('#'):
                    fields = line.strip().split('\t')
                    busco_id = fields[0]
                    status = fields[1]
                    if status == 'Complete':
                        if busco_id not in single_copy_conserved:
                            single_copy_conserved[busco_id] = [False] * num_files
                        single_copy_conserved[busco_id][input_files.index(input_file)] = True

# Iterate over single-copy conserved genes and print those present in all input files
for busco_id, present_in_files in single_copy_conserved.items():
    if all(present_in_files):
        print(busco_id)
