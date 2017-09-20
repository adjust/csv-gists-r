### CSV gists from R objects

In my work I spend a lot of time sharing data with others and I've often been
frustrated when I had to download a data export from an anlytics machine R job
only to upload it to a GitHub gist for sharing. I used the Vim gist plugin for
that, but I wished I could just let the R job do the sharing for me.

Here's the package that does this - and right from an R `data.table` object.

### Installation

You can install this from GitHub using `devtools` by:

```R
library(devtools)
devtools::install_github('adjust/csv-gists-r');
```

Consistent with the Vim gist plugin, this package looks for your GitHub token
under `~/.gist-vim`. It expects the format:

```
token 45cdef12323ab
```

NOTE: Make sure the GitHub token that you use has permissions to create gists.
You can edit these permissions from your Authentication Settings on GitHub. You
can manage your tokens from https://github.com/settings/tokens.

### Usage

The package has only one function called `gist.csv`. It takes a `data.table` (or
`data.frame`)

```R
library(csvgists)

resp <- gist.csv(data.frame(a=1:10, b=letters[1:10]), description='my gist')

# To update an existing gist - give its id:
resp <- gist.csv(data.frame(a=1:11, b=letters[1:11]), id=resp$id)
```

These commands produce a gist with the `data.frame` as a CSV format and print
the HTML URL for you ready to share with others.

NOTE: the default visibility of the gists is `private`, but you can set this to
public too. See `?gist.csv` for usage details.

#### Excel compatibility

Some Excel setups require `;` as a CSV separator and other custom settings. R takes care of that by
having a standard `write.csv2` function. `csvgists` allows you to use a custom `csv.writer` function
by passing a gist.csv argument.

```R
gist <- gist.csv(DT, csv.writer=write.csv2)
```

### Contribution

Feature requests as GitHub issues or pull requests are welcome.
