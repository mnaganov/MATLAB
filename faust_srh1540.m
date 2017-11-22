clear;
load(sound_data_dir('ph-iir/srh1540.mat'));
generate_faust_filter(mdl_tf, sound_data_dir('ph-iir/srh1540.dsp'));
