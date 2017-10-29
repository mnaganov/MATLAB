function fig = plot_filter (frqs, fq_lim, fq_resp, am_limits_db, gd_limits_us)
  fig = figure;

  subplot(3, 1, 1);
  semilogx(frqs, fq_resp.l.am_db, 'b', frqs, fq_resp.r.am_db, 'r');
  grid on;
  ylabel('dB');
  xlim(fq_lim);
  if (nargin >= 4 && length(am_limits_db) == 2)
    ylim(am_limits_db);
  end
  title('Amplitude response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 2);
  semilogx(frqs, fq_resp.l.ph_deg, 'b', frqs, fq_resp.r.ph_deg, 'r');
  grid on;
  ylabel('deg');
  xlim(fq_lim);
  title('Phase response of the filter for direct (blue) and opposite (red) channels');

  subplot(3, 1, 3);
  semilogx(frqs(2:end), fq_resp.l.gd_us, 'b', frqs(2:end), fq_resp.r.gd_us, 'r');
  grid on;
  ylabel('{\mu}s');
  xlim(fq_lim);
  if (nargin == 5 && length(gd_limits_us) == 2)
    ylim(gd_limits_us);
  end
  title('Group delay of the filter for direct (blue) and opposite (red) channels');
end
