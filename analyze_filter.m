function [freqs, l_freq_resp, l_phase_resp, l_gd_us, r_freq_resp, r_phase_resp, r_gd_us] = analyze_filter (start_fq, end_fq, stim_file, resp_file, gd_smoothing)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  [resp_wave_lr, resp_sr] = audioread(resp_file);

  if (s_rate != resp_sr)
    error("stimulus file sampling rate %d != response sampling rate %d", s_rate, resp_sr);
  endif
  if (length(stim_wave_lr) != length(resp_wave_lr))
    error("stimulus file length %d != response length %d", length(stim_wave_lr), length(resp_wave_lr));
  endif

  if (columns(stim_wave_lr) == 1)
    stim_wave = stim_wave_lr;
  elseif (columns(stim_wave_lr) == 2)
    % Left channel is used from the stimulus file
    stim_wave = stim_wave_lr(:, 1);
  else
    error("stimulus file has unsupported number of channels %d", columns(stim_wave_lr));
  endif
  if (columns(resp_wave_lr) != 2)
    error("response file must be stereo");
  endif
  l_resp_wave = resp_wave_lr(:, 1);
  r_resp_wave = resp_wave_lr(:, 2);

  l = length(stim_wave);
  l2 = round(l / 2);
  fft_bin = s_rate / l;

  % We need to use the first l/2 bins that correspond to frequencies from 0 to s_rate / 2
  all_freqs = (0:l2 - 1)' * fft_bin;
  start_pos = find(all_freqs >= start_fq, 1);
  end_pos = find(all_freqs >= end_fq, 1);
  if (length(start_pos) == 0)
    error("start frequency %d is outside of possible frequences", start_fq);
  endif
  if (length(end_pos) == 0)
    error("end frequency %d is outside of possible frequences", end_fq);
  endif
  freqs = all_freqs(start_pos:end_pos);

  fft_stim_wave = fft(stim_wave);
  [l_freq_resp, l_phase_resp, l_gd_us] = analyze_channel(start_pos, end_pos, fft_bin, fft_stim_wave, l_resp_wave, gd_smoothing);
  [r_freq_resp, r_phase_resp, r_gd_us] = analyze_channel(start_pos, end_pos, fft_bin, fft_stim_wave, r_resp_wave, gd_smoothing);
endfunction

function [freq_resp, phase_resp, gd_us] = analyze_channel (start_pos, end_pos, fft_bin, fft_stim_wave, resp_wave, gd_smoothing)
  fft_resp_wave = fft(resp_wave);
  fft_filter = fft_resp_wave ./ fft_stim_wave;
  freq_resp = abs(fft_filter(start_pos:end_pos));
  phase_resp = angle(fft_filter(start_pos:end_pos));

  sm_phase_resp = unwrap(angle(fft_filter));
  for i = 1:gd_smoothing
    sm_phase_resp = conv(sm_phase_resp, [1, 2, 1] / 4, 'same');
  end;

  gd = -diff(sm_phase_resp) / (fft_bin * 2 * pi);
  gd_us = gd(start_pos:end_pos - 1) * 1000000;
endfunction
