SOURCE_DIR:=Source
LIBRARY_DIR=Library
BUILD_DIR=Build
TEST_DIR=Test
SAMPLE_DIR=Sample
TARGET:=Target.elf
TEST_TARGET:=Test_$(TARGET)
VIEW_TARGET:=$(notdir $(TARGET_FILE:.cpp=))_$(TARGET)

# All source files

CPP_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.cpp')
C_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.c')
AS_SOURCES:=$(shell find $(SOURCE_DIR) -name '*.asm')

# Test source files

CPP_TESTS:=$(shell find $(TEST_DIR) -name '*.cpp')
C_TESTS:=$(shell find $(TEST_DIR) -name '*.c')
AS_TESTS:=$(shell find $(TEST_DIR) -name '*.asm')

# View source files

CPP_VIEW:=$(TARGET_FILE)

# All object files

CPP_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
C_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
AS_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(AS_SOURCES:.asm=.o)))

# Test object files

TEST_CPP_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_TESTS:.cpp=.o)))
TEST_C_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(C_TESTS:.c=.o)))
TEST_AS_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(AS_TESTS:.asm=.o)))

# View object files

VIEW_CPP_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_VIEW:.cpp=.o)))
VIEW_C_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_VIEW:.c=.o)))
VIEW_AS_OBJECTS:=$(addprefix $(BUILD_DIR)/,$(notdir $(CPP_VIEW:.asm=.o)))

# Group object files

OBJECTS:=$(CPP_OBJECTS) $(C_OBJECTS) $(AS_OBJECTS)
TEST_OBJECTS:=$(TEST_CPP_OBJECTS) $(TEST_C_OBJECTS) $(TEST_AS_OBJECTS)
VIEW_OBJECTS:=$(VIEW_CPP_OBJECTS) $(VIEW_C_OBJECTS) $(VIEW_AS_OBJECTS)

LIBRARIES:=$(addprefix -I,$(LIBRARY_DIR))

AS:=as
AS_FLAGS:=

CC:=g++
# CC:= clang
CPP_FLAGS:=-std=c++2a -g -Wall -c $(LIBRARIES)

LINKER:=g++
LINKER_FLAGS:=-no-pie -Wall -Wpedantic -pedantic -pthread -lssl -lcrypto

RUN_ARGS:=
TEST_ARGS:=

all:$(OBJECTS)
	$(LINKER) $^ -o $(BUILD_DIR)/$(TARGET) $(LINKER_FLAGS)

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.c Makefile | $(BUILD_DIR)
	$(CC)$< -o $@ $(CPP_FLAGS) 

$(BUILD_DIR)/%.o:$(SOURCE_DIR)/%.asm Makefile | $(BUILD_DIR)
	$(AS) $< -o $@ $(AS_FLAGS)

# @todo extend for assembly and c

$(BUILD_DIR)/%.o:$(TEST_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

$(BUILD_DIR)/%.o:$(SAMPLE_DIR)/%.cpp Makefile | $(BUILD_DIR)
	$(CC) $< -o $@ $(CPP_FLAGS)

$(BUILD_DIR):
	mkdir $@

run:
	@$(BUILD_DIR)/$(TARGET) $(RUN_ARGS)

runtest:
	@$(BUILD_DIR)/$(TEST_TARGET) $(RUN_ARGS)

clean:
	rm -Rf $(BUILD_DIR)

test:$(TEST_OBJECTS)
	$(LINKER) $^ -o $(BUILD_DIR)/$(TEST_TARGET) $(LINKER_FLAGS)

view:$(VIEW_CPP_OBJECTS)
	$(LINKER) $^ -o $(BUILD_DIR)/$(VIEW_TARGET) $(LINKER_FLAGS)

# Meta-data

LINES:=$(shell git ls-files | xargs cat | wc -l)

lines:
	@echo "Number of lines : $(LINES)"
