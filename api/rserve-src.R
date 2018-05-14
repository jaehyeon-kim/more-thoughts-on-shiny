library(magrittr)
library(htmlwidgets)
library(DT)
library(plotly)

# iris_w <- iris[sample(1:nrow(iris), 10),] %>% datatable()
# plot_w <- data.frame(x = c(1:50), random_y = rnorm(50, mean = 0)) %>%
#   plot_ly(x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')

update_dep_path <- function(dep, libdir = 'lib') {
  dir <- dep$src$file
  if (!is.null(dep$package))
    dir <- system.file(dir, package = dep$package)
  
  if (length(libdir) != 1 || libdir %in% c("", "/"))
    stop("libdir must be of length 1 and cannot be '' or '/'")
  
  target <- if (getOption('htmltools.dir.version', TRUE)) {
    paste(dep$name, dep$version, sep = '-')
  } else {
    dep$name
  }
  dep$src$file <- file.path(libdir, target)
  dep
}

write_widget <- function(w, element_id, type = NULL, cdn = NULL, output_path = NULL) {
  w$elementId <- sprintf('htmlwidget_%s', element_id)
  toHTML <- utils::getFromNamespace(x = 'toHTML', ns = 'htmlwidgets')
  html <- toHTML(w, standalone = TRUE, knitrOptions = list())
  
  type <- match.arg(type, c('src', 'json', 'html', 'all'))
  if (type == 'src') {
    out <- html[[2]]
  } else if (type == 'json') {
    bptn <- paste0('<script type="application/json" data-for="htmlwidget_', element_id, '">')
    eptn <- '</script>'
    out <- sub(eptn, '', sub(bptn, '', html[[2]]))
  } else {
    html_tags <- htmltools::renderTags(html)
    html_tags$html <- sub('htmlwidget_container', sprintf('htmlwidget_container_%s', element_id) , html_tags$html)
    if (type == 'html') {
      out <- html_tags$html
    } else { # all
      libdir <- gsub('\\\\', '/', tempdir())
      libdir <- gsub('[[:space:]]|[A-Z]:', '', libdir)
      
      deps <- lapply(html_tags$dependencies, update_dep_path, libdir = libdir)
      deps <- htmltools::renderDependencies(dependencies = deps, srcType = c('hred', 'file'))
      deps <- ifelse(!is.null(cdn), gsub(libdir, cdn, deps), deps)
      
      out <- c(
        "<!DOCTYPE html>",
        "<html>",
        "<head>",
        "<meta charset='utf-8'/>",
        deps,
        html_tags$head,
        "</head>",
        "<body>",
        html_tags$html,
        "</body>",
        "</html>")
      }
    }
    
    if (!is.null(output_path)) {
      writeLines(out, output_path, useBytes = TRUE)
    } else {
      paste(out, collapse = '')
    }
}

test <- function(x) {
  x
}

htm <- function(element_id, type, cdn = 'public', ...) {
  Sys.sleep(2)
  if (grepl('iris', element_id)) {
    dat <- iris[sample(1:nrow(iris), 10),]
    w <- datatable(dat)
  } else {
    dat <- data.frame(x = c(1:50), random_y = rnorm(50, mean = 0))
    w <- dat %>% plot_ly(x = ~x, y = ~random_y, type = 'scatter', mode = 'lines')
  }
  write_widget(w, element_id, type, cdn)
}

parse_headers <- function(headers) {
  ## process headers to pull out request method (if supplied) and cookies
  if (is.raw(headers)) headers <- rawToChar(headers)
  if (is.character(headers)) {
    ## parse the headers into key/value pairs, collapsing multi-line values
    h.lines <- unlist(strsplit(gsub("[\r\n]+[ \t]+"," ", headers), "[\r\n]+"))
    h.keys <- tolower(gsub(":.*", "", h.lines))
    h.vals <- gsub("^[^:]*:[[:space:]]*", "", h.lines)
    names(h.vals) <- h.keys
    h.vals <- h.vals[grep("^[^:]+:", h.lines)]
    return (h.vals)
  } else {
    return (NULL)
  }
}

process_request <- function(url, query, body, headers) {
  #### building request object
  request <- list(uri = url, method = 'POST', query = query, body = body)
  
  ## parse headers
  request$headers <- parse_headers(headers)
  if ("request-method" %in% names(request$headers))
    request$method <- c(request$headers["request-method"])

  set_headers <- function(...) {
    paste(list(...), collapse = '\r\n')
  }
  
  #h1 <- 'Access-Control-Allow-Headers: Content-Type'
  h2 <- 'Access-Control-Allow-Methods: POST,GET,OPTIONS'
  h3 <- 'Access-Control-Allow-Origin: *'
  
  cors_headers <- set_headers(h2, h3)
  headers <- character(0)
  
  if (request$method == 'OPTIONS') {
    return (list(character(0), character(0), cors_headers))
  }
  
  request$pars <- list()
  if (request$method == 'POST') {
    if (!is.null(body)) {
      if (is.raw(body))
        body <- rawToChar(body)
      if (any(grepl('application/json', request$headers)))
        body <- jsonlite::fromJSON(body)
      request$pars <- as.list(body)
    }
  } else {
    if (!is.null(query)) {
      request$pars <- as.list(query)
    }
  }
  
  if ('type' %in% names(request$pars)) {
    if (request$pars$type == 'json') {
      content_type <- 'application/json; charset=utf-8'
    } else {
      content_type <- 'text/html; charset=utf-8'
    }
  } else {
    content_type <- 'text/plain; charset=utf-8'
  }
  
  message(sprintf('Header:\n%s', cors_headers))
  message(sprintf('Content Type: %s', content_type))
  message('Params:')
  print(do.call(c, request$pars))

  #### building output object
  ## generate payload (function output)
  ## currently function name must match to resource path
  matched_fun <- gsub('^/', '', request$uri)
  
  payload <- tryCatch({
    do.call(matched_fun, request$pars)
  }, error = function(err) {
    'Internal Server Error'
  })

  return (list(payload, content_type, cors_headers))
}

## Rserve requires .http.request function for handling HTTP request
.http.request <- process_request
