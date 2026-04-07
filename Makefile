.PHONY: build run gui clean

work := $(shell pwd)
build := $(work)/build

export W_DIR = $(work)

build:
	vlog -f $(work)/file_list.f -work $(build)/ -cover bcestf -covercells

run:
	vsim build.tb_top -c -do "run -all; exit;" +UVM_TESTNAME=ext_test +ITEM_NUM=500

gui:
	vsim build.tb_top -do "add wave -position insertpoint sim:/tb_top/_if/*;" +UVM_TESTNAME=ext_test +ITEM_NUM=500 -coverage

clean:
	rm -rf $(build)
	rm -f $(work)/transcript
	rm -f $(work)/vish_stacktrace.vstf
	rm -f $(work)/vsim.wlf