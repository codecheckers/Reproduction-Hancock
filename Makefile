# Makefile for Hancock et al reproductions

FIGURES = Figure2.png Figure3.png Figure4.png Figure5.png \
          Figure6.png Figure7.png Figure8.png


all: $(FIGURES)


Figure%.png: PlotFigure%.m 
	matlab -nodisplay -nosplash -nodesktop -r "run('$<'); exit;"



.PHONY: clean


clean:
	rm -f $(FIGURES)

