function [pr, sat_pos, n_sat] = parse_data(data, i)
    vis_sat = data.pseudorange(i, :) ~= 0;           %visible satellites index (EL not 0)
    n_sat = sum(vis_sat);                            %number of visible satellites
    sat_pos = squeeze(data.satPos(i, vis_sat, :))';   %Satellite positions
    pr = data.pseudorange(i, vis_sat)';               %Satellite pseudoranges
end