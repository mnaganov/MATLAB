function plot_filter_vs (fq_lim, name1, frqs1, fq_resp1, name2, frqs2, fq_resp2, gd_limits_us)
  figure;

  attn1 = fq_resp1.l.am_db(1);
  fq_resp1.l.am_db = fq_resp1.l.am_db - attn1;
  fq_resp1.r.am_db = fq_resp1.r.am_db - attn1;
  attn2 = fq_resp2.l.am_db(1);
  fq_resp2.l.am_db = fq_resp2.l.am_db - attn2;
  fq_resp2.r.am_db = fq_resp2.r.am_db - attn2;

  subplot(3, 1, 1);
  semilogx(frqs1, fq_resp1.l.am_db, 'b', frqs1, fq_resp1.r.am_db, 'r',
           frqs2, fq_resp2.l.am_db, 'c', frqs2, fq_resp2.r.am_db, 'm');
  grid on;
  ylabel('dB');
  xlim(fq_lim);
  title(['Comparison of AR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 2);
  semilogx(frqs1, fq_resp1.l.ph_deg, 'b', frqs1, fq_resp1.r.ph_deg, 'r',
           frqs2, fq_resp2.l.ph_deg, 'c', frqs2, fq_resp2.r.ph_deg, 'm');
  grid on;
  ylabel('deg');
  xlim(fq_lim);
  title(['Comparison of PR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 3);
  semilogx(frqs1(2:end), fq_resp1.l.gd_us, 'b', frqs1(2:end), fq_resp1.r.gd_us, 'r',
           frqs2(2:end), fq_resp2.l.gd_us, 'c', frqs2(2:end), fq_resp2.r.gd_us, 'm');
  grid on;
  ylabel('{\mu}s');
  xlim(fq_lim);
  if (nargin == 8 && length(gd_limits_us) == 2)
    ylim(gd_limits_us);
  end
  title(['Comparison of GD for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);
end
