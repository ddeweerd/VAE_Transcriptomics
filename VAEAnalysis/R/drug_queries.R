#' @export
disorder_to_genes <- function(mondo_id){
  all_edges %>% filter(grepl("entrez", sourceDomainId)) %>%
    filter(targetDomainId == mondo_id)
}

#' @export
genes_to_proteins <- function(genes){
  gene_dict$uniprot[gene_dict$Genes %in% genes]
}

#' @export
drug_targets <- function(drug_id){
  all_edges %>% filter(type == "DrugHasTarget") %>%
    filter(sourceDomainId %in% drug_id)
}

#' @export
n_drug_targets <- function(drug_id){
  drug_targets(drug_id) %>%
    nrow()

}
#' @export
get_all_drugs <- function(proteins){
  all_edges %>% filter(type == "DrugHasTarget") %>%
    filter(targetDomainId  %in% proteins)
}

#' @export
get_all_indications <- function(drugbank_id){
  all_edges %>% filter(type == "DrugHasIndication") %>%
    filter(sourceDomainId  %in% drugbank_id)
}

#' @export
get_drugs <- function(genes, pval_cutoff = 0.05){
  genes_to_proteins(genes) %>%
    get_all_drugs() %>%
    count(sourceDomainId) %>%
    as_tibble() %>%
    rowwise() %>%
    mutate(n_total = n_drug_targets(sourceDomainId)) %>%
    mutate(n_proteins = length(na.omit(genes_to_proteins(genes)))) %>%
    mutate(total_proteins = length(na.omit(gene_dict$uniprot))) %>%
    rowwise %>%
    mutate(pval = fisher_test(n, n_total, n_proteins, total_proteins)) %>%
    filter(pval < pval_cutoff) %>%
    arrange(pval) %>%
    left_join(., drugbank, by = c("sourceDomainId" = "name"))
}
#' @export
fisher_test <- function(n11, n12, n21, n22){
  a11 <- n11
  a12 <- n12 - n11
  a21 <- n21 - n11
  a22 <- n22 - a11 - a12 - a21

  fisher_vals <- matrix(c(a11, a21, a12, a22), 2)

  fisher.test(fisher_vals, alternative = "g")$p.value
}
