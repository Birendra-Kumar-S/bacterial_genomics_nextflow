# bacterial_genomics_nextflow_pipeline

A modular Nextflow pipeline for bacterial genome QC and assembly, developed as part of Georgia Tech's BIOL7210 Computational Genomics course.

This repository contains a **Nextflow pipeline** for performing **quality control**, and assembling genomic sequences.

📌 **Course**: BIOL7210 - Computational Genomics  
📌 **Author**: S Birendra Kumar  
📌 **Institution**: Georgia Tech  
📌 **GitHub Repo**: `https://github.com/Birendra-Kumar-S/bacterial_genomics_nextflow`  
📌 **Nextflow Version**: `24.10.4.5934`  
📌 **Profile Used**: `conda`

## **Workflow Overview**
This workflow **performs quality control, calculates trimmed read statistics and assembles genomic sequences.**  
The pipeline supports **both sequential and parallel processing** to optimize execution.

### **📌 Workflow Execution Order**
1️⃣ **Sequential Execution**:
- **FASTP** → `SKESA` (Genome Assembly)

2️⃣ **Parallel Execution**:
- **FASTP** → `SEQKIT` (Read Statistics)

### Key Features

- **Read Processing**
  - Quality control and adapter trimming with **FASTP (v0.24.0)**
  
- **Assembly**
  - De novo genome assembly with **SKESA (v2.5.1)**
  
- **READ statistics**
  - Calculation of quality filtered or trimmed reads' statistics using **SeqKit (v2.10.0)**




## DAG Workflow Diagram 
Diagram illustrating the pipeline's workflow, showing the sequence of processes and their dependencies. Obtained using Nextflow's built-in DAG visualization tool.

<div align="center">
  <img src="workflow.png" alt="Dag flow" width="500"/>
</div>








## Tools Used

- [Nextflow](https://www.nextflow.io/) - Workflow engine (DSL2)
- [FASTP](https://github.com/OpenGene/fastp) - Read quality control
- [SKESA](https://github.com/ncbi/SKESA) - De novo assembly
- [SeqKit](https://github.com/shenwei356/seqkit) - Read Statistics



## Acknowledgements

This pipeline was developed as part of the **Georgia Tech's BIOL7210 - Computational Genomics** course.

I would also like to thank **[Dr. Christopher Gulvik](https://github.com/chrisgulvik)**, the instructor of the course, for his guidance and support throughout the coursework.



## Contact

For questions or issues specific to the repository, please submit an issue.
For collaboration inquiries or general questions, feel free to reach out:

**[S Birendra Kumar](https://www.linkedin.com/in/s-birendra-kumar/)**  
MS Bioinformatics  
*[skumar752](mailto:sbirendra2000@gatech.edu)*  
