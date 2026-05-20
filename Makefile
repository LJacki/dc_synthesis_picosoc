.PHONY: all lib dc clean

PROJ_DIR  = /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_advanced
SCRIPTS   = $(PROJ_DIR)/02_scripts
OUTPUT    = $(PROJ_DIR)/03_output
LIB_DIR   = $(PROJ_DIR)/01_lib
RTL_DIR   = $(PROJ_DIR)/00_rtl

TOP_MODULE = picosoc
CLK_PERIOD = 20

# RTL files for picosoc (core SOC modules only)
RTL_FILES = $(RTL_DIR)/picorv32.v             $(RTL_DIR)/picosoc.v             $(RTL_DIR)/spimemio.v             $(RTL_DIR)/spiflash.v             $(RTL_DIR)/simpleuart.v

all: dc

lib: $(LIB_DIR)/NangateOpenCellLibrary_typical.db

$(LIB_DIR)/NangateOpenCellLibrary_typical.db:
	@echo "[lib] Copying from dc_synthesis_practice"
	@mkdir -p $(LIB_DIR)
	cp /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_practice/01_lib/NangateOpenCellLibrary_typical.lib $(LIB_DIR)/
	cp /home/xiaoai/Desktop/disk1/IC_Project/dc_synthesis_practice/01_lib/NangateOpenCellLibrary_typical.db $(LIB_DIR)/

dc:
	@echo "[dc] Running DC synthesis for $(TOP_MODULE) ..."
	bash -c 'source /home/xiaoai/synopsys_env_setup.sh && cd $(PROJ_DIR) && dc_shell -f $(SCRIPTS)/dc_synth.tcl' 2>&1 | tee $(PROJ_DIR)/04_logs/dc_run.log

clean:
	rm -f $(OUTPUT)/netlist/* $(OUTPUT)/reports/* $(PROJ_DIR)/04_logs/*.log
