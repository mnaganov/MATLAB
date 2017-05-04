function plot_filter_from_wav_files (start_fq, end_fq, stim_file, l_resp_file, r_resp_file, gd_scale_us, gd_smoothing)
  [freqs, l_freq_resp, l_phase_resp, l_gd, r_freq_resp, r_phase_resp, r_gd] = analyze_filter(start_fq, end_fq, stim_file, l_resp_file, r_resp_file, gd_smoothing);

  plot_filter(freqs, start_fq, end_fq, to_db(l_freq_resp), to_deg(l_phase_resp), l_gd, to_db(r_freq_resp), to_deg(r_phase_resp), r_gd, gd_scale_us);
endfunction

function in_db = to_db (ampls)
  in_db = 20 * log10(ampls);
endfunction

function in_deg = to_deg (rads)
  in_deg = rads .* (180 / pi);
endfunction
