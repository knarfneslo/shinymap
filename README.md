[![Status](https://travis-ci.org/Helseatlas/shinymap.svg?branch=master)](https://travis-ci.org/Helseatlas/shinymap/builds)[![Coverage Status](https://img.shields.io/codecov/c/github/Helseatlas/shinymap/master.svg)](https://codecov.io/github/Helseatlas/shinymap?branch=master)

# Shinymap

R-package to be used to produce maps on the helseatlas.no web page.

A working document on the process of going from IA to RShiny can be found [here](https://www.overleaf.com/read/qknnddwjnpfn) (read only).

## How to install the package

```
devtools::install_github("Helseatlas/shinymap")
```

You have the run the following command first if you are behind Helse Nord proxy:

```
httr::set_config(httr::use_proxy(url="http://www-proxy.helsenord.no", port=8080))
```

## How to use the package

### Input data

The input to the shiny app is a data frame containing the following columns:

```
area
level1
(level2) # optional
(level3) # optional
rate
numerater
name_numerater
denominator
name_denominator
```

If you want to test the package you can use a dataset shipped with the package, namely `shinymaps::kols`.


### Launch locally

Run the command

```r
shinymap::launch_application(dataset = <dataset>)
```

### Submit to shinyapps.io

Run the command

```
shinymap::launch_application(dataset = <r data frame>, publish_app = TRUE, name = <appName>, shiny_account = <publishing account>)
```

Make sure that the version of shinymap installed and active in your Rsession is installed directly from github,
since it also has to be installed on *shinyapps.io*. Also remember to connect to your *shinyapps.io* profile.

## Run a local copy of the package

- Download the package from github

```bash
git clone git@github.com:helseatlas/shinymap
```

- Open the `shinymap` folder in *RStudio*
- Install required packages, if not installed already. This can be done by `devtools::install_github("Helseatlas/shinymap")`. This will install the shinymap package from github and at the same time install all the required packages.
- Build the package (Ctrl+Shift+B on Windows/Linux or &#8984;-&#8679;-B on Mac).
- Put some data in `healthatlas_data` and define some parametres

```r
healthatlas_data <- shinymap::kols # or another dataset to use
language <- "no" # or "en"
webpage_title <- "Helseatlas kols 2013-2015"
```

- Run the app, either by open the file `inst/app/server.R` and push the button or

```r
shiny::runApp('inst/app')
```

## Contribute

- [Fork me](https://github.com/Helseatlas/shinymap/fork)
- Clone your fork (replace `<username` with your github user name), create a branch and push it

```
git clone git@github.com:<username>/shinymap
cd shinymap
git checkout -b super-duper-idea
git push -u origin super-duper-idea
```

- Do your changes, commit your changes and push your changes (please remember to add tests and documentation!)

```
git add .
git commit -m 'My super duper idea'
git push
```

- Create a [pull request](https://github.com/Helseatlas/shinymap/compare) (PR).
- Wait for PR to me reviewed and tested.
