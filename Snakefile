from snakemake.io import glob_wildcards

def aggregate_output(wildcards):
    return storage(expand("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat",
                  param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))

def strat_output(wildcards):
    return storage(expand("irods://nluu11p/home/research-mindthegap/triangle/strat-col/{param_file}_sc.mat",
                  param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))

rule all:
    input:
        strat_output



rule matlab:
   input:
       "data/sea-level_curves/{param_file}.txt"
   output:
       storage("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat")
   shell:
       "cd src/CarboCATLite;"
       "echo \"CarboCAT_cli('params/DbPlatform/paramsInputValues.txt', 'params/DbPlatform/paramsProcesses.txt', '{wildcards.param_file}', '../../{input}', false); exit\" | matlab -nodesktop -nosplash;"
       "mv {wildcards.param_file}.mat ../../{output};"


rule extract_data:
    input:
        storage("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat")
    output:
        storage("irods://nluu11p/home/research-mindthegap/triangle/strat-col/{param_file}_sc.mat")

    shell:
        "cd src/CarboCAT_utils;"
        "echo \"get_strat_columns([20, 50, 80, 120], [2, 2, 2, 2, 5, 5, 5, 5, 7, 7, 7, 7], '../../{input}','{wildcards.param_file}_sc'); exit\" | matlab -nodesktop -nosplash;"
        "mv {wildcards.param_file}_sc.mat ../../{output};"
