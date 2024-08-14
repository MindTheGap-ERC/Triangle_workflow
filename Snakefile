
def aggregate_output(wildcards):
    return storage(expand("irods://nluu12p/home/research-test-christine/triangle/{param_file}.mat",
                          param_file=glob_wildcards("data/sea-level_curves/{param_file}.txt").param_file))


rule all:
    input:
        aggregate_output


rule matlab:
    input:
        "data/sea-level_curves/{param_file}.txt"
    output:
        storage("irods://nluu12p/home/research-test-christine/triangle/{param_file}.mat")
    shell:
        "cd src/CarboCATLite;"
        "echo \"CarboCAT_cli('params/DbPlatform/paramsInputValues.txt', 'params/DbPlatform/paramsProcesses.txt', '{wildcards.param_file}', '../../{input}', false); exit\" | matlab -nodesktop -nosplash;"
        "mv {wildcards.param_file}.mat ../../{output}"
