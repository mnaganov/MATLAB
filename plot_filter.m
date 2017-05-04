function plot_filter (freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us, gd_scale_us)
  figure;

  subplot(3, 1, 1);
  semilogx(freqs, l_freq_resp_db, 'b', freqs, r_freq_resp_db, 'r');
  grid on;
  ylabel('dB');
  xlim([start_fq, end_fq]);
  title('Frequency response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 2);
  semilogx(freqs, l_phase_resp_deg, 'b', freqs, r_phase_resp_deg, 'r');
  grid on;
  ylabel('deg');
  xlim([start_fq, end_fq]);
  title('Phase response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 3);
  semilogx(freqs(2:end), l_gd_us, 'b', freqs(2:end), r_gd_us, 'r');
  grid on;
  ylabel('{\mu}s');
  xlim([start_fq, end_fq]);
  if length(gd_scale_us) == 2
    ylim(gd_scale_us);
  endif
  title('Group delay of the filter for direct (blue) and opposite (red) channels');
endfunction
