//////////////////////////
// Workflow definitions //
//////////////////////////

include {getClasses;
	 noxPapermill;
	 noxToHtml} from './noxBook_processes.nf'

workflow noxWorkflow {
    take:
    experiment_annotation_fp
    template_ipynb
    class_label1
    class_label2
    input_folder
    fragpipe_workflow_fp
    uniprot_annotation_filename
    surfy_filename
    reduce_to_labels
    drop_samples
    quantile_threshold
    min_peptide_count
    normalize
    impute
    filter_cv
    gaf_filename
    obo_filename
    
    main:
    classes_fp = Channel.fromPath(file("$experiment_annotation_fp"))
        .splitCsv(sep: '\t', header: true)
        .map { row -> "${row.condition}" }  // Extract the condition column
    
    // Extract all classes from the FragPipe annotation file
    classes = classes_fp
        .splitText()
        .map { it.trim() } // Strip newline characters
        .unique() // Ensure unique classes

    // Generate combinations based on whether class_label2 is provided
    combinations = class_label2 ?
        // If class_label2 is provided, only compare experiment_annotation classes vs class_label2
        classes
        .filter { it != class_label2 } // Exclude class_label2 from the experiment_annotation classes
        .map { a -> 
            [a, class_label2] // No need to sort since we want class_label2 as the second element
        } :
        // Otherwise generate all pairwise combinations
        classes.combine(classes)
        .filter { a, b -> a != b } // Filter out same-word combinations
        .map { a, b -> 
            [a, b].sort() as List 
        }
        .unique() 

    //combinations.view()


    // Prepare the ipynb for each binary class combination
    noxPapermill(file("$baseDir/Notebooks/$template_ipynb"),
                 combinations,
		 fragpipe_workflow_fp,
                 input_folder,
                 uniprot_annotation_filename,
                 surfy_filename,
		 reduce_to_labels,
		 drop_samples,
                 quantile_threshold,
                 min_peptide_count,
                 normalize,
                 impute,
                 filter_cv,
                 gaf_filename,
                 obo_filename)

    // Export them to html 
    nox_ipynb = noxPapermill.out.ipynb
    noxToHtml(nox_ipynb)
}
