function [freqs, fq_resp] = freqz_and_gd (fq_lim, tf, n_fft, fs)
  [fq_resp.l, freqs] = channel_freqz_and_gd(fq_lim, tf.l.B, tf.l.A, n_fft, fs);
  [fq_resp.r, _] = channel_freqz_and_gd(fq_lim, tf.r.B, tf.r.A, n_fft, fs);
endfunction

function [chan_fq_resp, freqs] = channel_freqz_and_gd(fq_lim, B, A, n_fft, fs)
  [H, all_freqs] = freqz(B, A, n_fft, fs);
  [freqs, start_pos, end_pos] = limit_freqs(all_freqs, fq_lim);
  chan_fq_resp.am = abs(H(start_pos:end_pos));
  chan_fq_resp.ph = angle(H(start_pos:end_pos));

  fft_bin = fs / n_fft;
  gd = -diff(unwrap(angle(H))) / (fft_bin * 2 * pi);
  chan_fq_resp.gd = gd(start_pos:end_pos - 1);
endfunction
