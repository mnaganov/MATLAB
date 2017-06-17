function plot_filter_from_wav_files (fq_lim, stim_file, resp_file, gd_scale_us, gd_smoothing)
  [freqs, fq_lim, fq_resp] = filter_from_wav_files(fq_lim, stim_file, resp_file, gd_smoothing);
  plot_filter(freqs, fq_lim, fq_resp, gd_scale_us);
endfunction
