# ssh -T dockerusr@donkey-sim.roboticist.dev -p 22222 -- -c start_container -t 0.1 -r "'. /opt/conda/etc/profile.d/conda.sh ; conda activate donkey; make sgy2_remote'"
ssh -i "~/.ssh/donkeysim_race.pub" -T dockerusr@donkey-sim.roboticist.dev -p 22222 -- -c start_container -t Jan0.1 -r "'make test_run_for_vdr'"
