function [h,t] = get_adm(pos_in_strike_dir, pos_in_dip_dir, glob)
    % extracts age-depth models from CarboCAT model outputs
    % h: vector of heights
    % t: vector of times
    si=size(glob.thickness);
    a1=glob.thickness(pos_in_dip_dir,pos_in_strike_dir,:);
    a2=squeeze(cellfun(@(x) sum(x,'all'),a1));
    h =cumsum([0;a2])';
    t=(0:(si(3)))*glob.deltaT;
    t = t(1:glob.totalIterations + 1);
    h = h(1:length(t));
end