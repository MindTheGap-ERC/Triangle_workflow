function [wd, t] = get_wd(x_pos, y_pos, glob)
    % extracts water depth at a given location from CarboCAT outputs
    % wd: water depth
    % t: time steps
    % x_pos: position parallel to shore
    % y_pos: positon perpendicular to shore
    % glob: glob object produced by CarboCAT
    % outputs:
    % wd: water depth [m]
    % t: time step [1000 y]
    si=size(glob.thickness);
    t=(0:(si(3)-1))*glob.deltaT;
    wd = glob.wd(y_pos, x_pos, 1:glob.totalIterations);
    wd = reshape(wd,[1,size(wd,3)]);
    wd(wd<0) = 0;
    t = t(1:glob.totalIterations);
end