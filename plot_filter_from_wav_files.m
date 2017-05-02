function plot_filter_from_wav_files (start_fq, end_fq, stim_file, l_resp_file, r_resp_file, gd_scale, gd_smoothing)
  [freqs, l_freq_resp, l_phase_resp, l_gd, r_freq_resp, r_phase_resp, r_gd] = analyze_filter(start_fq, end_fq, stim_file, l_resp_file, r_resp_file, gd_smoothing);

  plot_filter(freqs, start_fq, end_fq, l_freq_resp, l_phase_resp, l_gd, r_freq_resp, r_phase_resp, r_gd, gd_scale);
endfunction
