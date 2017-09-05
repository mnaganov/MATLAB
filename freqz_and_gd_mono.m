function [frqs, fq_resp] = freqz_and_gd_mono (fq_lim, tf, n_fft, fs)
  [H, all_frqs] = freqz(tf.B, tf.A, n_fft, fs);
  [frqs, start_pos, end_pos] = limit_freqs(all_frqs, fq_lim);
  fq_resp.am = abs(H(start_pos:end_pos));
  fq_resp.ph = angle(H(start_pos:end_pos));

  fft_bin = fs / n_fft;
  gd = -diff(unwrap(angle(H))) / (fft_bin * 2 * pi);
  fq_resp.gd = gd(start_pos:end_pos - 1);
endfunction
