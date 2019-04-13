.PHONY: upload clean

all: main.bin

%.json: %.v *.v
	yosys -p "read_verilog $<; synth_ice40 -json $@"

%.asc: %.json
	nextpnr-ice40 --hx1k --package vq100 --json $< --pcf go-board.pcf --asc $@

%.bin: %.asc
	icepack $< $@

upload: main.bin
	iceprog main.bin

clean:
	rm -f *.bin *.pnr *.blif *.json *.asc
