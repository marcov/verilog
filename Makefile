
.PHONY: clean


VVP = $(SRC:.v=.vvp)
	
#Generates a vvp file from the passed target name (source code name without .v)
%:
	iverilog -o $*.vvp $*.v
	vvp $*.vvp -lxt2

sim:
	gtkwave test.lxt


clean:
	rm *.vvp *.lxt
