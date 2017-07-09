function [frqs, fq_lim, fq_resp_plot] = filter_from_wav_files (fq_lim, stim_file, resp_file, gd_smoothing)
  [frqs, fq_resp] = analyze_filter(fq_lim, stim_file, resp_file, gd_smoothing);
  fq_resp_plot.l = channel_for_plot(fq_resp.l);
  fq_resp_plot.r = channel_for_plot(fq_resp.r);
endfunction
