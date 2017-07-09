function [frqs, fq_lim, fq_resp_plot] = filter_from_tf (fq_lim, tf, n_fft, fs)
  [frqs, fq_resp] = freqz_and_gd(fq_lim, tf, n_fft, fs);
  fq_resp_plot.l = channel_for_plot(fq_resp.l);
  fq_resp_plot.r = channel_for_plot(fq_resp.r);
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    fq_resp_plot.r.am_db = fq_resp_plot.r.am_db - tf.r.am_attn_db;
  endif
endfunction
