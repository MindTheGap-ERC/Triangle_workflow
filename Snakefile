from snakemake.io import glob_wildcards

BASE_COLLECTION="irods://nluu11p/home/research-mindthegap/triangle"

def aggregate_output(wildcards):
    param_file = glob_wildcards(storage(BASE_COLLECTION + "/sea-level_curves/{param_file}.txt")).param_file
    return storage(expand(BASE_COLLECTION + "/output/{param_file}.h5",
                  param_file=param_file))


def aggregate_metadata(wildcards):
    param_file = glob_wildcards(storage(BASE_COLLECTION + "/sea-level_curves/{param_file}.txt")).param_file
    return expand("{param_file}.done", param_file=param_file)
# def strat_output(wildcards):
#     return storage(expand("irods://nluu11p/home/research-mindthegap/triangle/strat-col/{param_file}_sc.mat",
#                   param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))

rule all:
    input:
        aggregate_output,
        aggregate_metadata



rule julia:
    input:
        storage(BASE_COLLECTION + "/sea-level_curves/{param_file}.txt")
    output:
        h5=storage(BASE_COLLECTION + "/output/{param_file}.h5"),
        csv=storage(BASE_COLLECTION + "/output/{param_file}.csv"),
        toml=storage(BASE_COLLECTION + "/output/{param_file}.toml"),
    shell:
        "julia src/Julia/external_SL.jl {input} {output.h5} {output.csv} {output.toml}"


rule add_metadata:
    input:
        # h5=storage(BASE_COLLECTION + "/output/{param_file}.h5"),
        toml=storage(BASE_COLLECTION + "/output/{param_file}.toml"),
    output:
        touch("{param_file}.done")
    shell:
        "python src/python/add_metadata.py " + BASE_COLLECTION[7:] + "/output/{wildcards.param_file}.h5 {input.toml}" 

# rule extract_data:
#     input:
#         storage("irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat")
#     output:
#         storage("irods://nluu11p/home/research-mindthegap/triangle/strat-col/{param_file}_sc.mat")

#     shell:
#         "cd src/CarboCAT_utils;"
#         "echo \"get_strat_columns([20, 50, 80, 120], [2, 2, 2, 2, 5, 5, 5, 5, 7, 7, 7, 7], '../../{input}','{wildcards.param_file}_sc'); exit\" | matlab -nodesktop -nosplash;"
#         "mv {wildcards.param_file}_sc.mat ../../{output};"
