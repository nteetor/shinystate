#' Component exports
#'
#' A work in progress.
#'
#' @param ... Named values to export.
#'
#' @export
exports <- function(...) {
  structure(
    enquos(...),
    class = "exports"
  )
}

#' Create components
#'
#' A component connects a front-end `template` to exports (WIP).
#'
#' @param ... Values to load into the component environment or functions.
#'   Functions arguments may default to reactives in which they too are
#'   reactive.
#'
#' @param template A tag element.
#'
#' @param export A call to `exports()`, currently unused.
#'
#' @export
#' @examples
#' library(shiny)
#'
#' Component(
#'   template = actionButton(
#'     inputId = "clicks",
#'     label = "A button"
#'   ),
#'   function(clicks = input$clicks) {
#'     print("Button clicked")
#'   }
#' )
#'
Component <- function(..., template, export) {
  force(export)

  args <- list(...)
  values <- args[names2(args) != ""]
  component_env <- new_environment(values, parent = caller_env())

  observers <- args[vapply(args, is_function, logical(1))]
  observers <- lapply(observers, function(obs) {
    fn_env(obs) <- env_clone(fn_env(obs), component_env)
    obs
  })

  this <- env(
    template = function() template
  )

  this$.install <- function() {
    c_env <- caller_env()

    if (length(export)) {
      for (name in names(export)) {
        env_bind_active(
          this,
          !!name := shiny::reactive(
            x = quo_get_expr(export[[name]]),
            env = c_env,
            quoted = TRUE
          )
        )
      }
    }

    if (length(observers)) {
      for (obs in observers) {
        event <- call2("c", !!!fn_fmls(obs))

        observeEvent(
          eventExpr = event,
          event.quoted = TRUE,
          event.env = c_env,
          handlerExpr = fn_body(obs),
          handler.quoted = TRUE,
          handler.env = fn_env(obs)
        )
      }
    }
  }

  class(this) <- c("component", class(this))
  this
}

print.component <- function(x, ...) {
  print(x$template())
  invisible(x)
}

as.character.component <- function(x, ...) {
  as.character(x$template())
}
