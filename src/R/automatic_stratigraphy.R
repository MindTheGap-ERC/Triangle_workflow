#!/usr/bin/env Rscript

#### Imports ####
library("astrochron")
library("stratcols")
library("stratorder")
source("src/R/utility_functions.R")

args = commandArgs(trailingOnly=TRUE)

#### Cyclostratigraphy ####

#example for testing
#df <- read.csv(file="data/strat_cols/Auto000_Allo000_Stoch100V1_sc.csv")
df <- read.csv(file=args[1],
               sep = ",",
               header = TRUE)


strat_columns <- split_sections(df)

##### Test this on one section: needs to be propagated to an entire list #####

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
data$thickness <- data$thickness/100 #back to metres

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

results <- result_cyclo[which.max(result_cyclo$r2_opt),]

results$cyclo_pval <- astrochron::timeOptSim(dat = data,
                                                    sedrate=results$sedrate[1], # use the best one found by timeOpt
                                                    numsim = 2000, 
                                                    fit=1, 
                                                    roll=NULL, 
                                                    output=1, 
                                                    genplot = FALSE, 
                                                    verbose = FALSE)

#### Markov metrics ####

s = stratcols::as_stratcol(thickness = da$thickness,
                facies = da$facies)
s_merged = merge_beds(s, mode = "identical facies")
m = stratorder::transition_matrix(s_merged)

n = 10000
rom_vals = rep(NA, n)
for (i in seq_len(n)){
  randomized_column = shuffle_col(s)
  rom_vals[i] = get_rom(randomized_column)
}

results$rom <- get_rom(s)
results$rom_pval <- calculate_p_value(rom_vals, get_rom(s))

#### Assemble data for export ####

results <- cbind(args[1], results)
write.csv(results,
          file="data/Triangle_results.csv",
          append = TRUE,
          col.names = TRUE)
