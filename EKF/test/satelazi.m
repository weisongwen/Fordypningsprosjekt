function [ el, azi ] = satelazi(lat, lon, h, sat_pos)
    
    wgs84 = wgs84Ellipsoid('meters');
    [azi, el, ~] = ecef2aer(sat_pos(1,:), sat_pos(2,:), sat_pos(3,:), ...
                            lat, lon, h, wgs84);

end
%{
    %http://www.naic.edu/aisr/GPSTEC/drewstuff/MATLAB/elavazim.m
    %https://gis.stackexchange.com/questions/58923/calculate-view-angle
    n = size(sat_pos, 2);
    
    diff_pos = sat_pos - pos;
    el = acos(sum(pos.*diff_pos) ./ sqrt(sum(pos .^ 2) .* sum(diff_pos .^ 2)));
    el = rad2deg(el);
    
    x = pos(1); y = pos(2); z = pos(3);
    dx = diff_pos(1, :); dy = diff_pos(2, :); dz = diff_pos(3, :);
    azi = acos((-z*x*dx - z*y*dy + (x^2+y^2)*dz) ./ ...
          sqrt((x^2+y^2)*(x^2+y^2+z^2)*(dx.^2+dy.^2+dz.^2)));
    azi = rad2deg(azi);
    
    %Set undefined to 0 elevation
    ind = isnan(el);
    el(ind) = 0;
    azi(ind) = 0;
    
    %Horizon is 0 degrees in all directions
    ind = el > 90;
    el(ind) = 180 - el(ind);
end
%}
%{ 
    Old useless code
    los_vec = diff_pos / norm(diff_pos);
    dx = los_vec(1, :); dy = los_vec(2, :); dz = los_vec(3, :);
    
    lla = ecef2lla(pos');
    lat = deg2rad(lla(1)); lon = deg2rad(lla(2));
    
    north = -cos(lon)*sin(lat) .* dx-sin(lon)*sin(lat).*dy+cos(lat).*dz;
    east = -sin(lon).*dx+cos(lon).*dy;
    vertical = cos(lon)*cos(lat) .* dx-sin(lon)*cos(lat) .* dy-sin(lat) .* dz;
    el = rad2deg(pi/2 - acos(vertical));
    azi = rad2deg(atan(east./north));
%}
