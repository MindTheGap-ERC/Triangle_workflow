# Testing the drivers of the stratigraphic architecture

## Purpose

A repository to develop a workflow linking Matlab and R to generate and analyse a large number of simulations.


## Steps to run the workflow

### Install iBridges

```shell
pip install ibridges
```

### Setup and check iBridges installation

```shell
ibridges init
```

### Install SnakeMake iRODS/iBridges plugin

The ibridges/snakemake plugin needs to installed from a branch in a fork:

```shell
pip install git+https://github.com/qubixes/snakemake-storage-plugin-irods.git@switch-to-ibridges
```

## Run the workflow

```shell
snakemake --cores all
```

## Authors

Scientific contents:

__Emilia Jarochowska__  
Utrecht University  
email: e.b.jarochowska [at] uu.nl  
Web page: [www.uu.nl/staff/EBJarochowska](https://www.uu.nl/staff/EBJarochowska)  
ORCID: [0000-0001-8937-9405](https://orcid.org/0000-0001-8937-9405)

__Niklas Hohmann__  
Utrecht University  
email: n.h.hohmann [at] uu.nl  
Web page: [www.uu.nl/staff/NHohmann](https://www.uu.nl/staff/NHHohmann)  
ORCID: [0000-0003-1559-1838](https://orcid.org/0000-0003-1559-1838)

__Xianyi Liu__  
Utrecht University  
email: x.liu6 [at] uu.nl  
Web page: [www.uu.nl/staff/XLiu6](https://www.uu.nl/staff/XLiu6)  
ORCID: [0000-0002-3851-116X](https://orcid.org/0000-0002-3851-116X)

__Peter Burgess__  
University of Liverpool  
Web page: [www.liverpool.ac.uk/environmental-sciences/staff/peter-burgess](https://www.liverpool.ac.uk/environmental-sciences/staff/peter-burgess/)  
ORCID: [0000-0002-3812-4231](https://orcid.org/0000-0002-3812-4231)

__David De Vleeschouwer__  
Westfälische Wilhelms-Universität Münster  
Web page: [www.uni-muenster.de/GeoPalaeontologie/erdsystemforschung/staff/DeVleeschouwer](https://www.uni-muenster.de/GeoPalaeontologie/erdsystemforschung/staff/DeVleeschouwer.html)  
ORCID: [0000-0002-3323-807X](https://orcid.org/0000-0002-3323-807X)



## Copyright

Copyright 2024 Netherlands eScience Center and Utrecht University

## License

Apache 2.0 License, see LICENSE file for license text.

## Funding information

Funded by the European Union (ERC, MindTheGap, StG project no 101041077). Views and opinions expressed are however those of the author(s) only and do not necessarily reflect those of the European Union or the European Research Council. Neither the European Union nor the granting authority can be held responsible for them.
![European Union and European Research Council logos](https://erc.europa.eu/sites/default/files/2023-06/LOGO_ERC-FLAG_FP.png)
