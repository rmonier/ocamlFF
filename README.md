# OCAMLFF

## How to use

1) Install [NPM](https://nodejs.org/en/download/).

2) Install [Esy](https://esy.sh/) with `npm install -g esy`.

> :warning: On Linux you might want to install it with the following command: `sudo npm install -g --unsafe-perm esy`

3) Install [Graphviz](http://www.graphviz.org/download/) to be able to use the `dot` command in order to generate SVG graphs.

4) Install dependencies in the project root with the command : `esy`.

Execute with `esy x ftest.exe`. You can also use the demo script which uses default parameters with `esy fordfulk` and produce its SVG with `esy produce-svg`.

## Executable

You can find the binary file compiled for your OS in `_build/default`. You can then copy it wherever you want and use it independently.

You can then generate your own graphs using this website : https://algorithms.discrete.ma.tum.de/graph-algorithms/flow-ford-fulkerson/index_en.html

Download the TXT and use it as the input file.