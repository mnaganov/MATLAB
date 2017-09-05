function plot_mono_filter_vs (fq_lim, name1, frqs1, fq_resp1, name2, frqs2, fq_resp2, gd_limits_us)
  figure;

  attn1 = fq_resp1.am_db(1);
  fq_resp1.am_db = fq_resp1.am_db - attn1;
  attn2 = fq_resp2.am_db(1);
  fq_resp2.am_db = fq_resp2.am_db - attn2;

  subplot(3, 1, 1);
  semilogx(frqs1, fq_resp1.am_db, 'b', frqs2, fq_resp2.am_db, 'c');
  grid on;
  ylabel('dB');
  xlim(fq_lim);
  title(['Comparison of AR for filter ' name1 ' (blue) vs. ' name2 ' (cyan)']);

  subplot(3, 1, 2);
  semilogx(frqs1, fq_resp1.ph_deg, 'b', frqs2, fq_resp2.ph_deg, 'c');
  grid on;
  ylabel('deg');
  xlim(fq_lim);
  title(['Comparison of PR for filter ' name1 ' (blue) vs. ' name2 ' (cyan)']);

  subplot(3, 1, 3);
  semilogx(frqs1(2:end), fq_resp1.gd_us, 'b', frqs2(2:end), fq_resp2.gd_us, 'c');
  grid on;
  ylabel('{\mu}s');
  xlim(fq_lim);
  if (nargin == 8 && length(gd_limits_us) == 2)
    ylim(gd_limits_us);
  endif
  title(['Comparison of GD for filter ' name1 ' (blue) vs. ' name2 ' (cyan)']);
endfunction
