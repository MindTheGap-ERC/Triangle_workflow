function [out] = get_strat_columns(x_positions, y_positions, input_file, output_file)
    % extract multiple stratigraphic columns
    % x_positions: vector of grid cell positions perpendicular to shore
    % y_positions: vector of grid cell positions parallel to shore. must be
    % of same length as x_positions. to extract dip sections, use
    % bathurst_2m_amp
    % input_file: struct loaded from CarboCAT glob object stored in a `.mat` file
    % output_file: `mat` file with extracted data
    % returns: a struct with fields x_positions,y_postitions, thickenss,
    % and facies

    load(input_file)
    
    out.x_positions = x_positions;
    out.y_positions = y_positions;    
    for ind = 1:length(x_positions)
        x_pos = x_positions(ind);
        y_pos = y_positions(ind);
        [thickness, facies] = get_strat_column(x_pos, y_pos, glob);
        thicknesses{ind} = thickness;
        facies_collection{ind} = facies;
    end    
    out.thickness = thicknesses;
    out.facies = facies_collection;

    save(append(output_file,".mat"), "x_positions", "y_positions", "thickness", "facies")
end