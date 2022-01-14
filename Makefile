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
SGY_DATA = $(shell find save_data/ -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')

none:
	@echo "Argument is required."

copy:
	mv data/sgy_data* save_data/

clean:
	rm -rf models/*
	rm -rf data/*

arrange:
	@echo "When using all driving data in "data", it finds some empty directories and removes them.\n" && \
	find data -type d -empty | sed 's/\/images/ /g' | xargs rm -rf 

install_sim:
	@echo "Install DonkeySim v21.12.11" && \
		wget -qO- https://github.com/tawnkramer/gym-donkeycar/releases/download/v21.12.11/DonkeySimLinux.zip | bsdtar -xvf - -C . && \
	chmod +x DonkeySimLinux/donkey_sim.x86_64

record: record10

record10:
	$(PYTHON) manage.py drive --js --myconfig=cfgs/myconfig_10Hz_sugaya.py

# Tutorial
dataset: $(TRM_ALL)

mask: $(MSK_ALL)

test_run:
	$(PYTHON) manage.py drive --model=save_model/sgy_model.h5 --type=linear --myconfig=cfgs/remote_10Hz.py

sgy_model_test_run:
	$(PYTHON) manage.py drive --model=save_model/sgy_model.h5 --type=linear --myconfig=cfgs/myconfig_10Hz_sugaya.py

test_train: models/test.h5
	make models/test.h5

sgy_test_train: models/sgy_model.h5
	make models/sgy_model.h5

models/test.h5: $(DATASET)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz_sugaya.py

models/sgy_model.h5: $(SGY_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz_sugaya.py

###############################################################################
# Input files to Docker Team_ahoy_racer directory####################################################################
docker:
	@echo Create contents which include in docker image
	mkdir -p Docker/Team_ahoy_racer && \
	cp -r cfgs/ Docker/Team_ahoy_racer/cfgs/ && \
	cp -r save_model/ Docker/Team_ahoy_racer/save_model/ && \
	cp config.py Docker/Team_ahoy_racer/config.py && \
	cp manage.py Docker/Team_ahoy_racer/manage.py && \
	cp Makefile Docker/Team_ahoy_racer/Makefile && \
	mkdir -p Docker/Team_ahoy_racer/models && \
	mkdir -p Docker/Team_ahoy_racer/data

######################################################################################################################

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
