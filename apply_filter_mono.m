function apply_filter_mono (stim_file, tf, fs, resp_file)
  [stim_wave, s_rate] = audioread(stim_file);
  if (columns(stim_wave) != 1)
    error("stimulus file must be mono");
  endif
  if (s_rate != fs)
    error("stimulus file sampling rate %d != filter sampling rate %d", s_rate, fs);
  endif
  resp_wave = filter(tf.B, tf.A, stim_wave);
  audiowrite(resp_file, resp_wave, fs);
endfunction
