function plot_filter_from_tf (fq_lim, tf, n_fft, fs)
  [freqs, fq_lim, fq_resp] = filter_from_tf(fq_lim, tf, n_fft, fs);
  plot_filter(freqs, fq_lim, fq_resp);
endfunction
