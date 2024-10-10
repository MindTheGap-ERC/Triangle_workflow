from snakemake.io import glob_wildcards


def aggregate_output(wildcards):
    return storage(expand("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat",
                  param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))

def strat_output(wildcards):
    return storage(expand("irods://nluu11p/home/research-mindthegap/triangle/strat_col/{param_file}_sc.mat",
                  param_file=glob_wildcards("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat").param_file))



rule all:
    input:
        aggregate_output,
        strat_output


rule matlab:
    input:
        "data/sea-level_curves/{param_file}.txt"
    output:
        storage("irods://nluu11p/home/research-mindthegap/triangle")
    shell:
        "cd src/CarboCATLite;"
        "echo \"CarboCAT_cli('params/DbPlatform/paramsInputValues.txt', 'params/DbPlatform/paramsProcesses.txt', '{wildcards.param_file}', '../../{input}', false); exit\" | matlab -nodesktop -nosplash;"
        "mv {wildcards.param_file}.mat ../../{output}"
        "sleep 3"

rule extract_data:
    input:
        storage("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat")
    output:
        storage("irods://nluu11p/home/research-mindthegap/triangle/strat-col")
    params:
        x_positions=[5, 5, 5], 
        y_positions=[1, 5, 10]
    shell:
        "cd ../CarboCAT_utils;"
        "x_positions = [{params.x_positions}]; "
        "y_positions = [{params.y_positions}]; "
        "echo \"get_strat_columns(x_positions, y_positions, '../../{input}','{wildcards.param_file}_sc'); exit\" | matlab -nodesktop -nosplash"
        "mv {wildcards.param_file}_sc.mat ../../{output}" 