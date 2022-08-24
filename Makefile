.SUFFIXES:

DEFAULT_GOAL: upload

PROJECT_DIR := $(realpath $(CURDIR))
SOURCE_DIR := $(PROJECT_DIR)/CAD/export
BUILD_DIR := $(PROJECT_DIR)/bin


FILE_SOURCES = $(foreach dir,$(SOURCE_DIR),$(wildcard $(dir)/*.FCStd))
FILE_STLS := $(subst $(SOURCE_DIR),$(BUILD_DIR),$(FILE_SOURCES:.FCStd=.stl))
FILE_GCODES := $(subst $(SOURCE_DIR),$(BUILD_DIR),$(FILE_SOURCES:.FCStd=.gcode))


PYTHON3 = python3


ifeq ($(VERBOSE),TRUE)
	HIDE =  
else
	HIDE = @
endif


$(BUILD_DIR)/%.stl: $(SOURCE_DIR)/%.FCStd
	@echo Exporting $$@
	mkdir -p ${BUILD_DIR}
	$(HIDE)$(PYTHON3) $(PROJECT_DIR)/tools/export_stl.py $< $@

$(BUILD_DIR)/%.gcode: $(BUILD_DIR)/%.stl
	@echo Exporting $$@
	mkdir -p ${BUILD_DIR}
	$(HIDE)$(PYTHON3) $(PROJECT_DIR)/tools/export_gcode.py $< $@

echo:
	@echo $(FILE_SOURCES)
	@echo $(FILE_STLS)
	@echo $(FILE_GCODES)


stl: $(FILE_STLS)
gcode: $(FILE_GCODES)
upload: $(FILE_GCODES)
	$(HIDE)$(PYTHON3) $(PROJECT_DIR)/tools/upload_to_octoprint.py $(PROJECT_NAME) $(BUILD_DIR) $(FILE_GCODES)
	

clean:
	rm -r $(BUILD_DIR)
