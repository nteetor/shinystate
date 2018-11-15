#' Create an application
#'
#' Combine components into an application.
#'
#' @param ... Any number of components, see [Component].
#'
#' @export
App <- function(...) {
  components <- list(...)

  ui <- lapply(components, function(co) co$template())

  server <- function(input, output) {
    for (co in components) {
      co$.install()
    }
  }

  shinyApp(ui, server)
}
