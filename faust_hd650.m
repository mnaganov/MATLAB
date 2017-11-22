clear;
load(sound_data_dir('ph-iir/hd650.mat'));
generate_faust_filter(mdl_tf, sound_data_dir('ph-iir/hd650.dsp'));
