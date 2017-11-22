clear;
load(sound_data_dir('ph-iir/m-30-1_2-left.m7.mat'));
generate_nyquist_prompt_filter_binaural(mdl_tf, sound_data_dir('ph-iir/m-30-1_2-left.mat.ny'));
