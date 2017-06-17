function plot_filter_from_wav_files (start_fq, end_fq, stim_file, resp_file, gd_scale_us, gd_smoothing)
  [freqs, start_fq, end_fq, fq_resp] = filter_from_wav_files(start_fq, end_fq, stim_file, resp_file, gd_smoothing);
  plot_filter(freqs, start_fq, end_fq, fq_resp, gd_scale_us);
endfunction
