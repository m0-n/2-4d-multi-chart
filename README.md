# R multiple 2d plots with colors from 3rd variable
>Generates a series of 2d plots with colors from 3rd variable. Can be used to visualize 2 - 4 dimensional data.

RStudio script to display a series of feature-charts in a single plot. This can be an "ok" approach for finding causal relationships between features and a target variable, when the dataset is too small to use machine learning, but too complex to see the pattern with the naked eye.

![rstudio 2d multi chart with 3rd variable as color](http://logos-gmbh.com/tools/3d-plot-examplechart.png)

## Usage instructions
1. In line 23, change the path to your input text file and specifiy whether its first line is the header (default: true)
2. In line 24, change the column names to fit your data
3. Run the script

## Dataset example line
{"feature 1";"0";"2019/01/01";"99"}

## Artefact
On receiving well-formatted input, the script will generate a separate chart for every feature (and one for the target variable) and put everything into one plot. It's very efficient and can handle very large sets of data while doing this.

The output is essentially a series of 2d charts where a 3rd variable can be used for the color of the line - so up to four dimensions can be visualized (e.g: D1 = feature(new chart), D2 = time (x-axis), D3 = value (y-axis), D4 = attribute (line color). 

The accumulative sum of all values is also displayed in each chart and displayed as a number on the right, grouped by attribute.

## Comments
- Everything in this repo is released for use "AS IS" without any warranties of any kind.
- If this script was useful for you and you would like to see more RScripts, please star the repository, so I get feedback.

