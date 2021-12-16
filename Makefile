#
# This file referred from the "hogenimushi/vdc2020_race03" repository
#

PYTHON = python3
COMMA=,
EMPTY=
SPACE=$(EMPTY) $(EMPTY)

#Trim
TRM_EXAMPLE = data/Example_data.trimmed
TRM_ALL = $(TRM_EXAMPLE)

#Mask
MSK_EXAMPLE = data/Example_data.trimmed.masked1
MSK_ALL = $(MSK_EXAMPLE)


#Call Data
DATASET = $(shell find data/ -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')
STABLE_DATA = $(shell find save_data/stable\&short_* -type d | grep -v "images" | tr '\n' ' ')
STABLE_LAP = $(shell find save_date/stable_lap_* -type d | grep -v "images" | tr '\n' ' ')
none:
	@echo "Argument is required."

clean:
	rm -rf models/*
	rm -rf data/*

arrange:
	@echo "When using all driving data in "data", it finds some empty directories and removes them.\n" && \
	find data -type d -empty | sed 's/\/images/ /g' | xargs rm -rf 

install_sim:
	@echo "Install DonkeySim v21.04.15" && \
	wget -qO- https://github.com/tawnkramer/gym-donkeycar/releases/download/v21.07.24/DonkeySimLinux.zip | bsdtar -xvf - -C . && \
	chmod +x DonkeySimLinux/donkey_sim.x86_64

record: record10

record10:
	$(PYTHON) manage.py drive --js --myconfig=cfgs/myconfig_10Hz.py

# Tutorial
dataset: $(TRM_ALL)

mask: $(MSK_ALL)

test_run:
	$(PYTHON) manage.py drive --model=models/test.h5 --type=linear --myconfig=cfgs/myconfig_10Hz.py

test_train: models/test.h5
	make models/test.h5

models/test.h5: $(DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz.py

# Model
models/linear_stable.h5: $(STABLE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz.py

models/rnn2_stable.h5: $(STABLE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/myconfig_10Hz_rnn2.py

models/rnn3_stable.h5: $(STABLE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/ myconfig_10Hz_rnn3.py

models/categorical_stable.h5: $(STABLE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=categorical --config=cfgs/myconfig_10Hz_categorical.py

models/7_stable_laps_RNN3.h5: $(STABLE_LAP)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/ myconfig_10Hz_rnn3.py

.PHONY: .trimmed
data/%.trimmed: save_data/%.trim
	$(PYTHON) scripts/multi_trim.py --input=$(subst .trim,$(EMPTY),$<) --output $@ --file $< --onefile

# apply a mask to the file itself
data/%.masked1: data/%
	$(PYTHON) scripts/image_mask.py $(subst .masked1,$(EMPTY),$<) 
	mv $(subst .masked1,$(EMPTY),$<) $@

#data/%.masked2: data/%
#	$(PYTHON) scripts/image_mask.py $(subst .masked2,$(EMPTY),$<) $@ 

# make a new masked files
data/%.masked2: save_data/%
	$(PYTHON) scripts/image_mask.py $(subst .masked2,$(EMPTY),$<) $@ 
