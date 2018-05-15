library(magrittr)
library(htmlwidgets)
library(DT)
library(highcharter)
library(plotly)

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

get_iris <- function(get_all = FALSE) {
  Sys.sleep(2)
  if (!get_all) {
    iris[sample(1:nrow(iris), 10),]    
  } else {
    iris
  }
}

widget <- function(element_id, type, get_all = FALSE, cdn = 'public', ...) {
  dat <- get_iris(get_all)
  if (grepl('dt', element_id)) {
    w <- dat %>%
      datatable(options = list(
        pageLength = 5,
        lengthMenu = c(5, 10)
      ))
  } else if (grepl('highchart', element_id)) {
    w <- dat %>% 
      hchart('scatter', hcaes(x = 'Sepal.Length', y = 'Sepal.Width', group = 'Species')) %>%
      hc_title(text = 'Iris Scatter')
  } else if (grepl('plotly', element_id)) {
    w <- dat %>%
      plot_ly(x = ~Sepal.Length, y = ~Sepal.Width, z = ~Petal.Length, color = ~Species)
  } else {
    stop('Unexpected element')
  }
  write_widget(w, element_id, type, cdn)
}
