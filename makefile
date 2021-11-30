# Project Information and Contact Details
GITHUB_ID := bbearcat1
B_NUMBER := B00123456
COURSE := CSXXX
CP := 1
EXECUTABLE := executable-name
WORKING_DIR := src
TAR_FORMAT := $(GITHUB_ID)_CP$(CP)

# Flags
CXXFLAGS := -Wall -Wextra -std=c++17 -O3
DEBUG :=
LDFLAGS :=
LDLIBS :=

# Tar Flags
TAR_IGNORES := --exclude-vcs --exclude-vcs-ignores --exclude=.vscode --exclude=spec

# Source Files
SRC_FILES := $(wildcard $(WORKING_DIR)/*.cpp)
OBJ_FILES := $(patsubst %.cpp,%.o,$(SRC_FILES))
DEP_FILES := $(patsubst %.cpp,%.d,$(SRC_FILES))

# Makefile Rules
$(EXECUTABLE): $(OBJ_FILES)
		$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@ $(LDLIBS)
# Update .gitignore to exclude executable name; ignore if .gitignore is absent
		-sed -i "1c $(EXECUTABLE)" .gitignore 2> /dev/null

-include $(DEP_FILES)

%.o: %.cpp
		$(CXX) $(CXXFLAGS) $(LDFLAGS) $(DEBUG) -MMD -MP -c $< -o $@ $(LDLIBS)

run: $(EXECUTABLE)
		./$(EXECUTABLE)

all: rebuild

rebuild: clean $(EXECUTABLE)

tar: clean
		cd .. \
		&& ln -sf $(notdir $(CURDIR)) $(TAR_FORMAT) \
		&& tar $(TAR_IGNORES) --dereference -cvzf $(TAR_FORMAT).tar.gz $(TAR_FORMAT) \
		&& mv $(TAR_FORMAT).tar.gz $(notdir $(CURDIR))/$(TAR_FORMAT).tar.gz \
		; rm $(TAR_FORMAT)

clean:
		find . -type f -name '*.o,.d' -delete
		find . -type f -name '*.o,.d' -exec rm {} \;
		rm -f **/*.o **/*.d null.d $(EXECUTABLE) *.tar.gz

.PHONY: $(EXECUTABLE) all debug run rebuild tar clean