#!/usr/bin/env Rscript
# Running R script with parameters from CLI:
# See https://www.r-bloggers.com/2015/09/passing-arguments-to-an-r-script-from-command-lines/

#### Imports ####
library("astrochron")
source("src/R/utility_functions.R")

args = commandArgs(trailingOnly=TRUE)

#example for testing
df <- read.csv(file="data/strat_cols/Auto000_Allo000_Stoch100V1_sc.csv")
#df <- read.csv(file=args[1],
#               sep = ",",
#               header = TRUE)


strat_columns <- split_sections(df)

#### Test this on one section: needs to be propagated to an entire list ####

strat_columns$sc1_collapsed <- collapse_section(strat_columns$sc1)
da <- strat_columns$sc1_collapsed
da$thickness <- da$thickness * 100 #convert m to cm

duration = 400 # kyr, needs to be read from the metadata

av_sed = da$thickness[1]/duration #cm/kyr
prec_period = 21*av_sed #cm
N_per_cycle = 6 
dh = prec_period/N_per_cycle 

data = astrochron::linterp(da, dt = dh,
                           check = TRUE,
                           genplot = FALSE)
data$thickness <- data$thickness/100

#ranked_data = astrochron::rankSeries(data,
#                                     genplot = FALSE)

result_cyclo <- astrochron::timeOpt(dat = data, 
                                    sedmin=0.5,
                                    sedmax=10,
                                    numsed=100,
                                    linLog = 1,
                                    r2max = 1,
                                    output = 1,
                                    check = F,
                                    verbose = FALSE,
                                    fit=1, # Test for precession amplitude modulation
                                    roll=1000, # Taner filter roll-off rate, in dB/octave.
                                    genplot = FALSE) 

#### Assemble data for export ####

best_sedrate <- result_cyclo[which.max(result_cyclo$r2_opt),]
