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
# Hirohaku
TRIM_FAST_LAP_MASK = save_data/hirohaku/fast0_0.trim_mask_done save_data/hirohaku/fast0_1.trim_mask_done save_data/hirohaku/fast0_2.trim_mask_done save_data/hirohaku/fast0_3.trim_mask_done save_data/hirohaku/fast0_4.trim_mask_done save_data/hirohaku/first_lap0.trim_mask_done
TRIM_MASK_FAST0_LAP_1ST = $(TRIM_FAST_LAP_MASK)

#Trim
# Hirohaku
FAST0 = save_data/hirohaku/fast0_0.trim_done save_data/hirohaku/fast0_1.trim_done save_data/hirohaku/fast0_2.trim_done save_data/hirohaku/fast0_3.trim_done save_data/hirohaku/fast0_4.trim_done
LAP1ST = save_data/hirohaku/first_lap0.trim_done
MSER_FAST_LAP = save_data/hirohaku/mserfast0_0.trim_done save_data/hirohaku/mserfast0_1.trim_done save_data/hirohaku/mserfast0_2.trim_done save_data/hirohaku/mserfast0_3.trim_done save_data/hirohaku/mserfast0_4.trim_done save_data/hirohaku/mserfirst_lap0.trim_done

TRM_FAST0 = $(FAST0)
TRM_LAP1ST = $(LAP1ST)
ALTER_NORMAL = $(FAST0) $(LAP1ST)
ALTER_MSER = $(MSER_FAST_LAP)

#Mask
MSK_EXAMPLE = data/Example_data.mask_done
MSK_ALL = $(MSK_EXAMPLE)

#Call Data 
HIROHAKU_SAVE_DATA = $(shell find save_data/hirohaku -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')
SGY_DATA = $(shell find save_data/sugasin2813 -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')
#DATA = $(shell find data/ -type d | grep -v "images" | sed -e '1d' | tr '\n' ' ')

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
trim_mask: $(TRIM_MASK_FAST0_LAP_1ST)

# Create Model
# Hirohaku
#### make trm_fast0
models/fast0_linear.h5: $(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/fast0_rnn2.h5: $(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

models/fast0_rnn4.h5: $(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku4_cfg.py

#### make trim_Anormal
models/alter_normal_linear.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/alter_normal_rnn2.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

#### make trim_Amser
models/alter_mser_linear.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/alter_mser_rnn2.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

#### make trim_Amser; make trim_Anormal
models/alter_normal_mser_linear.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/alter_normal_mser_rnn2.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

#### make trim_mask; make trim_Anormal 
models/alter_normalmask_linear.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/hirohaku2_cfg.py

models/alter_normalmask_rnn2.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku2_cfg.py

models/alter_normalmask_rnn4.h5:$(HIROHAKU_SAVE_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=rnn --config=cfgs/hirohaku4_cfg.py

# ---------------------------------------------------------
# Kusaryodx

linear_fast1_train: models/linear_fast1.h5
	make models/linear_fast1.h5

models/linear_fast1.h5:
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=save_data/kusaryodx/fastdata1,save_data/kusaryodx/fastdata2 --model=$@ --type=linear --config=cfgs/kuro_myconfig_10Hz.py

# ---------------------------------------------------------
# Sugasin2813
sgy_test_train: models/sgy_model.h5
	make models/sgy_model.h5

models/sgy_model.h5: $(SGY_DATA)
	TF_FORCE_GPU_ALLOW_GROWTH=true donkey train --tub=$(subst $(SPACE),$(COMMA),$^) --model=$@ --type=linear --config=cfgs/myconfig_10Hz_sugaya.py

# Autonomous Driving using .h5 File
# Race Command

# Hirohaku
fast0_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

fast0_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

fast0_rnn4:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku4.py

alter_normal_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normal_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_mser_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_mser_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normal_mser_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normal_mser_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normalmask_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normalmask_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_normalmask_rnn4:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku4.py

alter_fast0_linear:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

alter_fast0_rnn2:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=rnn --myconfig=cfgs/race_40Hz_hirohaku2.py

fast_lap:
	$(PYTHON) manage.py drive --model=save_model/hirohaku/$@.h5 --type=linear --myconfig=cfgs/race_40Hz_hirohaku2.py

# ---------------------------------------------------------
# Huang

huang:
	$(PYTHON) manage.py drive --model=save_model/huang/huang_stable.h5 --type=linear --myconfig=cfgs/huang_myconfig_10Hz.py

# ---------------------------------------------------------
# Kusaryodx

kusaryodx:
	$(PYTHON) manage.py drive --model=save_model/kusaryodx/linear_fast1.h5 --type=linear --myconfig=cfgs/kuro_myconfig_10Hz.py

# ---------------------------------------------------------
# Sugasin2813


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
