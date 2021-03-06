function r = range_estimate_no_imu(sat_pos, x_hat)
    pos = x_hat(1:3);
    r = sqrt(sum((sat_pos - pos) .^ 2))' + x_hat(end-1);
end