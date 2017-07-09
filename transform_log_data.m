function [frqs, fq_lim, fq_resp_plot] = transform_log_data (log_l_frqs, log_l_freq_resp_db, log_l_phase_resp_deg, log_r_frqs, log_r_freq_resp_db, log_r_phase_resp_deg)
  fq_lim = [log_l_frqs(1), log_l_frqs(end)];
  frqs = fq_lim(1):1:fq_lim(2);
  fq_resp_plot.l = prepare_channel(frqs, log_l_frqs, log_l_freq_resp_db, log_l_phase_resp_deg);
  fq_resp_plot.r = prepare_channel(frqs, log_r_frqs, log_r_freq_resp_db, log_r_phase_resp_deg);
endfunction

function chan_fq_resp = prepare_channel (frqs, log_frqs, log_freq_resp_db, log_phase_resp_deg)
  chan_fq_resp.am_db = interp1(log_frqs, log_freq_resp_db, frqs, 'spline');
  chan_fq_resp.ph_deg = interp1(log_frqs, log_phase_resp_deg, frqs, 'spline');
  phase_resp = chan_fq_resp.ph_deg .* (pi / 180);
  gd = -diff(unwrap(phase_resp)) / (2 * pi * (frqs(2) - frqs(1)));
  chan_fq_resp.gd_us = gd * 1000000;
endfunction
