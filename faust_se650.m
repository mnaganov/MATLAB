clear;
load(sound_data_dir('ph-iir/se650.mat'));
generate_faust_filter(mdl_tf, sound_data_dir('ph-iir/se650.dsp'));
