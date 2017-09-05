function [frqs, fq_lim, fq_resp_plot] = filter_from_tf_mono (fq_lim, tf, n_fft, fs)
  [frqs, fq_resp] = freqz_and_gd_mono(fq_lim, tf, n_fft, fs);
  fq_resp_plot = channel_for_plot(fq_resp);
endfunction
