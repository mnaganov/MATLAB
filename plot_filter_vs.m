function plot_filter_vs (start_fq, end_fq, name1, freqs1, l1_freq_resp_db, l1_phase_resp_deg, l1_gd_us, r1_freq_resp_db, r1_phase_resp_deg, r1_gd_us, name2, freqs2, l2_freq_resp_db, l2_phase_resp_deg, l2_gd_us, r2_freq_resp_db, r2_phase_resp_deg, r2_gd_us, gd_scale_us)
  figure;

  attn1 = l1_freq_resp_db(1);
  l1_freq_resp_db = l1_freq_resp_db - attn1;
  r1_freq_resp_db = r1_freq_resp_db - attn1;
  attn2 = l2_freq_resp_db(1);
  l2_freq_resp_db = l2_freq_resp_db - attn2;
  r2_freq_resp_db = r2_freq_resp_db - attn2;

  subplot(3, 1, 1);
  semilogx(freqs1, l1_freq_resp_db, 'b', freqs1, r1_freq_resp_db, 'r',
           freqs2, l2_freq_resp_db, 'c', freqs2, r2_freq_resp_db, 'm');
  grid on;
  ylabel('dB');
  xlim([start_fq, end_fq]);
  title(['Comparison of AR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 2);
  semilogx(freqs1, l1_phase_resp_deg, 'b', freqs1, r1_phase_resp_deg, 'r',
           freqs2, l2_phase_resp_deg, 'c', freqs2, r2_phase_resp_deg, 'm');
  grid on;
  ylabel('deg');
  xlim([start_fq, end_fq]);
  title(['Comparison of PR for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);

  subplot(3, 1, 3);
  semilogx(freqs1(2:end), l1_gd_us, 'b', freqs1(2:end), r1_gd_us, 'r',
           freqs2(2:end), l2_gd_us, 'c', freqs2(2:end), r2_gd_us, 'm');
  grid on;
  ylabel('{\mu}s');
  xlim([start_fq, end_fq]);
  if length(gd_scale_us) == 2
    ylim(gd_scale_us);
  endif
  title(['Comparison of GD for filter ' name1 ' direct (blue), opposite (red)' ...
       ' vs. ' name2 ' direct (cyan), opposite (magenta)']);
endfunction
