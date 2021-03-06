#!/usr/bin/env Rscript

###################################
# Create NGCHM_inferCNV S4 object #
###################################
#' NGCHM_inferCNV class
#' 
#' @exportClass NGCHM_inferCNV
#' @name NGCHM_inferCNV-class
#' @rdname NGCHM_inferCNV-class
#' 
#' @description Object that is used for the creation of a highly interactive heat maps for single cell 
#' expression data using Next Generation Clustered Heat Map (NG-CHM)
#' 
#' @slot args (list) The arguments given to the function.
#' @slot low_threshold (integer) Values for minimum threshold for heatmap coloring. 
#' @slot high_threshold (integer) Values for maximum threshold for heatmap coloring. 
#' @slot reference_cells (character) Vector of reference cell ID's 
#' @slot reference_groups (character) Vector of reference cell group ID's 
#' 
#' @return Returns a NGCHM_inferCNV_obj
#' @export 
#' 
## build off of the present S4 object inferCNV_obj to add more slots 
NGCHM_inferCNV <- methods::setClass("NGCHM_inferCNV", slots = c( args           = "list",
                                                        low_threshold  = "numeric",
                                                        high_threshold = "numeric",
                                                        reference_cells = "ANY",
                                                        reference_groups = "ANY"),#"character"),
                                    contains = "infercnv")


#############
# Accessors #
#############

#' Access the values for low_threshold
#' 
#' This function returns the list of values in low_threshold
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return low_threshold.
#'
#' @rdname lowThreshold-method
#' @keywords internal
#' @noRd
setGeneric(name = "lowThreshold", 
           def = function(obj) standardGeneric("lowThreshold"))
#' @rdname lowThreshold-method
#' @aliases lowThreshold
#' @noRd
setMethod(f = "lowThreshold", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@low_threshold)


#' Access the values for high_threshold
#' 
#' This function returns the list of values in high_threshold
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return high_threshold.
#'
#' @rdname highThreshold-method
#' @keywords internal 
#' @noRd
setGeneric(name = "highThreshold", 
           def = function(obj) standardGeneric("highThreshold"))

#' @rdname highThreshold-method
#' @aliases highThreshold
#' @noRd
setMethod(f = "highThreshold", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@high_threshold)

#' Access the values for x.center
#' 
#' This function returns the list of values in x.center
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return x.center.
#'
#' @rdname getCenter-method
#' @keywords internal
#' @noRd
setGeneric(name = "getCenter", 
           def = function(obj) standardGeneric("getCenter"))

#' @rdname getCenter-method
#' @aliases getCenter
#' @noRd
setMethod(f = "getCenter", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@args$x.center)

#' Access the values for exp.data
#' 
#' This function returns exp.data
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return exp.data
#'
#' @rdname getExpData-method
#' @keywords internal
#' @noRd
setGeneric(name = "getExpData", 
           def = function(obj) standardGeneric("getExpData"))

#' @rdname getExpData-method
#' @aliases getExpData
#' @noRd
setMethod(f = "getExpData", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@expr.data)

#' Access the NGCHM title
#' 
#' This function returns the NGCHM title
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return title.
#'
#' @rdname getTitle-method
#' @keywords internal
#' @noRd
setGeneric(name = "getTitle", 
           def = function(obj) standardGeneric("getTitle"))

#' @rdname getTitle-method
#' @aliases getTitle
#' @noRd
setMethod(f = "getTitle", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@args$title)



#' Access the Observed indices 
#' 
#' This function returns a list of the observed cell indices expression data 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return list containing observed indices.
#'
#' @rdname getObserved-method
#' @keywords internal 
#' @noRd
setGeneric(name = "getObserved", 
           def = function(obj) standardGeneric("getObserved"))

#' @rdname getObserved-method
#' @aliases getObserved
#' @noRd
setMethod(f = "getObserved", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@observation_grouped_cell_indices)

#' Access gene order from object
#' 
#' This function returns the table of genes and their locations
#' @param obj The NGCHM_inferCNV_obj S4 object.
#'
#' @return gene_order.
#'
#' @rdname getGeneData-method
#' @keywords internal
#' @noRd
setGeneric(name = "getGeneData", 
           def = function(obj) standardGeneric("getGeneData"))

#' @rdname getGeneData-method
#' @aliases getGeneData
#' @noRd
setMethod(f = "getGeneData", 
          signature = "NGCHM_inferCNV", 
          definition=function(obj) obj@gene_order)



################################################
# NGCHM and NGCHM_infercnv Object Manipulation #
################################################

#' @title get_average_bounds()
#'
#' @description Computes the mean of the upper and lower bound for the data across all cells.
#'
#' @param infercnv_obj infercnv_object
#'
#' @return (lower_bound, upper_bound)
#'
#' @keywords internal
#' @noRd
#'

get_average_bounds <- function (infercnv_obj) { return(.get_average_bounds(infercnv_obj@expr.data)) }

#' @keywords internal
#' @noRd

.get_average_bounds <- function(expr_matrix) {
    
    lower_bound <- mean(apply(expr_matrix, 2,
                              function(x) quantile(x, na.rm=TRUE)[[1]]))
    upper_bound <- mean(apply(expr_matrix, 2,
                              function(x) quantile(x, na.rm=TRUE)[[5]]))
    
    return(c(lower_bound, upper_bound))
}


#' Initialize the NGCHM_inferCNV_obj object 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param args_parsed The arguments given to the function.
#' @param infercnv_obj InferCNV object.
#' 
#' @return obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @rdname initializeNGCHMObject-method
#' @keywords internal
#' @noRd
setGeneric(name="initializeNGCHMObject",
           def=function(obj, args_parsed, infercnv_obj)
           { standardGeneric("initializeNGCHMObject") }
)

#' @rdname initializeNGCHMObject-method
#' @aliases initializeNGCHMObject
#' @noRd
setMethod(f="initializeNGCHMObject",
          signature="NGCHM_inferCNV",
          definition=function(obj, args_parsed, infercnv_obj)
          {
              futile.logger::flog.info(paste("Initializing new NGCHM InferCNV Object."))
              
              # Validate the inferCNV Object 
              # infercnv:::validate_infercnv_obj(infercnv_obj)
              
              ## create the S4 object
              obj <- NGCHM_inferCNV(infercnv_obj)
              ## add arguments 
              obj@args <- args_parsed
              
              # transpose the expression data so columns are the cell lines and rows are genes 
              obj@expr.data <- t(obj@expr.data)
              # create color map for the heat map and save it as a new data layer 
              # if specific center value is not given, set to 1 
              if (any(is.na(obj@args$x.center))) {
                  obj@args$x.center <- 1
              }
              # if the range values are not given, will set appropriate values 
              if (! any(is.na(obj@args$x.range))) {
                  ## if the range values are provided, use defined values
                  obj@low_threshold <- obj@args$x.range[1]
                  obj@high_threshold  <- obj@args$x.range[2]
                  if (obj@low_threshold > obj@args$x.center | obj@high_threshold < obj@args$x.center | obj@low_threshold >= obj@high_threshold) {
                      obj@args$x.center <- 0
                      if (obj@low_threshold > obj@args$x.center | obj@high_threshold < obj@args$x.center | obj@low_threshold >= obj@high_threshold) {
                          stop(paste("Error, problem with relative values of x.range: ", obj@args$x.range, ", and x.center: ", obj@args$x.center))
                      }
                  }
              } else {
                  ## else, if not given, set the values 
                  bounds <- get_average_bounds(obj)
                  obj@low_threshold <- as.numeric(bounds[1])
                  obj@high_threshold <- as.numeric(bounds[2])
              }
              
              # Give the heatmap a title if one is not given
              if (is.null(obj@args$title)){
                  obj@args$title <- "inferCNV"
              }
              
              ## set variables 
              ref_index = unlist(obj@reference_grouped_cell_indices)
              #reference_idx = row.names(obj@expr.data[unlist(ref_index),])
              obj@reference_cells <- row.names(obj@expr.data[ref_index,])
              # ref_groups = names(ref_index)
              obj@reference_groups <- names(ref_index)
              
              return(obj)
          }
)



#' Initialize the NGCHM object 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setNGCHMObject-method
#' @keywords internal
#' @noRd
setGeneric(name="setNGCHMObject",
           def=function(obj, hm)
           { standardGeneric("setNGCHMObject") }
)

#' @rdname setNGCHMObject-method
#' @aliases setNGCHMObject
#' @noRd
setMethod(f="setNGCHMObject",
          signature="NGCHM_inferCNV",
          definition=function(obj, hm)
          {
              # set the column (gene) order 
              hm@colOrder <- colnames(obj@expr.data)
              hm@colOrderMethod <- "User"  
              
              # add linkouts to each gene (column) for more information 
              if (!is.null(obj@args$gene_symbol)) {
                  hm <- NGCHM::chmAddAxisType(hm, 'col', obj@args$gene_symbol)
              }
            return(hm)
          }
)


#' Import the row groupings 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @return table containing the grouping of the rows 
#' 
#' @rdname getRowGrouping-method
#' @keywords internal
#' @noRd
setGeneric(name="getRowGrouping",
           def=function(obj)
           { standardGeneric("getRowGrouping") }
)

#' @rdname getRowGrouping-method
#' @aliases getRowGrouping
#' @noRd
setMethod(f="getRowGrouping",
          signature="NGCHM_inferCNV",
          definition=function(obj)
          {
              # read the file containing the groupings created by infer_cnv
              row_groups_path <- paste(obj@args$out_dir, "infercnv.observation_groupings.txt", sep=.Platform$file.sep)
              row_groups <- read.table(row_groups_path, header = TRUE, check.names = FALSE) # genes are the row names 
              
              return(row_groups)
          }
)



#' Set the Dendrograms and rows 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setRows-method
#' @keywords internal
#' @noRd
setGeneric(name="setRows",
           def=function(obj, hm)
           { standardGeneric("setRows") }
)

#' @rdname setRows-method
#' @aliases setRows
#' @noRd
setMethod(f="setRows",
          signature="NGCHM_inferCNV",
          definition=function(obj, hm)
          {
              
              # ---------------------- Import Dendrogram & Order Rows -----------------------------------------------------------------------------------
              # IF Cluster By Group is set to TRUE:
              # Get the order of the rows (cell lines) from the dendrogram created by infer_cnv 
              row_groups <- getRowGrouping(obj)
              
              obs_order <- rev(row.names(row_groups)) # Reveerse names to correct order 
              if(!is.null(obj@reference_cells)){
                  row_order <- c(as.vector(obj@reference_cells), obs_order) # put the reference cells above the observed cells 
              }else{
                  row_order <- obs_order
              }
              ## check for correct dimensions of new row order 
              if (length(row_order) != nrow(obj@expr.data)) {
                  stop("Error: After ordering the rows, row length does not match original dimensions of the data.
                       \n Difference in row length: Original ", nrow(obj@expr.data), ", After ordering ", length(row_order))
              }
              # # check to make sure all cell lines are included 
              if (!(all(obs_order %in% row_order))) {
                  missing_ids <- row_groups[which(!(obs_order %in% row_order))]
                  error_message <- paste("Groupings of cell line ID's in observation_groupings.txt \n",
                                         "do not match the ID's in the expression data.\n",
                                         "Check the following cell line ID's: ",
                                         paste(missing_ids, collapse = ","))
              }
              ## set the row order for the heatmap
              hm@rowOrder <- row_order
              hm@rowOrderMethod <- "User"
              return(hm)
              }
)



#' Get the unique contigs in the correct order
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname getUniqueChr-method
#' @keywords internal
#' @noRd
setGeneric(name="getUniqueChr",
           def=function(obj)
           { standardGeneric("getUniqueChr") }
)

#' @rdname getUniqueChr-method
#' @aliases getUniqueChr
#' @noRd
setMethod(f="getUniqueChr",
          signature="NGCHM_inferCNV",
          definition=function(obj)
          {
              return( unique(obj@gene_order[['chr']]) )
          }
)

#' Get all the contigs in the correct order
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname getChr-method
#' @keywords internal
#' @noRd
setGeneric(name="getChr",
           def=function(obj)
           { standardGeneric("getChr") }
)

#' @rdname getChr-method
#' @aliases getChr
#' @noRd
setMethod(f="getChr",
          signature="NGCHM_inferCNV",
          definition=function(obj)
          {
              return( obj@gene_order[['chr']] )
          }
)

#' Get the gene names
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @return Gene Locations
#' 
#' @rdname getGenes-method
#' @keywords internal
#' @noRd
setGeneric(name="getGenes",
           def=function(obj)
           { standardGeneric("getGenes") }
)

#' @rdname getGenes-method
#' @aliases getGenes
#' @noRd
setMethod(f="getGenes",
          signature="NGCHM_inferCNV",
          definition=function(obj)
          {
              ## get gene locations in correct order, then find frequency of each chromosome
              ## add locations to each gene 
              location_data <- getGeneData(obj)
              location_data$Gene <- row.names(obj@gene_order)
              gene_order = colnames(obj@expr.data)
              gene_locations_merge <- merge(data.frame(Gene = colnames(obj@expr.data), stringsAsFactors = FALSE), location_data, by.x = "Gene")
              gene_locations <- gene_locations_merge[match(gene_order,gene_locations_merge$Gene),]
              
              return( gene_locations )
          }
)


#' Set color map for heatmap 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' 
#' @return layer: color mapping object used for NGCHM heatmap generation
#' 
#' @rdname setColors-method
#' @keywords internal
#' @noRd
setGeneric(name="setColors",
           def=function(obj)
           { standardGeneric("setColors") }
)

#' @rdname setColors-method
#' @aliases setColors
#' @noRd
setMethod(f="setColors",
          signature="NGCHM_inferCNV",
          definition=function(obj)
          {
              # Create color mapping for 
              colMap <- NGCHM::chmNewColorMap(values        = c(lowThreshold(obj), getCenter(obj), highThreshold(obj)),
                                              colors        = c("darkblue","white","darkred"),
                                              missing.color = "white", 
                                              type          = "linear") 
              layer <- NGCHM::chmNewDataLayer("DATA", as.matrix(getExpData(obj)), colMap, summarizationMethod = "average")
              
              return(layer)
          }
)


#' Set the divisions in the heatmap 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setDivisions-method
#' @keywords internal
#' @noRd
setGeneric(name="setDivisions",
           def=function(obj, hm)
           { standardGeneric("setDivisions") }
)

#' @rdname setDivisions-method
#' @aliases setDivisions
#' @noRd
setMethod(f="setDivisions",
          signature="NGCHM_inferCNV",
          definition=function(obj, hm)
          {
              # ----------------------Add Divisions Between References And Chromosomes ------------------------------------------------------------------
              # Column Separation: separation between the chromosomes 
              
              ## get the correct order of the chromosomes
              ordering <- getUniqueChr(obj)
              ## get gene locations in correct order, then find frequency of each chromosome
              ## add locations to each gene 
              gene_locations <- getGenes(obj)
              # 
              # ## check if the number of genes has changed 
              if (nrow(gene_locations) != length(colnames(obj@expr.data))){
                  warning(paste0("Number of similar genes between expression data and locations:", nrow(gene_locations),
                                 "\n Total number of genes in expression data: ", length(colnames(obj@expr.data)),
                                 "\n Check to make sure all the genes are in the location file and the gene names are the same between files."))
              }
              ## put in order 
              ordered_locations <- table(gene_locations[['chr']])[ordering] 
              cumulative_len <- cumsum(ordered_locations) #cumulative sum, separation locations
              sep_col_idx <- cumulative_len[-1 * length(cumulative_len)] # drop the last index because we do not want to add a break at the very end
              sep_col_idx <- rep(1,length(sep_col_idx)) + sep_col_idx # add one to each index, want to be to the right of the last gene in that chr
              ## colCutLocations: locations where the cuts will occur 
              ## colCutWidth: the width of the cuts 
              hm@colCutLocations <- as.integer(sep_col_idx)
              hm@colCutWidth <- as.integer(30)
              
              # Row separation: separation between reference samples and observed samples 
              hm@rowCutLocations <- as.integer(length(row.names(obj@expr.data[unlist(obj@reference_grouped_cell_indices),]))+1)
              # make the size of the separation proportional to the size of the heat map 
              ## use ncol because obj@expr.data has cell ID's as the columns 
              row_sep <- ceiling(nrow(obj@expr.data)*.01)
              hm@rowCutWidth <- as.integer(row_sep)
              return(hm)
          }
)


#' Set Covariate bar for reference and observed groups 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setColCovariateBar-method
#' @keywords internal
#' @noRd
setGeneric(name="setColCovariateBar",
           def=function(obj, hm)
           { standardGeneric("setColCovariateBar") }
)

#' @rdname setColCovariateBar-method
#' @aliases setColCovariateBar
#' @noRd
setMethod(f="setColCovariateBar",
          signature="NGCHM_inferCNV",
          definition=function(obj, hm)
          {
              # Returns the color palette for contigs.
              get_group_color_palette <- function(){
                  return(colorRampPalette(RColorBrewer::brewer.pal(12,"Set3")))
              }
              # map the genes to their chromosome 
              ## gene_locations: created earlier, Genes and their locations 
              chr_labels <- as.vector(getUniqueChr(obj)) # as vector removes the levels
              ## get the chromosomes 
              chr <- as.character(getChr(obj))
              ## get the gene ID's 
              names(chr) <- getGenes(obj)$Gene
              
              chr_palette <- get_group_color_palette()(length(chr_labels))
              names(chr_palette) <- getUniqueChr(obj)
              
              ## create color mapping
              colMap_chr <- NGCHM::chmNewColorMap(values        = as.vector(chr_labels),
                                                  colors        = chr_palette,
                                                  missing.color = "white")
              chr_cov <- NGCHM::chmNewCovariate(fullname        = 'Chromosome', 
                                                values           = chr, 
                                                value.properties = colMap_chr,
                                                type             = "discrete")
              hm <- NGCHM::chmAddCovariateBar(hm, "column", chr_cov, 
                                              display   = "visible", 
                                              thickness = as.integer(20))
              return(hm)
          }
)


#' Set Covariate bar for reference and observed groups 
#' 
#' @param obj The NGCHM_inferCNV_obj S4 object.
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setRowCovariateBar-method
#' @keywords internal
#' @noRd
setGeneric(name="setRowCovariateBar",
           def=function(obj, hm)
           { standardGeneric("setRowCovariateBar") }
)

#' @rdname setRowCovariateBar-method
#' @aliases setRowCovariateBar
#' @noRd
setMethod(f="setRowCovariateBar",
          signature="NGCHM_inferCNV",
          definition=function(obj, hm)
          {
              # Returns the color palette for contigs.
              get_group_color_palette <- function(){
                  return(colorRampPalette(RColorBrewer::brewer.pal(12,"Set3")))
              }
              # get the row grouping information 
              row_groups <- getRowGrouping(obj)
              colnames(row_groups) <- c("Dendrogram.Group", "Dendrogram.Color", "Annotation.Group", "Annotation.Color")
              
              ###############################
              # Dendrogram: create the dendrogram bar label 
              # create covariate bar from dendrogram groups
              ## row_groups is taken from the dendrogram created by inferCNV
              ## create better column names 
              dendrogram_col <- as.character(unlist(row_groups["Dendrogram.Color"]))# group colors
              dendrogram_group <- as.character(unlist(row_groups["Dendrogram.Group"]))# group number
              dendrogram_unique_group <- unique(dendrogram_group)
              cells <- row.names(row_groups) # cell line ID's
              names(dendrogram_col) <- cells
              names(dendrogram_group) <- cells
              dendrogram_palette <- get_group_color_palette()(length(unique(dendrogram_col)))
              
              ## create color mapping
              colMap_dendrogram <- NGCHM::chmNewColorMap(values        = as.vector(dendrogram_unique_group),
                                                         colors        = dendrogram_palette,
                                                         missing.color = "white")
              dendrogram_cov <- NGCHM::chmNewCovariate(fullname         = 'Dendrogram',
                                                       values           = dendrogram_group,
                                                       value.properties = colMap_dendrogram,
                                                       type             = "discrete")
              hm <- NGCHM::chmAddCovariateBar(hm, "row", dendrogram_cov,
                                              display   = "visible",
                                              thickness = as.integer(20))
              
              ###############################
              # Create Reference and Observed covariance bars 
              # Covariate to identify Reference and Observed data
              annotation_col <- as.character(unlist(row_groups["Annotation.Color"])) # group colors
              annotation_group <- as.character(unlist(row_groups["Annotation.Group"]))# group number
              names(annotation_group) <- cells
              names(annotation_col) <- cells
              # annotation_unique_group <- unique(annotation_group)
              
              #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              # REFERENCE: Create the labels for the reference bar
              ref_bar_labels = unname(unlist(obj@reference_grouped_cell_indices))
              dummy = sapply(names(obj@reference_grouped_cell_indices), function(x){ # ref_bar_labels[ unlist(obj@reference_grouped_cell_indices[x])] <<- x })
                                                                                            temp_id <- which( ref_bar_labels %in% unlist(obj@reference_grouped_cell_indices[x]) ) 
                                                                                            ref_bar_labels[ temp_id ] <<- x })
              # Add the reference cell names
              names(ref_bar_labels) <- obj@reference_cells

              # if you want the exact coloring as the original inferCNV plots
              #annotation_palette <- c(get_group_color_palette()(length(obj@reference_grouped_cell_indices)), get_group_color_palette()(length(annotation_unique_group))
              
              #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              # OBSERVED: create labels for the Observed bar
              obs_bar_labels = unname(unlist(obj@observation_grouped_cell_indices))
              dummy = sapply(names(obj@observation_grouped_cell_indices), function(x){ # ref_bar_labels[ unlist(obj@reference_grouped_cell_indices[x])] <<- x })
                                                                                          temp_id <- which( obs_bar_labels %in% unlist(obj@observation_grouped_cell_indices[x]) ) 
                                                                                          obs_bar_labels[ temp_id ] <<- x })
              # set the sample names 
              names(obs_bar_labels) <- row.names(row_groups)
              
              # combine reference and observed labels
              annotation_group <- c(ref_bar_labels,obs_bar_labels)
              
              #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              # OBSERVED: create labels for the Observed bar
              
              unique_group <- unique(annotation_group)
              annotation_palette <- get_group_color_palette()(length(unique_group))
              
              # check if all reference cells are included 
              if (!(all(obj@reference_cells %in% names(annotation_group)))){
                  missing_refs <- obj@reference_cells[which(!(obj@reference_cells %in% names(annotation_group)))]
                  error_message <- paste("Error: Not all references are accounted for.",
                                         "Make sure the reference names match the names in the data.\n",
                                         "Check the following reference cell lines: ", 
                                         paste(missing_refs, collapse = ","))
                  stop(error_message)
              }
              # check if all observed cells are included
              observed_idx <- row.names(obj@expr.data[unlist(obj@observation_grouped_cell_indices),])
              if (!(all(observed_idx %in% names(annotation_group)))){
                  missing_obs <- obj@reference_cells[which(!(observed_idx %in% names(annotation_group)))]
                  error_message <- paste("Error: Not all observed cell lines are accounted for.",
                                         "Make sure the reference names match the names in the data.\n",
                                         "Check the following reference cell lines: ", 
                                         paste(missing_obs, collapse = ","))
                  stop(error_message)
              }
              
              ## create color mapping
              colMap_annotation <- NGCHM::chmNewColorMap(values        = as.vector(unique_group), 
                                                         colors        = annotation_palette,
                                                         missing.color = "white")
              
              annotation_cov <- NGCHM::chmNewCovariate(fullname         = 'Annotation', 
                                                       values           = annotation_group, 
                                                       value.properties = colMap_annotation,
                                                       type             = "discrete")
              hm <- NGCHM::chmAddCovariateBar(hm, "row", annotation_cov, 
                                              display   = "visible", 
                                              thickness = as.integer(20))
              return(hm)  
          }
)


#' Set the initial coloring for the cuts (contig and observed/reference divisions)
#' 
#' @param hm NGCHM object
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setCutsColor-method
#' @keywords internal
#' @noRd
setGeneric(name="setCutsColor",
           def=function(hm)
           { standardGeneric("setCutsColor") }
)

#' @rdname setCutsColor-method
#' @aliases setCutsColor
#' @noRd
setMethod(f="setCutsColor",
          signature="ngchmVersion2",
          definition=function(hm)
          {
              hm@colTreeCuts <- as.integer(2)
              
              hm@layers[[1]]@cuts_color <- "#646464"
              
              return(hm)
          }
)

#' Option to set the label display size 
#' 
#' @param hm NGCHM object
#' @param size Size to use for the labels. 
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setLabelSize-method
#' @keywords internal
#' @noRd
setGeneric(name="setLabelSize",
           def=function(hm, size)
           { standardGeneric("setLabelSize") }
)

#' @rdname setLabelSize-method
#' @aliases setLabelSize
#' @noRd
setMethod(f="setLabelSize",
          signature="ngchmVersion2",
          definition=function(hm, size)
          {
              ## adjust label display size 
              hm@rowDisplayLength <- as.integer(size)
              return(hm)
          }
)

#' Option to adjust the size of the heat map.
#' 
#' @param hm NGCHM object
#' @param width Width of the heatmap
#' @param hight Hight of the heatmap
#' 
#' @return hm: The NGCHM S4 object.
#' 
#' @rdname setHeatMapSize-method
#' @keywords internal
#' @noRd
setGeneric(name="setHeatMapSize",
           def=function(hm, width, hight)
           { standardGeneric("setHeatMapSize") }
)

#' @rdname setHeatMapSize-method
#' @aliases setHeatMapSize
#' @noRd
setMethod(f="setHeatMapSize",
          signature="ngchmVersion2",
          definition=function(hm, width, hight)
          {
              ## adjust the width and hight of the heat map 
              hm@width <- as.integer(width)
              hm@height <- as.integer(hight)
              return(hm)
          }
)

#################
# Main Function #
#################

#' @title Create Next Generation Clustered Heat Map (NG-CHM)
#' @description  Create highly interactive heat maps for single cell expression data using 
#' Next Generation Clustered Heat Map (NG-CHM). NG-CHM was developed and 
#' maintained by MD Anderson Department of Bioinformatics and Computational 
#' Biology in collaboration with In Silico Solutions. 
#'
#' @param infercnv_obj (S4) InferCNV S4 object holding expression data, gene location data, annotation information.
#' @param path_to_shaidyMapGen (string) Path to the java application ShaidyMapGen.jar
#' @param out_dir (string) Path to where the infercnv.ngchm output file should be saved to 
#' @param title (string) Title that will be used for the heatmap 
#' @param gene_symbol (string) Specify the label type that is given to the gene needed to create linkouts, default is NULL
#' @param x.center (integer) Center expression value for heatmap coloring.
#' @param x.range (integer) Values for minimum and maximum thresholds for heatmap coloring. 
#'
#' @return a NGCHM file named infercnv.ngchm and saves it to the output directory given to infercnv. 
#' 
#' @export
#' 



Create_NGCHM <- function(infercnv_obj,
                         path_to_shaidyMapGen,
                         out_dir,
                         title = NULL, 
                         gene_symbol = NULL,
                         x.center = NA,
                         x.range = NA) {
    
    # ----------------------Check/create Pathways-----------------------------------------------------------------------------------------------
    ## check out_dir
    if (file.exists(out_dir)){
        file_path <- paste(out_dir, "infercnv.ngchm", sep = .Platform$file.sep)
    }else{
        dir.create(file.path(out_dir))
        paste("Creating the following Directory: ", out_dir)
    }
    
    args_parsed <- list("path_to_shaidyMapGen" = path_to_shaidyMapGen,
                        "out_dir"              = out_dir,
                        "title"                = title, 
                        "gene_symbol"          = gene_symbol,
                        "x.center"             = x.center,
                        "x.range"              = x.range)
    
    #----------------------Initialize Next Generation Clustered Heat Map------------------------------------------------------------------
    
    ## create the S4 object
    NGCHM_inferCNV_obj <- methods::new("NGCHM_inferCNV")
    NGCHM_inferCNV_obj <- initializeNGCHMObject(NGCHM_inferCNV_obj, 
                                                args_parsed,
                                                infercnv_obj)
    # create color mapping for heatmap 
    layer <- setColors(NGCHM_inferCNV_obj)
    # create and initialize the NGCHM object
    hm <- NGCHM::chmNew(getTitle(NGCHM_inferCNV_obj), layer)
    hm <- setNGCHMObject(NGCHM_inferCNV_obj,hm)
    # ---------------------- Import Dendrogram & Order Rows -----------------------------------------------------------------------------------
    hm <- setRows(NGCHM_inferCNV_obj, hm)
    
    
    
    # ----------------------Add Divisions Between References And Chromosomes ------------------------------------------------------------------
    hm <- setDivisions(NGCHM_inferCNV_obj, hm)
    
    #----------------------Create Covariate Bars----------------------------------------------------------------------------------------------------------------------------------------
    
    # COLUMN Covariate bar
    hm <- setColCovariateBar(NGCHM_inferCNV_obj,hm)
    
    # ROW Covariate bar
    hm <- setRowCovariateBar(NGCHM_inferCNV_obj, hm)
    
    #----------------------Cuts Coloring----------------------------------------------------------------------------------------------------------------------------------------
    # Set the coloring for the cuts 
    hm <- setCutsColor(hm)
    
    #---------------------------------------Export the heat map-----------------------------------------------------------------------------------------------------------------------
    ## adjust the size of the heat map 
    # hm <- setHeatMapSize(hm, width=500, hight=500)
    
    # Option to set the label display size 
    # hm  <- setLabelSize(hm, size=10)
    
    futile.logger::flog.info(paste("Saving new NGCHM object"))
    NGCHM::chmExportToFile(hm, file_path, overwrite = TRUE, shaidyMapGen = path_to_shaidyMapGen)
}

