""" 
# My CAR CONFIG 

# This file is read by your car application's manage.py script to change the car
# performance

# If desired, all config OVERRIDES can be specified here. 
# The update operation will not touch this file.
# """

#PATHS
MODELS_PATH = '.'

#CAMERA
IMAGE_W = 160
IMAGE_H = 120
IMAGE_DEPTH = 3         # default RGB=3, make 1 for mono

#VEHICLE
DRIVE_LOOP_HZ = 10

#JOYSTICK
USE_JOYSTICK_AS_DEFAULT = False
CONTROLLER_TYPE ='F710'
JOYSTICK_MAX_THROTTLE = 1.0
JOYSTICK_STEERING_SCALE = 1.0
MODEL_CATEGORICAL_MAX_THROTTLE_RANGE = JOYSTICK_MAX_THROTTLE

#DonkeyGym
DONKEY_GYM = True
DONKEY_SIM_PATH = "remote"
SIM_HOST = "donkey-sim.roboticist.dev"

DONKEY_GYM_ENV_NAME = "donkey-circuit-launch-track-v0" 
GYM_CONF = { "body_style" : "donkey", "body_rgb" : (230, 0, 50), "car_name" : "Ahoy!", "font_size" : 18} # body style(donkey|bare|car01) body rgb 0-255

GYM_CONF["racer_name"] = "hirohaku"
GYM_CONF["country"] = "JP"
GYM_CONF["bio"] = "HELLO"

SIM_ARTIFICIAL_LATENCY = 0

#WEB CONTROL
WEB_CONTROL_PORT = 8887 
WEB_INIT_MODE = "user"   # or user

#TRAINING
DEFAULT_AI_FRAMEWORK = 'tensorflow'
BATCH_SIZE = 128           #how many records to use when doing one pass of gradient decent. Use a smaller number if your gpu is running out of memory.
TRAIN_TEST_SPLIT = 0.8     #what percent of records to use for training. the remaining used for validation.
MAX_EPOCHS = 150           #how many times to visit all records of your data
SHOW_PLOT = True           #would you like to see a pop up display of final loss?
VERBOSE_TRAIN = True       #would you like to see a progress bar with text during training?
USE_EARLY_STOP = True      #would you like to stop the training if we see it's not improving fit?
EARLY_STOP_PATIENCE = 20   #how many epochs to wait before no improvement
MIN_DELTA = .0005          #early stop will want this much loss change before calling it improved.
PRINT_MODEL_SUMMARY = True #print layers and weights to stdout
OPTIMIZER = None           #adam, sgd, rmsprop, etc.. None accepts default
LEARNING_RATE = 0.001      #only used when OPTIMIZER specified
LEARNING_RATE_DECAY = 0.0  #only used when OPTIMIZER specified
CACHE_IMAGES = False       #keep images in memory. will speed succesive epochs, but crater if not enough mem.
MODEL_CATEGORICAL_MAX_THROTTLE_RANGE = 1.0

#RECORD OPTIONS
RECORD_DURING_AI = False
AUTO_CREATE_NEW_TUB = True
