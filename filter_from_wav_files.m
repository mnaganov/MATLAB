function [freqs, fq_lim, fq_resp_plot] = filter_from_wav_files (fq_lim, stim_file, resp_file, gd_smoothing)
  [freqs, fq_resp] = analyze_filter(fq_lim, stim_file, resp_file, gd_smoothing);
  fq_resp_plot.l = channel_for_plot(fq_resp.l);
  fq_resp_plot.r = channel_for_plot(fq_resp.r);
endfunction

function chan_fq_resp_plot = channel_for_plot (chan_fq_resp)
  chan_fq_resp_plot.am_db = to_db(chan_fq_resp.am);
  chan_fq_resp_plot.ph_deg = to_deg(chan_fq_resp.ph);
  chan_fq_resp_plot.gd_us = to_us(chan_fq_resp.gd);
endfunction

function in_db = to_db (ampls)
  in_db = 20 * log10(ampls);
endfunction

function in_deg = to_deg (rads)
  in_deg = rads .* (180 / pi);
endfunction

function in_us = to_us (sec)
  in_us = sec * 1000000;
endfunction
