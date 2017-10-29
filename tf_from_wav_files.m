function [tf, n_fft, fs] = tf_from_wav_files (fq_lim, stim_file, resp_file, smoothing, n_fft, n_poles, n_zeroes)
  [frqs, fq_lim, fq_resp] = filter_from_wav_files(fq_lim, stim_file, resp_file, 0);
  [ign_, fs] = audioread(stim_file);
  [tf.l.B, tf.l.A] = compute_iir_filter(
                         frqs.', smoothen(fq_resp.l.am_db, 50, smoothing).',
                         n_fft, fs, n_poles, n_zeroes);
  [tf.r.B, tf.r.A] = compute_iir_filter(
                         frqs.', smoothen(fq_resp.r.am_db, 50, smoothing).',
                         n_fft, fs, n_poles, n_zeroes);
  tf.r.am_attn_db = fq_resp.l.am_db(1) - fq_resp.r.am_db(1, 2);
end
