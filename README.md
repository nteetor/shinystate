# Shiny, stateful, modular

1. Fork project
2. Open locally
3. Simple example

```R
devtools::load_all()
remotes::install_github("nteeto/yonder")

App(
  Component(
    template = div(
      buttonInput(id = "click", "A simple button") %>%
        background("green") %>%
        margin(3)
    ),
    
    static = "A static string",
    
    function(num = input$click) {
      print(static)
    }
  )
)
```
