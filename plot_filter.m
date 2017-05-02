function plot_filter (freqs, start_fq, end_fq, l_freq_resp, l_phase_resp, l_gd, r_freq_resp, r_phase_resp, r_gd, gd_scale)
  figure;

  subplot(3, 1, 1);
  semilogx(freqs, 20 * log10(l_freq_resp), 'b', freqs, 20 * log10(r_freq_resp), 'r');
  grid on;
  ylabel('dB');
  xlim([start_fq, end_fq]);
  title('Frequency response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 2);
  semilogx(freqs, l_phase_resp .* (180 / pi), 'b', freqs, r_phase_resp .* (180 / pi), 'r');
  grid on;
  ylabel('deg');
  xlim([start_fq, end_fq]);
  title('Phase response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 3);
  semilogx(freqs(2:end), l_gd * 1000000, 'b', freqs(2:end), r_gd * 1000000, 'r');
  grid on;
  ylabel('{\mu}s');
  xlim([start_fq, end_fq]);
  if length(gd_scale) == 2
    ylim(gd_scale);
  endif
  title('Group delay of the filter for direct (blue) and opposite (red) channels');
endfunction
