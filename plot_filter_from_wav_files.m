function plot_filter_from_wav_files (start_fq, end_fq, stim_file, resp_file, gd_scale_us, gd_smoothing)
  [freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us] = filter_from_wav_files(start_fq, end_fq, stim_file, resp_file, gd_smoothing);
  plot_filter(freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us, gd_scale_us);
endfunction
