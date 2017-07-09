function fig = plot_filter_from_wav_files (fq_lim, stim_file, resp_file, am_limits_db, gd_limits_us, gd_smoothing)
  [frqs, fq_lim, fq_resp] = filter_from_wav_files(fq_lim, stim_file, resp_file, gd_smoothing);
  fig = plot_filter(frqs, fq_lim, fq_resp, am_limits_db, gd_limits_us);
endfunction
