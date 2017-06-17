function [freqs, start_fq, end_fq, fq_resp_plot] = transform_log_data (log_l_freqs, log_l_freq_resp_db, log_l_phase_resp_deg, log_r_freqs, log_r_freq_resp_db, log_r_phase_resp_deg)
  start_fq = log_l_freqs(1);
  end_fq = log_l_freqs(end);
  freqs = start_fq:1:end_fq;
  fq_resp_plot.l = prepare_channel(freqs, log_l_freqs, log_l_freq_resp_db, log_l_phase_resp_deg);
  fq_resp_plot.r = prepare_channel(freqs, log_r_freqs, log_r_freq_resp_db, log_r_phase_resp_deg);
endfunction

function chan_fq_resp = prepare_channel (freqs, log_freqs, log_freq_resp_db, log_phase_resp_deg)
  chan_fq_resp.am_db = interp1(log_freqs, log_freq_resp_db, freqs, 'spline');
  chan_fq_resp.ph_deg = interp1(log_freqs, log_phase_resp_deg, freqs, 'spline');
  phase_resp = chan_fq_resp.ph_deg .* (pi / 180);
  gd = -diff(unwrap(phase_resp)) / (2 * pi * (freqs(2) - freqs(1)));
  chan_fq_resp.gd_us = gd * 1000000;
endfunction
