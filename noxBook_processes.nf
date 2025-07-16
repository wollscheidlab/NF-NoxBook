process getClasses {
    input:
    path manifest_fp

    output:
    path "classes.txt"

    script:
    """
    cat $manifest_fp | awk -F"\t" '{print \$2}' | sort | uniq > classes.txt
    """
}


process noxPapermill {
    tag "$template_ipynb"
    cpus 2
    memory 5.GB

    publishDir 'Results/Jhub', mode: 'copy'

    input:
    // We start from nox_template.ipynb
    path template_ipynb
    tuple val(class_label1), val(class_label2)
    val input_folder
    val uniprot_annotation_filename
    val surfy_filename
    val reduce_to_labels
    val drop_samples
    val quantile_threshold
    val min_peptide_count
    val normalize
    val impute
    val filter_cv
    val gaf_filename
    val obo_filename

    output:
    path "nox_${class_label1}_vs_${class_label2}.ipynb", emit: ipynb
    path "volcano_batch_normalized.html", emit: volcano

    script:
    """
    papermill $template_ipynb nox_${class_label1}_vs_${class_label2}.ipynb \
	-p class_label1 $class_label1 \
	-p class_label2 $class_label2 \
	-p uniprot_annotation_filename $uniprot_annotation_filename \
	-p surfy_filename $surfy_filename \
	-p reduce_to_labels $reduce_to_labels \
	-p drop_samples "$drop_samples" \
	-p quantile_threshold $quantile_threshold \
	-p min_peptide_count $min_peptide_count \
	-p normalize $normalize \
	-p impute $impute \
	-p filter_cv $filter_cv \
	-p gaf_filename $gaf_filename \
	-p obo_filename $obo_filename \
	-p input_folder $input_folder	
    """
}


process noxToHtml{
    tag "$nox_ipynb"
    cpus 1
    memory 10.GB

    publishDir 'Results/Jhub', mode: 'copy'

    input:
    path nox_ipynb

    output:
    file '*.html'

    script:
    """
    jupyter-nbconvert --to html $nox_ipynb
    """
}


