function [frqs, fq_resp] = analyze_filter (fq_lim, stim_file, resp_file, gd_smoothing)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  [resp_wave_lr, resp_sr] = audioread(resp_file);

  if (s_rate ~= resp_sr)
    error("stimulus file sampling rate %d ~= response sampling rate %d", s_rate, resp_sr);
  end
  if (length(stim_wave_lr) ~= length(resp_wave_lr))
    error("stimulus file length %d ~= response length %d", length(stim_wave_lr), length(resp_wave_lr));
  end

  if (columns(stim_wave_lr) == 1)
    stim_wave = stim_wave_lr;
  elseif (columns(stim_wave_lr) == 2)
    % Left channel is used from the stimulus file
    stim_wave = stim_wave_lr(:, 1);
  else
    error("stimulus file has unsupported number of channels %d", columns(stim_wave_lr));
  end
  if (columns(resp_wave_lr) ~= 2)
    error("response file must be stereo");
  end
  l_resp_wave = resp_wave_lr(:, 1);
  r_resp_wave = resp_wave_lr(:, 2);

  l = length(stim_wave);
  l2 = round(l / 2);
  fft_bin = s_rate / l;
  % We need to use the first l/2 bins that correspond to frequencies from 0 to s_rate / 2
  [frqs, start_pos, end_pos] = limit_freqs((0:l2 - 1)' * fft_bin, fq_lim);

  fft_stim_wave = fft(stim_wave);
  fq_resp.l = analyze_channel(start_pos, end_pos, fft_bin, fft_stim_wave, l_resp_wave, gd_smoothing);
  fq_resp.r = analyze_channel(start_pos, end_pos, fft_bin, fft_stim_wave, r_resp_wave, gd_smoothing);
end

function chan_fq_resp = analyze_channel (start_pos, end_pos, fft_bin, fft_stim_wave, resp_wave, gd_smoothing)
  fft_resp_wave = fft(resp_wave);
  fft_filter = fft_resp_wave ./ fft_stim_wave;
  chan_fq_resp.am = abs(fft_filter(start_pos:end_pos));
  chan_fq_resp.ph = angle(fft_filter(start_pos:end_pos));

  sm_phase_resp = smoothen(unwrap(angle(fft_filter)), 100, gd_smoothing);
  gd = -diff(sm_phase_resp) / (fft_bin * 2 * pi);
  chan_fq_resp.gd = gd(start_pos:end_pos - 1);
end
