  * **analyze_filter**: stimulus wave, response wave -> linear FR, GD
  * **apply_binaural_filter**: stimulus wave, transfer function -> response wave
  * **channel_for_plot**: linear FR, GD -> db, deg FR, us GD (for one channel)
  * **compute_fir_filter**: log FR -> transfer function (FIR)
  * **compute_iir_filter**: log FR -> transfer function (IIR)
  * **filter_from_log_csv_file**: db, deg csv of FR  -> db, deg FR, GD
  * **filter_from_tf**: transfer function -> db, deg FR, GD
  * **filter_from_two_log_csv_files**: db, deg csv of FR L, csv of FR R -> db, deg FR, GD
  * **filter_from_wav_files**: stimulus wave, response wave -> db, deg FR, GD
  * **fir_tf_from_log_csv_file**: db, deg csv of FR -> transfer function (FIR)
  * **freqz_and_gd**: transfer function -> linear FR, GD
  * **plot_filter**: plot from FR, GD
  * **plot_filter_from_log_csv_file**: plot from db, deg csv of FR
  * **plot_filter_from_tf**: plot from transfer function
  * **plot_filter_from_two_log_csv_files**: plot from db, deg csv of FR L, csv of FR R
  * **plot_filter_from_wav_files**: plot from stimulus wave, response wave L, response wave R
  * **plot_filter_vs**: plot 2 filters from db, deg FR, GD
  * **tf_from_two_log_csv_files**: db, deg csv of FR L, csv of FR R -> transfer function (IIR)
  * **transform_log_data**: log freqs, db, deg FR  -> db, deg FR, GD

# Unfinished

  * **apply_filter**

# TODO

  * fast smoothing
