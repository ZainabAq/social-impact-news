social-impact-news
================

Definitions of Key Terms
------------------------

Social impact:

-   change in way of thinking/attitude or brings someone to take action or change the way they act
-   leaves an impression or makes the reader think even if it doesn’t change his or her views

Quality Journalism:

-   accurate, clear, multiple sources, relevance, change in way of thinking/attitude/action (includes above)
-   [*Social impact can be a smaller part of quality journalism but not vice versa?*](https://www.huffingtonpost.com/2012/04/16/huffington-post-pulitzer-prize-2012_n_1429169.html)

To run the app
--------------

All files within the folder `shiny_app` are necessary, as well as the CSV titled `FINAL_DATA_FOR_SQL.csv` (not included in this repository). This CSV contains the URLs and all statistics required for the models. The `app.R` file found within this folder contains the Shiny code, which includes the interface, server function, and a call to the shinyApp function. Once loaded into RStudio, the app can be run from clicking the tab at the top of this file titled 'Run App'. The `findstats.R` file is sourced from the app file. Here, the models predict on the entire dataset and are added to the dataframe as new columns. These columns are queried in the app file in order to display the predictions for the article of interest. The other files in this folder are rda files of the three models and the plot created for the app.

``` bash
ls -sh shiny_app
```

    ## total 2.9M
    ##  12K app.R
    ## 1.3M FINAL_DATA_FOR_SQL.csv
    ## 8.0K findstats.R
    ## 860K GBM_Final.rda
    ##  72K huffplot.rda
    ## 304K logisitic_regression_final.rda
    ## 440K svmFINALFINAL.rda
