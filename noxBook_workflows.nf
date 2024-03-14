//////////////////////////
// Workflow definitions //
//////////////////////////

include {getClasses;
	 noxPapermill;
	 noxToHtml} from './noxBook_processes.nf'


workflow noxWorkflow {
    take:
    manifest_fp
    template_ipynb
    class_label1
    class_label2
    input_folder
    uniprot_annotation_filename
    surfy_filename
    quantile_threshold
    min_peptide_count
    normalize
    impute
    filter_cv
    gaf_filename
    obo_filename
    
    main:
//    classes_fp = getClasses(file("$manifest_fp"))

    classes_fp = Channel.fromPath(file("$manifest_fp"))
                 .splitCsv(sep: '\t', header: false) // Split by tabs, assuming a header row  
        .map { it[1] }  // Extract the second column
    
    // Extract all classes from the FragPipe annotation file
    classes = classes_fp
        .splitText()
        .map { it.trim() } // Strip newline characters


    // Generate combination of classes (order independent)
    combinations = classes.combine(classes)
        .filter { a, b -> a != b } // Filter out same-word combinations
        .map { a, b -> 
            [a, b].sort() as List 
        }
        .unique() 

    combinations.view()
    
    // Prepare the ipynb for each binary class combination
    noxPapermill(file("$baseDir/Notebooks/$template_ipynb"),
		 combinations,
		 input_folder,
		 uniprot_annotation_filename,
		 surfy_filename,
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
