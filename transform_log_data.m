function [freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us] = transform_log_data (log_l_freqs, log_l_freq_resp_db, log_l_phase_resp_deg, log_r_freqs, log_r_freq_resp_db, log_r_phase_resp_deg)
  start_fq = log_l_freqs(1);
  end_fq = log_l_freqs(end);
  freqs = start_fq:1:end_fq;
  [l_freq_resp_db, l_phase_resp_deg, l_gd_us] = prepare_channel(freqs, log_l_freqs, log_l_freq_resp_db, log_l_phase_resp_deg);
  [r_freq_resp_db, r_phase_resp_deg, r_gd_us] = prepare_channel(freqs, log_r_freqs, log_r_freq_resp_db, log_r_phase_resp_deg);
endfunction

function [freq_resp_db, phase_resp_deg, gd_us] = prepare_channel (freqs, log_freqs, log_freq_resp_db, log_phase_resp_deg)
  freq_resp_db = interp1(log_freqs, log_freq_resp_db, freqs, 'spline');
  phase_resp_deg = interp1(log_freqs, log_phase_resp_deg, freqs, 'spline');
  phase_resp = phase_resp_deg .* (pi / 180);
  gd = -diff(unwrap(phase_resp)) / (2 * pi * (freqs(2) - freqs(1)));
  gd_us = gd * 1000000;
endfunction