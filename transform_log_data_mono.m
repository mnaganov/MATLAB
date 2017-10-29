function [frqs, fq_lim, chan_fq_resp] = transform_log_data_mono (log_frqs, log_freq_resp_db, log_phase_resp_deg)
  fq_lim = [log_frqs(1), log_frqs(end)];
  frqs = fq_lim(1):1:fq_lim(2);
  chan_fq_resp.am_db = interp1(log_frqs, log_freq_resp_db, frqs, 'spline');
  chan_fq_resp.ph_deg = interp1(log_frqs, log_phase_resp_deg, frqs, 'spline');
  phase_resp = chan_fq_resp.ph_deg .* (pi / 180);
  gd = -diff(unwrap(phase_resp)) / (2 * pi * (frqs(2) - frqs(1)));
  chan_fq_resp.gd_us = gd * 1000000;
end
