function [freqs, start_pos, end_pos] = limit_freqs(all_freqs, fq_lim)
  start_pos = find(all_freqs >= fq_lim(1), 1);
  end_pos = find(all_freqs >= fq_lim(2), 1);
  if (length(start_pos) == 0)
    error("start frequency %d is outside of possible frequences", fq_lim(1));
  endif
  if (length(end_pos) == 0)
    error("end frequency %d is outside of possible frequences", fq_lim(2));
  endif
  freqs = all_freqs(start_pos:end_pos);
endfunction
