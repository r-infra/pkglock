# returned package lists from the resolution will be either a vector 
# or character(0), however description logic is checking for NULL, 
# so this converts character(0) to null
maybe_pkgs <- function(.pkgs) {
  if (!length(.pkgs)) {
    return(NULL)
  }
  return(.pkgs)
}

#' Wrapper function to help generate a packrat lockfile
#'
#' @param ...      the arguments to pass to gen_runtime_description
#' @param .workdir directory to pass to install_from_desc
#' @export
gen_packrat_lockfile <- function(..., .workdir = file.path( getwd(),"work")){
  
  runtime_desc <- pkglock::gen_runtime_description(...)
  install <- pkglock::install_from_desc(runtime_desc, .dir = .workdir)
  lockfile <- install$snapshot$lockfile
  
  return (lockfile)
}

#' Build a string suitable for pasting into source code for passing to gen_runtime_description
#'     This is meant to help kickstart a new source file that will be checked into source control
#'     so that you can have a starter list.
#'     
#'     Caveate: this will essentially make all installed packages top-level citizens when calling 
#'     install.packages(dependencies=c("Depends", "Imports", "LinkingTo", "Suggests"))
#'               
#' @param .libdir the library directory to scan
#' @export
#' @importFrom utils installed.packages
gen_pkg_desc_from_libdir <- function(.libdir, .addversion=FALSE){
  out <- ''

  pkglist <- utils::installed.packages(lib.loc = .libdir)
  add <- FALSE
  for( row in 1:nrow(pkglist)){
    out <- sprintf(
      "%s%s'%s%s'",
      out,
      if(add) ",\n\t  " else "",
      pkglist[row,'Package'],
      if(.addversion) paste0(" (==",pkglist[row,'Version'],")") else ""
    )
    add <- TRUE
  }
  
  return (paste0("pkgs <- c(",out,")"))
}


`%||%` <- function(a, b) {
  if (!is.null(a)) a else b
}