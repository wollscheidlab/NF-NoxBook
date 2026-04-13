nextflow.enable.dsl=2


include {noxWorkflow} from './noxBook_workflows.nf'

workflow {
    main:
    if (params.help) {
	log.info("++++++++++==================================================")
	log.info("")
	log.info("Executes NoxBook jupyter notebook")
	log.info("---------------------------------")
	log.info("")
	log.info("Options:")
	log.info("  --help:            show this message and exit")
	log.info("  --template_ipynb:  name of the jupyter notebook template")
	log.info("                     must be in Notenooks directory")
	log.info("  --class_label1:    name of the first class")
	log.info("  --class_label2:    name of the second class")
	log.info("  --input_folder:    folder with the FragPipe results")
	log.info("  --uniprot_annotation_filename:  uniprot annotation file")
	log.info("  --surfy_filename:  surfy annotation file")
	log.info("  --reduce_to_labels: reduce matrices to samples from class_label1 and class_label2")
	log.info("  --drop_samples:    list of sample names to be dropped")	
	log.info("  --quantile_threshold:  quantile threshold for removing")
	log.info("                         low intensity proteins")
	log.info("  --min_peptide_count:  minimum number of peptides per protein")
	log.info("  --peptide_missingness_cutoff: highest tolerated fraction of missing values")
	log.info("  --normalize:	   median normalize the data (DEPRECATED)")
	log.info("  --normalize_peptide:   median normalize the data at peptide level")
	log.info("  --normalize_protein:   median normalize the data at protein level")	
	log.info("  --impute:	   impute missing values (DEPRECATED)")	
	log.info("  --impute_protein:	   impute missing values at protein level")	
	log.info("  --filter_cv:	   filter proteins based on CV")
	log.info("  --gaf_filename:	   GO annotation file")
	log.info("  --obo_filename:	   GO OBO file")
	log.info("")
	log.info("Results will be in Results/Jhub/")
	log.info("")
	log.info("++++++++++=================================================")
    }


    noxWorkflow(params.experiment_annotation_fp,
		params.template_ipynb,
		params.class_label1,
		params.class_label2,
		params.input_folder,
		params.fragpipe_workflow_fp,
		params.uniprot_annotation_filename,
		params.surfy_filename,
		params.reduce_to_labels,
		params.drop_samples,
		params.quantile_threshold,
		params.min_peptide_count,
		params.peptide_missingness_cutoff,
		params.normalize,
		params.normalize_peptide,
		params.normalize_protein,
		params.impute,
		params.impute_protein,
		params.filter_cv,
		params.gaf_filename,
		params.obo_filename
	)
}
