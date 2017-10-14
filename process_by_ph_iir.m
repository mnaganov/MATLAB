load(sound_data_dir('ph-iir/m-30-1_2-left.mat'));

## apply_binaural_filter(
##     sound_data_dir('impulse-44-32-both.wav'),
##     mdl_tf, 44100,
##     sound_data_dir('ph-iir/m-30-1_2-both-fs.wav'));

apply_binaural_filter(
    '/Users/mikhail/Sounds/PerfectSense_44_1.wav',
    mdl_tf, 44100,
    '/Users/mikhail/Sounds/PerfectSense_44_1-IIR.wav');
