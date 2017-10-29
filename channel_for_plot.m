function chan_fq_resp_plot = channel_for_plot (chan_fq_resp)
  chan_fq_resp_plot.am_db = to_db(chan_fq_resp.am);
  chan_fq_resp_plot.ph_deg = to_deg(chan_fq_resp.ph);
  chan_fq_resp_plot.gd_us = to_us(chan_fq_resp.gd);
end

function in_db = to_db (ampls)
  in_db = 20 * log10(ampls);
end

function in_deg = to_deg (rads)
  in_deg = rads .* (180 / pi);
end

function in_us = to_us (sec)
  in_us = sec * 1000000;
end
