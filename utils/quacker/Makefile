#########
# Uname #
#########

UNAME := $(shell uname)

# Standards
IBM_STD = D%Y-%m-%dT%H-%M-%S

DATE  := $(shell date +$(IBM_STD))

############
# Compiler #
############

# Compiler
CC = gcc
CPP = g++

# Change this to one from the list above
COMPILER = $(CC)

##################
# Compiler flags #
##################

CFLAGS = -Wall

###############
# Debug flags #
###############

DEBUG = -g

######################
# Project properties #
######################

# Root of the project
BASE = .

PROJECT_NAME = quacker

SRC_DIR = $(BASE)/src
INC_DIR = $(BASE)/inc
BIN_DIR = $(BASE)/bin

SRC_EXT = c
INC_EXT = h
OBJ_EXT = o
BIN_EXT =

##########################
# OS Specific flags      #
# LD Flags & Target name #
##########################

# Linux (default)
ifeq ($(UNAME),Linux)
TARGET = $(PROJECT_NAME)
LDFLAGS = -lm
RUNCMD = ./$(BIN_DIR)/$(TARGET)
endif

# SunOS
ifeq ($(UNAME),SunOs)
TARGET = $(PROJECT_NAME)
LDFLAGS = -lm
RUNCMD = ./$(BIN_DIR)/$(TARGET)
endif

# OS X
ifeq ($(UNAME),Darwin)
TARGET = $(PROJECT_NAME)
RUNCMD = ./$(BIN_DIR)/$(TARGET)
endif

# Windows (cygwin)
ifeq "$(OS)" "Windows_NT"
$(BIN_EXT) = exe
TARGET = $(PROJECT_NAME).$(BIN_EXT)
endif

############
# Archives #
############

ARCHIVE_TOOL     = tar
ARCHIVE_EXT      = tar.gz
ARCHIVE_DIR      = archive
ARCHIVE_FLAGS    = czvf
ARCHIVE_EXCLUDES = --exclude='*.o' --exclude='archive' --exclude='*.zip' --exclude='*.gz' --exclude='.*'
ARCHIVE_SRC      = -C ../ $(PROJECT_NAME)
ARCHIVE_NAME     = $(PROJECT_NAME).$(DATE).$(ARCHIVE_EXT)

############
# Messages #
############

MSG_BUILD_START = @echo [Building $(PROJECT_NAME) started.]
MSG_BUILD_END   = @echo [Building $(PROJECT_NAME) finished.]

MSG_CREATE = @echo Creating $(PROJECT_NAME) project...

#########################
# Building all together #
#########################

all: $(PROJECT_NAME)

run:
	$(shell echo $(BIN_DIR)/$(TARGET)$(BIN_EXT))

$(PROJECT_NAME):
	$(shell if [ ! -d $(BIN_DIR) ]; \
	then \
		mkdir $(BIN_DIR); \
	fi;)
	$(MSG_BUILD_START)
	$(COMPILER) -o $(BIN_DIR)/$(TARGET) -I $(INC_DIR) $(SRC_DIR)/*.$(SRC_EXT) $(CFLAGS) $(LDFLAGS)
	$(MSG_BUILD_END)

debug:
	$(COMPILER) $(DEBUG) -o $(BIN_DIR)/$(TARGET) -I $(INC_DIR) $(SRC_DIR)/*.$(SRC_EXT) $(CFLAGS) $(LDFLAGS)

clean:
	rm -rvf $(BIN_DIR)/$(TARGET)
	rm -rvf $(BIN_DIR)/*.dSYM
	rm -rvf $(INC_DIR)/*.core $(INC_DIR)/*.errs
	rm -rvf $(SRC_DIR)/*.core $(SRC_DIR)/*.errs
	rm -rvf core

archive: clean
	$(shell if [ ! -d $(ARCHIVE_DIR) ]; \
	then \
		mkdir $(ARCHIVE_DIR); \
	fi;)
	$(ARCHIVE_TOOL) $(ARCHIVE_FLAGS) $(ARCHIVE_DIR)/$(ARCHIVE_NAME) $(ARCHIVE_EXCLUDES) $(ARCHIVE_SRC)
# Additional functionality

create:
	$(MSG_CREATE)
	$(shell if [ ! -d $(SRC_DIR) ]; \
	then \
		mkdir $(SRC_DIR); \
	fi;)
	$(shell if [ ! -d $(INC_DIR) ]; \
	then \
		mkdir $(INC_DIR); \
	fi;)
