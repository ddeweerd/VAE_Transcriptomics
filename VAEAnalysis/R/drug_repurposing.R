#'@export
get_drug_info <- function(genes){
  drug_genes <- genes[genes %in% unique(node$geneName)]

  cur_nodes <- node[node$geneName %in% drug_genes, ]
  mapper <- edge_table[edge_table$targetDomainId %in% cur_nodes$domainIds, ]

  combined <- left_join(x = mapper, y = node,  by = c("sourceDomainId" = "primaryDomainId"))

  return(list(drug_genes = drug_genes,
              nodes = cur_nodes,
              edges = mapper,
              combined = combined))
}


#' @export
prepare_igraph <- function(drug_genes, combined){
  gene_network <- string_db$get_subnetwork(proteinnames[genenames %in% drug_genes])
  V(gene_network)$name <- genenames[proteinnames %in% V(gene_network)$name]
  edge_list_genes <- as_long_data_frame(gene_network)
  all_info <- left_join(combined, node, by = c("targetDomainId" = "domainIds") )
  drug_gene_interaction <- data.frame("interactor1" = all_info$displayName.x, "interactor2" = all_info$geneName.y)
  gene_gene_interaction <- data.frame("interactor1" = edge_list_genes[,4], "interactor2" = edge_list_genes[,5])
  complete_edge_list <- rbind(drug_gene_interaction, gene_gene_interaction)
  drug_gene_network <- graph_from_edgelist(as.matrix(complete_edge_list))
  annotation <- sapply(V(drug_gene_network)$name, function(x)ifelse(x %in% drug_gene_interaction$interactor1, yes = "Drug", no = "Gene"))
  vertex_attr(graph = drug_gene_network, name = "type", index = V(drug_gene_network)) <- annotation

  return(drug_gene_network)
}
