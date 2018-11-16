as_observer <- function(x, ...) {
  UseMethod("as_observer")
}

as_observer.function <- function(x, ...) {
  f_env <- fn_env(x)
  f_contents <- fn_body(x)
  f_args <- fn_fmls(x)

  f_trigger <- call2("c", !!!unname(f_args))

  f_assigns <- napply(f_args, function(nm, val) {
    call2("<-", sym(nm), val)
  })

  shiny::observeEvent(
    eventExpr = f_trigger,
    event.quoted = TRUE,
    # event.env = ???,  # TBD
    handlerExpr = call2("{", !!!f_assigns, !!!f_contents),
    handler.quoted = TRUE,
    handler.env = f_env
  )
}

napply <- function(x, f) {
  x_names <- names2(x)
  x_values <- x
  lapply(seq_along(x), function(i) f(x_names[[i]], x_values[[i]]))
}
