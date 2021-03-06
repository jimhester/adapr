#' Run an R script within a project using devtools::clean_source
#' @param r R script within that project (r is short R script for convenience)
#' @param project.id project id
#' @param logRmd logical indicating whether to create R markdown log
#' @aliases {run.program}
#' @return value from clean_source from devtools package
#' @details Lists scripts if no current script is active or r script is "".
#' @export
#'@examples 
#'\dontrun{
#' run.program("read_data.R","adaprHome")
#'} 
#' 
runScript <- function(r=getSourceInfo()$file$file,project.id=getProject(),logRmd=FALSE){
  
  
  r <- ifelse((length(r)==0),"",r)
  
  if((r=="")){
    
    files <- list.files(file.path(getProjectPath(getProject()),"Programs"))
    
    files <- grep("\\.R",files,value=TRUE)
    
    df <- listScripts()
    df <- df[order(df$source.file),]
    print(df)
    
    n <- as.integer(readline("Which script?"))
    
    if(!(n %in% 1:length(files))){n <- 1}
    
    r <- df$source.file[n]
    
  }
  
  
  source.file <- r
  
  scriptfile <- file.path(getProjectPath(project.id),project.directory.tree$analysis,source.file)
  
  # get project object
  if(!logRmd){
    out <- devtools::clean_source(scriptfile)
  }else{
    
    results <- file.path(getProjectPath(project.id),project.directory.tree$results,source.file)
    
    dir.create(results,showWarnings=FALSE)
    
    program <- scan(scriptfile,what=character(),sep="\n")
    
    program <- c("```{r}\n\n",paste("\n\n #adapr Run: \n Sys.time() \n\n"),program,"\n\n #adapr Stop: \n Sys.time() \n\n```")
    
    dbname <- gsub("\\.","_",make.names(source.file))
    
    tempmkdown <- file.path(results,paste0(dbname,"_adapr_results_log.Rmd"))
    executor <- file.path(results,"adapr_render.R")
  
    temphtml <- file.path(results,paste0(dbname,"_adapr_results_log.html"))
    
    dependency.file <- file.path(getProjectPath(project.id),project.directory.tree$dependency.dir,
                                 paste0(source.file,".txt"))
    
    write(program,tempmkdown)
    
    olddir <- getwd()
    
    setwd(results)
    
    filetest <- paste0("\ntest <- file.exists(\"",temphtml,"\")\n")
    
    renderstatement <- paste0("library(markdown)\n setwd(\"",results,"\")","\nrmarkdown::render(\"",tempmkdown,"\")",filetest,"\n if(!test){stop()}")
    
    write(renderstatement,executor)
    
    out <- devtools::clean_source(executor)
    
    depout <- read.dependency(dependency.file)
    
    outline <- depout[nrow(depout),]
    outline$target.path <- file.path(project.directory.tree$results,source.file)
    outline$target.file <- basename(temphtml)
    outline$dependency <- "out"
    outline$target.description <- "R script log in rmarkdown"
    outline$target.hash <- Digest(file=temphtml)
    outline$target.mod.time <- as.character(file.info(temphtml)$mtime)
    
    depout <- rbind(depout,outline)
    
    file.remove(c(tempmkdown,executor))
    
    write.dependency(depout,dependency.file)
    
    setwd(olddir)
    
  }
  
  
  return(out)
}


#' Remove an R script from a project. Removes program, dependency, and results.
#' @param source.file R script within that project
#' @param project.id project id
#' @param ask is a logical whether to ask user
#' @return value from file.remove
#' @details Cannot be undone through adapr! Will not remove markdown or other program side-effects.
#' @export
#' 
#'@examples 
#'\dontrun{
#' remove.program("adaprHome","read_data.R")
#'} 
#' 
#' 
#' 

removeScript <- function(source.file=get("source_info")$file$file,project.id=getProject(),ask=TRUE){
  # get project object
  
  if(ask){
  
  test <- readline("Are you sure you want to remove program & results? y/n")
  
  if(test!="y"){
    
    return(FALSE)
    
  }
  }
  
  
  program <- file.path(getProjectPath(project.id),project.directory.tree$analysis,source.file)
  dependencyDir <- file.path(getProjectPath(project.id),project.directory.tree$dependency.dir,
                paste0(source.file,".txt"))
  results <- file.path(getProjectPath(project.id),project.directory.tree$results,source.file)
  
  markdownfile <- gsub("\\.r$|\\.R","\\.Rmd",source.file)
  markdownfile <- file.path(getProjectPath(project.id),project.directory.tree$analysis,
                            "Markdown",markdownfile)
  inside.results <- list.files(results,full.names=TRUE,recursive = TRUE)
  
  counter <- 0
  
  while((length(inside.results)>0)&(counter < 1000)){
  
  inside.out <- suppressWarnings(file.remove(inside.results))
  
  inside.results <- list.files(results,full.names=TRUE,recursive = TRUE,include.dirs = TRUE)
  
  counter <- counter + 1
  
  }
  
  if(base::dir.exists(results)){results.out <- file.remove(results)}
  
  results <- file.remove(c(program,dependencyDir,markdownfile))
    
  return(c(results,inside.out,results))
}

