function [resp_wave, out_st] = apply_binaural_filter (stim_wave_lr, tf, in_st)
  pre_attn = 1.0;
  if (any(strcmp(fieldnames(tf), 'pre_am_attn_db')))
    pre_attn = from_db(-tf.pre_am_attn_db);
  end
  stim_wave_l = stim_wave_lr(:, 1) .* pre_attn;
  stim_wave_r = stim_wave_lr(:, 2) .* pre_attn;
  opposite_attn = 1.0;
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    opposite_attn = from_db(-tf.r.am_attn_db);
  end
  if nargin < 3 | isempty(in_st)
    in_st.ld = [];
    in_st.lo = [];
    in_st.rd = [];
    in_st.ro = [];
  end
  [resp_wave_ld, out_st.ld] = filter(tf.l.B, tf.l.A, stim_wave_l, in_st.ld);
  [resp_wave_lo, out_st.lo] = filter(tf.r.B, tf.r.A, stim_wave_r, in_st.lo);
  [resp_wave_rd, out_st.rd] = filter(tf.l.B, tf.l.A, stim_wave_r, in_st.rd);
  [resp_wave_ro, out_st.ro] = filter(tf.r.B, tf.r.A, stim_wave_l, in_st.ro);
  resp_wave(:, 1) = resp_wave_ld + resp_wave_lo .* opposite_attn;
  resp_wave(:, 2) = resp_wave_rd + resp_wave_ro .* opposite_attn;
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end
