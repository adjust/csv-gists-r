.GITHUB.HOST <- 'https://api.github.com/gists'
.AUTHORIZATION.HEADER <- 'token %s'

library(data.table)
library(httr)

#' Creates new gist on GitHub using the Authentication token found in
#' ~/.gist-vim file. This is compliant with the Vim Gist plugin so if you're
#' already using that one, you'll be set to use the R package too. By default
#' gists created here are private, but this and description could be set. If you
#' give a gist id as argument to the function, it will try to update an existing
#' gist instead of creating a new one.
#' @export
gist.csv <- function(DT, public=FALSE, description='', id=NULL) {
  str <- ''

  tc <- textConnection('str', 'w', local=TRUE)
  write.csv(DT, file=tc, row.names=FALSE)
  close(tc)

  req <- list(description=description,
              public=public,
              files=list(file1.csv=list(content=paste(as.character(str), collapse='\n'))))

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
