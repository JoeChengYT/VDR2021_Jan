ssh -T dockerusr@donkey-sim.roboticist.dev -p 22222 -- -c start_container -t 0.1 -r "'. /opt/conda/etc/profile.d/conda.sh ; conda activate donkey; make sgy2_remote'"
