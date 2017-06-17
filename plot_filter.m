function plot_filter (freqs, start_fq, end_fq, fq_resp, gd_scale_us)
  figure;

  subplot(3, 1, 1);
  semilogx(freqs, fq_resp.l.am_db, 'b', freqs, fq_resp.r.am_db, 'r');
  grid on;
  ylabel('dB');
  xlim([start_fq, end_fq]);
  title('Frequency response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 2);
  semilogx(freqs, fq_resp.l.ph_deg, 'b', freqs, fq_resp.r.ph_deg, 'r');
  grid on;
  ylabel('deg');
  xlim([start_fq, end_fq]);
  title('Phase response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 3);
  semilogx(freqs(2:end), fq_resp.l.gd_us, 'b', freqs(2:end), fq_resp.r.gd_us, 'r');
  grid on;
  ylabel('{\mu}s');
  xlim([start_fq, end_fq]);
  if length(gd_scale_us) == 2
    ylim(gd_scale_us);
  endif
  title('Group delay of the filter for direct (blue) and opposite (red) channels');
endfunction
