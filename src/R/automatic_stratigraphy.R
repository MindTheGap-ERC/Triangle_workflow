#!/usr/bin/env Rscript
# Running R script with parameters from CLI:
# See https://www.r-bloggers.com/2015/09/passing-arguments-to-an-r-script-from-command-lines/

args = commandArgs(trailingOnly=TRUE)

source("read_matlab_outputs.R")
strat_cols <- read_matlab_outputs("args[1]") # args[1] should be name of the matlab file 
pos <- 2
da = data.frame(strat_cols[[pos]]$thickness, strat_cols[[pos]]$facies)
da$strat_cols..pos...thickness <- da$strat_cols..pos...thickness*100 #convert m to cm


av_sed = (dim(df)[1])/duration #cm/kyr
prec_period = 21*av_sed #cm
N_per_cycle = 6 
dh = prec_period/N_per_cycle

data = astrochron::linterp(df, dt = dh/100)
res_m = 0.1

ranked_data = astrochron::rankSeries(data, dt = res_m)

a = astrochron::timeOpt(ranked_data, output = 1)
