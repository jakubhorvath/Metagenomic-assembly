RESULTS=$(RESULTS_DIR)/$(TARGET)
FASTQ_DIR=$(RESULTS)/fastq

all: $(RESULTS)/kraken_report.txt $(RESULTS)/classified.fastq $(RESULTS)/nanoplot $(RESULTS)/flye/assembly.fasta

clean:
	rm $(FASTQ_DIR)/aggregate.fastq.gz

.PHONY: all clean

#Basecalling
$(FASTQ_DIR)/pass/*.fastq $(FASTQ_DIR)/sequencing_summary.txt: $(DATA_DIR)/$(TARGET)/*.fast5
	mkdir -p $(RESULTS)
	guppy_basecaller --recursive --input_path $(<D) --save_path $(FASTQ_DIR) --config dna_r9.4.1_450bps_hac.cfg --chunks_per_runner 1024 --device 'auto'

#Nanoplot
$(RESULTS)/nanoplot: $(FASTQ_DIR)/sequencing_summary.txt
	mkdir $(RESULTS)/nanoplot
	NanoPlot -o $(RESULTS)/nanoplot --summary $(FASTQ_DIR)/sequencing_summary.txt --drop_outliers --loglength --N50 --font_scale 2 --dpi 150

#Combine and filter/trim
$(FASTQ_DIR)/trimmed.fastq.gz: $(FASTQ_DIR)/pass/*.fastq
	cat $(FASTQ_DIR)/pass/*.fastq | gzip > $(FASTQ_DIR)/aggregate.fastq.gz
	porechop-runner.py -i $(FASTQ_DIR)/aggregate.fastq.gz -o $(FASTQ_DIR)/trimmed.fastq.gz

#Kraken taxonomy
$(RESULTS)/kraken_report.txt: $(FASTQ_DIR)/trimmed.fastq.gz
	kraken2 --db $(KRAKEN_DB) --threads 24 --report $(RESULTS)/kraken_report.txt --gzip-compressed $(FASTQ_DIR)/trimmed.fastq.gz --unclassified-out $(RESULTS)/unclassified.fastq.gz --classified-out $(RESULTS)/classified.fastq

#NanoFltr
$(FASTQ_DIR)/filtered.fastq.gz: $(FASTQ_DIR)/trimmed.fastq.gz
	gunzip -c $(FASTQ_DIR)/trimmed.fastq.gz | NanoFilt -q 10 --headcrop 25 -l 500 | gzip > $(FASTQ_DIR)/filtered.fastq.gz


#Flye
$(RESULTS)/flye/assembly.fasta : $(FASTQ_DIR)/filtered.fastq.gz
	mkdir $(RESULTS)/flye
	flye --nano-raw $(FASTQ_DIR)/filtered.fastq.gz   --out-dir $(RESULTS)/flye -t 24 --meta
