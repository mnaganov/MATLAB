function [freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us] = filter_from_wav_files (start_fq, end_fq, stim_file, resp_file, gd_smoothing)
  [freqs, l_freq_resp, l_phase_resp, l_gd_us, r_freq_resp, r_phase_resp, r_gd_us] = analyze_filter(start_fq, end_fq, stim_file, resp_file, gd_smoothing);
  l_freq_resp_db = to_db(l_freq_resp);
  l_phase_resp_deg = to_deg(l_phase_resp);
  r_freq_resp_db = to_db(r_freq_resp);
  r_phase_resp_deg = to_deg(r_phase_resp);
endfunction

function in_db = to_db (ampls)
  in_db = 20 * log10(ampls);
endfunction

function in_deg = to_deg (rads)
  in_deg = rads .* (180 / pi);
endfunction
