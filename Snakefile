
def aggregate_output(wildcards):
    return storage(expand("irods://nluu12p/home/research-test-christine/triangle/{param_file}.mat",
                          param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))

def strat_output(wildcards):
    return storage(expand("irods://nluu12p/home/research-test-christine/triangle/strat_columns/{param_file}_sc.mat",
                          param_file=glob_wildcards("irods://nluu12p/home/research-test-christine/triangle/{param_file}.mat").param_file))



rule all:
    input:
        aggregate_output,
        strat_output


rule matlab:
    input:
        "data/sea-level_curves/{param_file}.txt"
    output:
        storage("irods://nluu12p/home/research-test-christine/triangle/{param_file}.mat")
    shell:
        "cd src/CarboCATLite;"
        "echo \"CarboCAT_cli('params/DbPlatform/paramsInputValues.txt', 'params/DbPlatform/paramsProcesses.txt', '{wildcards.param_file}', '../../{input}', false); exit\" | matlab -nodesktop -nosplash;"
        "mv {wildcards.param_file}.mat ../../{output}"

rule extract_data:
    input:
        "irods://nluu11p/home/research-mindthegap/triangle/{param_file}.mat"
    output:
        storage("irods://nluu12p/home/research-test-christine/triangle/strat_columns/{param_file}_sc.mat")
    params:
        x_positions=[5, 5, 5], 
        y_positions=[1, 5, 10]
    shell:
        "cd ../CarboCAT_utils;"
        "x_positions = [{params.x_positions}]; "
        "y_positions = [{params.y_positions}]; "
        "echo \"get_strat_columns(x_positions, y_positions, '{input}', '{output}'); exit\" | matlab -nodesktop -nosplash"
        "mv {wildcards.param_file}_sc.mat ../../{output}" 