function fig = plot_filter_from_wav_files (fq_lim, stim_file, resp_file, am_limits_db, gd_limits_us, gd_smoothing)
  [freqs, fq_lim, fq_resp] = filter_from_wav_files(fq_lim, stim_file, resp_file, gd_smoothing);
  fig = plot_filter(freqs, fq_lim, fq_resp, am_limits_db, gd_limits_us);
endfunction
