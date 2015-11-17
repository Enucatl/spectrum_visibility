.PHONY: all

all: au.csv

au.csv: get_beta_delta.py
	python $< --material Au --density 19.3 --output $@
