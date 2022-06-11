SOURCE_DIR:=Source
LIBRARY_DIR=Library
BUILD_DIR=Build
TEST_DIR=Tests
SAMPLE_DIR=Sample
TARGET:=Target.elf
TEST_TARGET:=Test_$(TARGET)
VIEW_TARGET:=$(notdir $(TARGET_FILE:.cpp=))_$(TARGET)

CPP_VIEW:=$(TARGET_FILE)

# Library source files

LIB_CPP_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.cpp')
LIB_C_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.c')
LIB_AS_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.asm')

# Library object files

LIB_CPP_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(LIB_CPP_SOURCES:.cpp=.o)))
LIB_C_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(LIB_C_SOURCES:.c=.o)))
LIB_AS_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(LIB_AS_SOURCES:.asm=.o)))

# View object file

VIEW_CPP_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_VIEW:.cpp=.o)))
VIEW_C_OBJECTS:=
VIEW_AS_OBJECTS:=

# Group object files

LIB_OBJECTS:=$(LIB_CPP_OBJECTS) $(LIB_C_OBJECTS) $(LIB_AS_OBJECTS)
VIEW_OBJECTS:=$(VIEW_CPP_OBJECTS) $(VIEW_C_OBJECTS) $(VIEW_AS_OBJECTS)

LIBRARIES:=$(addprefix -I,$(LIBRARY_DIR))

AS:=as
AS_FLAGS:=

CC:=g++
CPP_FLAGS:=-std=c++2a -g -Wall -Wextra -Wpedantic -c $(LIBRARIES)

C_FLAGS:=

LINKER:=g++
LINKER_FLAGS:=

VIEW_ARGS:=

view:$(VIEW_CPP_OBJECTS) $(LIB_OBJECTS)
	$(LINKER) $^ $(OBJECTS) -o $(BUILD_DIR)/$(VIEW_TARGET) $(LINKER_FLAGS)

# Library builder

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.c Makefile | $(BUILD_DIR)
	$(CC)$< -o $@ $(C_FLAGS)

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.asm Makefile | $(BUILD_DIR)
	$(AS) $< -o $@ $(AS_FLAGS)

# Sample builder

$(BUILD_DIR)/%.o:$(SAMPLE_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

# Test builder

$(BUILD_DIR)/%.o:$(TEST_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

$(BUILD_DIR):
	mkdir $@

clean:
	rm -Rf $(BUILD_DIR)

# Meta-data

LINES:=$(shell git ls-files | xargs cat | wc -l)

lines:
	@echo "Number of lines : $(LINES)"
