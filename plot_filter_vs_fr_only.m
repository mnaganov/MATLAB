function plot_filter_vs_fr_only (fq_lim, name1, frqs1, fq_resp1, name2, frqs2, fq_resp2)
  figure;

  attn1 = fq_resp1.l.am_db(1);
  fq_resp1.l.am_db = fq_resp1.l.am_db - attn1;
  fq_resp1.r.am_db = fq_resp1.r.am_db - attn1;
  attn2 = fq_resp2.l.am_db(1);
  fq_resp2.l.am_db = fq_resp2.l.am_db - attn2;
  fq_resp2.r.am_db = fq_resp2.r.am_db - attn2;

  semilogx(frqs1, fq_resp1.l.am_db, 'b', frqs1, fq_resp1.r.am_db, 'r', ...
           frqs2, fq_resp2.l.am_db, 'c', frqs2, fq_resp2.r.am_db, 'm');
  grid on;
  ylabel('dB');
  xlim(fq_lim);
  title(['Comparison of AR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);
end
