function [frqs, fq_resp] = freqz_and_gd (fq_lim, tf, n_fft, fs)
  [fq_resp.l, frqs] = channel_freqz_and_gd(fq_lim, tf.l.B, tf.l.A, n_fft, fs);
  [fq_resp.r, ~] = channel_freqz_and_gd(fq_lim, tf.r.B, tf.r.A, n_fft, fs);
end

function [chan_fq_resp, frqs] = channel_freqz_and_gd(fq_lim, B, A, n_fft, fs)
  [H, all_frqs] = freqz(B, A, n_fft, fs);
  [frqs, start_pos, end_pos] = limit_freqs(all_frqs, fq_lim);
  chan_fq_resp.am = abs(H(start_pos:end_pos));
  chan_fq_resp.ph = angle(H(start_pos:end_pos));

  fft_bin = fs / n_fft;
  gd = -diff(unwrap(angle(H))) / (fft_bin * 2 * pi);
  chan_fq_resp.gd = gd(start_pos:end_pos - 1);
end
