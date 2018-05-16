source('/home/rstudio/api/widget-src.R')

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
  
  h1 <- 'Access-Control-Allow-Headers: Content-Type'
  h2 <- 'Access-Control-Allow-Methods: POST,GET,OPTIONS'
  h3 <- 'Access-Control-Allow-Origin: *'
  
  cors_headers <- set_headers(h1, h2, h3)

  if (request$method == 'OPTIONS') {
    return (list('', 'text/plain', cors_headers))
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
