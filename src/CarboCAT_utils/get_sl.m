function [sl, t] = get_sl(glob)
    % extracts sea level curve from CarboCAT outputs
    % sl: eustatic sea level
    % t: time steps
    si=size(glob.thickness);
    t=(0:(si(3)-1))*glob.deltaT;
    sl = glob.SL(1:glob.totalIterations + 1);
    t = t(1:glob.totalIterations + 1);
end