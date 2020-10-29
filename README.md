# 992-citation-project

## 2020-10-27 parse json file/ Sijia Fang
`ParseData.ipynb` provide python code to parse json file.
To run the code, first download `out.json` and put it in this directory.
Four txt files will be created:
 

- Paper.txt : paper information
- Citation.txt : incitation information
- Field.txt: field of paper (one paper can have several fields)
- Author.txt: author of paper (one paper can have several authors)

use `|` as seperator since there are comma in abstract

To read it into R, use `Paper <- read.csv("Paper.txt", sep = "|")`
