function [thickness, facies] = get_strat_column(x_pos, y_pos, glob)
    % extracts stratigraphic column from CarboCAT outputs 
    % x_pos: position perpendicular to shore
    % y_pos: positon parallel to shore
    % glob: glob object produced by CarboCAT
    % outputs:
    % thickness: thickenss of bed
    % facies: facies of bed
    % note that no of beds is independent of no of time steps
    si = size(glob.thickness);
    tsteps = glob.totalIterations + 1;
    thickness = [];
    facies = [];
    for ( step = 1:tsteps)
        if ( glob.numberOfLayers(x_pos,y_pos,step) ~= 0)
        thickness = [thickness, glob.thickness{x_pos,y_pos,step}];
        facies = [facies, glob.facies{x_pos,y_pos,step}];
        end
    end
end
