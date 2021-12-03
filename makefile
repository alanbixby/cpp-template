# Project Information and Contact Details
GITHUB_ID := alanbixby
COURSE := CSXXX
CP := 1
EXECUTABLE_NAME := program$(CP)
TAR_NAME := abixby1_$(CP)
TAR_IGNORES := .vscode spec

# Source File Directory
SOURCES_DIR := src

# Flags
CXXFLAGS := -Wall -Wextra -std=c++17 -O3
LDFLAGS :=
LDLIBS :=

# Debug Flag - hides debugging by default (recommended; use make debug to debug)
DEBUG := -DNDEBUG

# Tar Flags
TAR_IGNORES := --exclude-vcs --exclude-vcs-ignores $(addprefix --exclude=, $(TAR_IGNORES))

# Source Files
SRC_FILES = $(shell find $(SOURCES_DIR)/ -type f -name '*.cpp')
OBJ_FILES := $(patsubst %.cpp,%.o,$(SRC_FILES))
DEP_FILES := $(patsubst %.cpp,%.d,$(SRC_FILES))

# Makefile Rules
$(EXECUTABLE_NAME): $(OBJ_FILES)
		$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)
# Update .gitignore to exclude the executable; ignore if .gitignore is absent
		-sed -i "1c $(EXECUTABLE_NAME)" .gitignore 2> /dev/null

-include $(DEP_FILES)

%.o: %.cpp
		$(CXX) $(CXXFLAGS) $(LDFLAGS) $(DEBUG) -MMD -MP -c $< -o $@ $(LDLIBS)

all: $(EXECUTABLE_NAME)

debug:
	@$(MAKE) --no-print-directory DEBUG="" rebuild

new: clean run

run: $(EXECUTABLE_NAME)
		./$(EXECUTABLE_NAME)


rebuild: clean $(EXECUTABLE_NAME)

tar: clean
		&& ln -sf $(notdir $(CURDIR)) $(TAR_NAME) \
		&& tar $(TAR_FLAGS) --dereference -cvzf $(TAR_NAME).tar.gz $(TAR_NAME) \
		cd .. \	
		&& mv $(TAR_NAME).tar.gz $(notdir $(CURDIR))/$(TAR_NAME).tar.gz \
		; rm $(TAR_NAME)

clean:
		find . -type f -name '*.o' -delete -o -name '*.d' -delete
		rm -f $(EXECUTABLE_NAME) *.tar.gz

.PHONY: $(EXECUTABLE_NAME) all debug run rebuild tar clean
