nextflow.enable.dsl=2

params.input_dir = "test_data"
params.results_dir = "results"

new File(params.results_dir).mkdirs()

// 📌 PROCESS 1: FASTP
process FASTP {
    tag "FASTP QC for ${sample_id}"
    publishDir "${params.results_dir}", mode: 'copy', overwrite: true
    conda 'envs/tools.yaml'

    input:
    tuple val(sample_id), path(fastq1), path(fastq2)

    output:
    tuple val(sample_id),
          path("${sample_id}_1_trimmed.fastq.gz"),
          path("${sample_id}_2_trimmed.fastq.gz"),
          path("${sample_id}_fastp.html"),
          path("${sample_id}_fastp.json")

    script:
    """
    fastp \\
      -i ${fastq1} \\
      -I ${fastq2} \\
      -o ${sample_id}_1_trimmed.fastq.gz \\
      -O ${sample_id}_2_trimmed.fastq.gz \\
      --cut_front --cut_tail \\
      --cut_front_window_size 4 \\
      --cut_tail_window_size 4 \\
      --cut_front_mean_quality 20 \\
      --cut_tail_mean_quality 20 \\
      --html ${sample_id}_fastp.html \\
      --json ${sample_id}_fastp.json \\
      --thread ${task.cpus}
    """
}

// 📌 PROCESS 2: SKESA
process SKESA {
    tag "SKESA Assembly for ${sample_id}"
    publishDir "${params.results_dir}", mode: 'copy', overwrite: true
    conda 'envs/tools.yaml'

    input:
    tuple val(sample_id), path(trimmed1), path(trimmed2)

    output:
    tuple val(sample_id), path("${sample_id}.fna")

    script:
    """
    skesa \\
      --reads "${trimmed1},${trimmed2}" \\
      --cores ${task.cpus} \\
      --min_contig 1000 \\
      --contigs_out ${sample_id}.fna
    """
}

// 📌 PROCESS 3: SEQKIT STATS
process SEQKIT_STATS {
    tag "SeqKit stats for ${sample_id}"
    publishDir "${params.results_dir}", mode: 'copy', overwrite: true
    conda 'envs/tools.yaml'

    input:
    tuple val(sample_id), path(trimmed1), path(trimmed2)

    output:
    tuple val(sample_id), path("${sample_id}_seqkit_stats.txt")

    script:
    """
    seqkit stats "${trimmed1}" "${trimmed2}" > "${sample_id}_seqkit_stats.txt"
    """
}

// 📌 WORKFLOW
workflow {
    Channel.fromFilePairs("${params.input_dir}/*_{1,2}.fastq.gz", size: 2)
        .map { sample_id, files -> 
            tuple(sample_id, file(files[0]), file(files[1])) 
        }
        .set { raw_reads }

    FASTP(raw_reads)

    FASTP.out
        .map { sample_id, r1, r2, html, json -> 
            tuple(sample_id, r1, r2)
        }
        .set { trimmed_reads }

    SKESA(trimmed_reads)
    SEQKIT_STATS(trimmed_reads)

    workflow.onComplete {
    println "\n✅✅===================================================="
    println "🏁🏆 PIPELINE EXECUTION COMPLETE — All systems GO! 🏆🏁"
    println "====================================================✅✅"
    println "\u001B[1m📁 All output files have been saved to results directory\u001B[0m"
    println "📊 This includes trimmed FASTQ files, FASTP reports, assemblies, and seqkit stats."
    println "=============================================================\n"
    }

}
