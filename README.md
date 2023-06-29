## MaxiKraken DB
To download full Kraken DB (maxikraken2_1903_140GB) run these commands.
```
mkdir maxikraken2_1903_140GB/
cd maxikraken2_1903_140GB/
wget -bcq https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/hash.k2d
wget -bcq https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/opts.k2d
wget -bcq https://refdb.s3.climb.ac.uk/maxikraken2_1903_140GB/taxo.k2d
```

## MiniKraken DB
To download 'fatfree' Kraken DB (kraken2-microbial-fatfree) run these commands.
```
mkdir kraken2-microbial-fatfree/
cd kraken2-microbial-fatfree/
wget -bcq https://refdb.s3.climb.ac.uk/kraken2-microbial/hash.k2d
wget -bcq https://refdb.s3.climb.ac.uk/kraken2-microbial/opts.k2d
wget -bcq https://refdb.s3.climb.ac.uk/kraken2-microbial/taxo.k2d
```


## Example FAST5 files
Download example fast5 files for testing.
```
mkdir fast5/
cd fast5/
wget -bcq http://s3.amazonaws.com/nanopore-human-wgs/rna/Multi_Fast5/Bham_Run1_20171009_DirectRNA_Multi/Bham_Run1_20171009_DirectRNA_100.fast5
wget -bcq http://s3.amazonaws.com/nanopore-human-wgs/rna/Multi_Fast5/Bham_Run1_20171009_DirectRNA_Multi/Bham_Run1_20171009_DirectRNA_101.fast5
wget -bcq http://s3.amazonaws.com/nanopore-human-wgs/rna/Multi_Fast5/Bham_Run1_20171009_DirectRNA_Multi/Bham_Run1_20171009_DirectRNA_102.fast5
```