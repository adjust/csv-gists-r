.GITHUB.HOST <- 'https://api.github.com/gists'
.AUTHORIZATION.HEADER <- 'token %s'

#' Creates new gist on GitHub using the Authentication token found in
#' ~/.gist-vim file. This is compliant with the Vim Gist plugin so if you're
#' already using that one, you'll be set to use the R package too. By default
#' gists created here are private, but this and description could be set. If you
#' give a gist id as argument to the function, it will try to update an existing
#' gist instead of creating a new one.
#'
#' @param public should the gist be made public or secrete on http://gist.github.com
#' @param description the description for the new gist.
#' @param id if left NULL a new gist will be created. If given a gist ID string,
#' an existing gist will be updated.
#' @param csv.writer this takes a function as a value e.g. write.csv or write.csv2. See README.md.
#' @param row.names if this is set to TRUE, then row.names will be written to
#' the output.
#' @param ... additional params passed on to csv.writer function.
#' @param file.name this allows you to name the file in the gist, default value is 'file1.csv'
#' @export
gist.csv <- function(DT, public=FALSE, description='', id=NULL, csv.writer=write.csv, row.names=FALSE, file.name = 'file1.csv', ...) {
  if (! (identical(csv.writer, write.csv) | identical(csv.writer, write.csv2)))
    stop("csv.writer parameter must be function write.csv or write.csv2")

  str <- ''

  tc <- textConnection('str', 'w', local=TRUE)
  csv.writer(DT, file=tc, row.names=row.names, ...)
  close(tc)

  content <-list(content=paste(as.character(str), collapse='\n'))
  file <- list()
  key <- file.name
  file[[key]] <- content

  req <- list(description=description,
              public=public,
              files=file)


  user.token <- read.table("~/.gist-vim", stringsAsFactors=FALSE)$V2[1]
  if (is.null(user.token)) stop('You need a file ~/.gist-vim with structure `token 123123uhksjdfhsdlfj` with your GitHub token')

  resp <- ''

  if (is.null(id)) {
    cat("Creating new gist...\n")
    resp <- POST(url=.GITHUB.HOST,
                 body=req,
                 encode='json',
                 add_headers('Authorization'=sprintf(.AUTHORIZATION.HEADER, user.token)))
  } else {
    cat("Updating gist ID", id, "...\n")
    resp <- PATCH(url=sprintf("%s/%s", .GITHUB.HOST, id),
                 body=req,
                 encode='json',
                 add_headers('Authorization'=sprintf(.AUTHORIZATION.HEADER, user.token)))
  }

  if (status_code(resp) == 201 || status_code(resp) == 200)
    cat(content(resp)$html_url, "\n")
  else
    cat("Error connecting to GitHub:", status_code(resp), "\n")

  return(content(resp))
}
