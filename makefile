# ThanOS
# Copyright Benjamin Kyd (c) 2018
# Origionaly written by xX_WhatsTheGeek_Xx
# Modified by Benjamin Kyd

# CONFIGURATION
DELETE = rm -f 

# DIRECTORIES
SRC_DIR = ./
LIB_DIR = ./libs
OBJ_DIR = ./obj
INC_DIR = ./libs/includes

# C++
SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp)
LIB_FILES = $(wildcard $(LIB_DIR)/*.cpp)
CPP_OBJ = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES)) $(patsubst $(LIB_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(LIB_FILES))

# ASSEMBLY
ASM_SRC = $(wildcard $(SRC_DIR)/*.asm)
ASM_LIB = $(wildcard $(LIB_DIR)/*.asm)
ASM_OBJ = $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(ASM_SRC)) $(patsubst $(LIB_DIR)/%.asm,$(OBJ_DIR)/%.o,$(ASM_LIB))

# COMPILER STUFF
# unused: -Wall -Wextra
GPP_CMD = i686-elf-g++
GAS_CMD = i686-elf-as
LDFLAGS = -T link.ld -ffreestanding -O2 -nostdlib -lgcc -Wwrite-strings
CPPFLAGS = -I $(INC_DIR) -ffreestanding -O2 -fno-rtti -Wno-write-strings -Wno-multichar -Wno-unused-parameter -Wno-overflow -Wno-narrowing -fno-exceptions -Wno-trigraphs
CXXFLAGS = 
GASFLAGS = 
OBJ_FILES = $(CPP_OBJ) $(ASM_OBJ)
OUTPUT = ./bin/ThanOS.bin
ISO_OUTPUT = ./bin/ThanOS.iso

all: $(OUTPUT)

clean:
	$(DELETE) ./obj/*
	$(DELETE) ./bin/*

iso: all
	cp $(OUTPUT) ./ISO/boot/ThanOS
	grub-mkrescue -o $(ISO_OUTPUT) ./ISO

folders:
	mkdir -p ./bin
	mkdir -p ./obj

$(OUTPUT): $(OBJ_FILES)
	$(GPP_CMD) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(GPP_CMD) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(LIB_DIR)/%.cpp
	$(GPP_CMD) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<
    
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(GAS_CMD) $(GASFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: $(LIB_DIR)/%.asm
	$(GAS_CMD) $(GASFLAGS) -o $@ $<