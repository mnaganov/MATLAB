function plot_filter_vs (start_fq, end_fq, name1, freqs1, fq_resp1, name2, freqs2, fq_resp2, gd_scale_us)
  figure;

  attn1 = fq_resp1.l.am_db(1);
  fq_resp1.l.am_db = fq_resp1.l.am_db - attn1;
  fq_resp1.r.am_db = fq_resp1.r.am_db - attn1;
  attn2 = fq_resp2.l.am_db(1);
  fq_resp2.l.am_db = fq_resp2.l.am_db - attn2;
  fq_resp2.r.am_db = fq_resp2.r.am_db - attn2;

  subplot(3, 1, 1);
  semilogx(freqs1, fq_resp1.l.am_db, 'b', freqs1, fq_resp1.r.am_db, 'r',
           freqs2, fq_resp2.l.am_db, 'c', freqs2, fq_resp2.r.am_db, 'm');
  grid on;
  ylabel('dB');
  xlim([start_fq, end_fq]);
  title(['Comparison of AR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 2);
  semilogx(freqs1, fq_resp1.l.ph_deg, 'b', freqs1, fq_resp1.r.ph_deg, 'r',
           freqs2, fq_resp2.l.ph_deg, 'c', freqs2, fq_resp2.r.ph_deg, 'm');
  grid on;
  ylabel('deg');
  xlim([start_fq, end_fq]);
  title(['Comparison of PR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 3);
  semilogx(freqs1(2:end), fq_resp1.l.gd_us, 'b', freqs1(2:end), fq_resp1.r.gd_us, 'r',
           freqs2(2:end), fq_resp2.l.gd_us, 'c', freqs2(2:end), fq_resp2.r.gd_us, 'm');
  grid on;
  ylabel('{\mu}s');
  xlim([start_fq, end_fq]);
  if length(gd_scale_us) == 2
    ylim(gd_scale_us);
  endif
  title(['Comparison of GD for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);
endfunction
