#
# This file referred from the "hogenimushi/vdc2020_race03" repository
#
## Definition Area #############################################################################################
PYTHON = python3
COMMA=,
EMPTY=
SPACE=$(EMPTY) $(EMPTY)
REMOVE = rm -rf

# Trim_Mask
TRIM_MASK = data/Example_data.trim_mask_done
TRIM_MASK_ALL = $(TRIM_MASK)

#Trim
TRM_EXAMPLE = data/Example_data.trim_done
FAST0 = data/fast0_0.trim_done data/fast0_1.trim_done data/fast0_2.trim_done data/fast0_3.trim_done data/fast0_4.trim_done
LAP1ST = data/first_lap0.trim_done
MSER_FAST_LAP = data/mserfast0_0.trim_done data/mserfast0_1.trim_done data/mserfast0_2.trim_done data/mserfast0_3.trim_done data/mserfast0_4.trim_done data/mserfirst_lap0.trim_done

TRM_FAST0 = $(FAST0)
TRM_LAP1ST = $(LAP1ST)
ALTER_NORMAL = $(FAST0) $(LAP1ST)
ALTER_MSER = $(MSER_FAST_LAP)

TRM_ALL = $(TRM_EXAMPLE)

#Mask
MSK_EXAMPLE = data/Example_data.mask_done
MSK_ALL = $(MSK_EXAMPLE)

#Call Data
SAVE_DATA = $(shell find save_data/ -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')
DATA = $(shell find data/ -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')

##################################################################################################################

## Command Area ##################################################################################################
none:
	@echo "Argument is required."

clean:
	$(REMOVE) models/*
	$(REMOVE) data/*

arrange:
	@echo "When using all driving data in "data", it finds some empty directories and removes them.\n" && \
	find data -type d -empty | sed 's/\/images/ /g' | xargs rm -rf 

install_sim:
	@echo "Install DonkeySim v21.12.11" && \
	wget -qO- https://github.com/tawnkramer/gym-donkeycar/releases/download/v21.12.11/DonkeySimLinux.zip | bsdtar -xvf - -C . && \
	chmod +x DonkeySimLinux/donkey_sim.x86_64

record: record40

record40:
	$(PYTHON) manage.py drive --js --myconfig=cfgs/hirohaku2_cfg.py

trim: $(TRM_FAST0) $(TRM_LAP1ST)
trm_fast0: $(TRM_FAST0)
trim_lap1st: $(TRM_LAP1ST)

trim_Anormal: $(ALTER_NORMAL)
trim_Amser:$(ALTER_MSER)

mask: $(MSK_ALL)
trim_mask: $(TRIM_MASK_ALL)

test_train: models/test.h5
	make models/test.h5

# Create Model
# DATAには整形(trim, mask)したデータを入れる。整形しないデータを使う場合はSAVE_DATAから呼び出す。
#models/test.h5: $(SAVE_DATA)$(DATA)
#	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz.py

models/test.h5: $(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/fast0_linear.h5: $(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/fast0_rnn2.h5: $(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

models/fast0_rnn4.h5: $(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku4_cfg.py

models/alter_normal_linear.h5:$(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/alter_normal_rnn2.h5:$(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

models/alter_mser_linear.h5:$(DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py


# Autonomous Driving using .h5 File
test_run:
	$(PYTHON) manage.py drive --model=models/test.h5 --type=linear --myconfig=cfgs/hirohaku_cfg.py

linear:
	$(PYTHON) manage.py drive --model=save_model/fast0_linear.h5 --type=linear --myconfig=cfgs/hirohaku2_cfg.py

rnn2:
	$(PYTHON) manage.py drive --model=save_model/fast0_rnn2.h5 --type=rnn --myconfig=cfgs/hirohaku2_cfg.py

rnn4:
	$(PYTHON) manage.py drive --model=save_model/fast0_rnn4.h5 --type=rnn --myconfig=cfgs/hirohaku4_cfg.py

###############################################################################
# Input files to Docker Team_ahoy_racer directory####################################################################
docker:
	@echo Create contents which include in docker image
	mkdir -p Docker/Team_ahoy_racer && \
	cp -r cfgs/ Docker/Team_ahoy_racer/ && \
	cp -r save_model/ Docker/Team_ahoy_racer/save_model/ && \
	cp config.py Docker/Team_ahoy_racer/config.py && \
	cp manage.py Docker/Team_ahoy_racer/manage.py && \
	cp Makefile Docker/Team_ahoy_racer/Makefile && \
	mkdir -p Docker/Team_ahoy_racer/models && \
	mkdir -p Docker/Team_ahoy_racer/data

######################################################################################################################

## SAPHIX RULE APPLY AREA ##############################################################################################
# PHONY
.PHONY: .trim_mask_done #trimとmaskを行う　上のDefinition Areaで.trim_mask_doneをつけると下の関数が呼ばれる。
#下の関数を使うためには、save_data内に.trim_maskのファイルが必要である。
data/%.trim_mask_done: save_data/%.trim_mask
	$(PYTHON) scripts/image_mask.py --input=$(subst .trim_mask,$(EMPTY),$<) --output=$@
	$(PYTHON) scripts/multi_trim.py --input=$@ --output $@ --file $<
	$(REMOVE) $@

.PHONY: .trim_done #trimのみ行う。 上のDefinition Areaで.trim_doneをつけると下の関数が呼ばれる。
#下の関数を使うためには、save_data内に.trimのファイルが必要である。
data/%.trim_done: save_data/%.trim
	$(PYTHON) scripts/multi_trim.py --input=$(subst .trim,$(EMPTY),$<) --output $@ --file $< --onefile

.PHONY: .mask_done #maskのみ行う。上のDefinition Areaで.mask_doneをつけると下の関数が呼ばれる。
data/%.mask_done: save_data/%
	$(PYTHON) scripts/image_mask.py --input=$< --output=$@
#####################################################################################################################
