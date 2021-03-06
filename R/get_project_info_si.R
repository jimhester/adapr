#' Given source_info object, retrieves project information
#' @param source_info is list with source information
#' @return list with stacked dependency files, graph of dependencies, and condensed file information
#' @export
#'@examples 
#'\dontrun{
#' source_info <- create_source_file_dir("adaprHome","tree_controller.R")
#' getProjectInfoSI(source_info)
#'} 
#' 
getProjectInfoSI <- function(source_info){
  
  # get project object
  
  dependency.dir <- source_info$dependency.dir
  
  trees <- readDependency(dependency.dir)
  
  g.all <- makeSummaryGraph(dependency.dir=NULL,dependency.object=trees,plot.graph=FALSE)
  
  file.info.object <- condenseFileInfo(trees)
  
  return(list("tree"=trees,"graph"=g.all,"all.files"=file.info.object))
  
}
