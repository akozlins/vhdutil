
all:

.PHONY: clean
clean:
	rm -rfv .cache/ .Xil/ *.jou *.log *.str project/
	rm -rfv ip/* work/*
