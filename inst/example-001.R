devtools::load_all()
library(yonder)

App(
  Component(
    template = div(
      buttonInput(id = "click", "A simple button") %>%
        background("green") %>%
        margin(3)
    ),
    export = exports(
      click = input$click
    ),
    static = "A static string",
    function(num = input$click) {
      print(static)

      # Interestingly, `static` is visible, but `input$click` is not
      # (not intentional)
    }
  )
)
