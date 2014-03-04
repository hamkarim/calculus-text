multi: *.tex
	rm -f multivariable-dvips.dvi
	ln -sf multi.tex multi_or_single.tex
	ln -sf early.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex multivariable.tex
	ln -sf tikz-dvipdfm.tex tikz-conf.tex
	makebook multivariable
	dvipdfm  multivariable

kindle: *.tex
	ln -sf multi.tex multi_or_single.tex
	ln -sf early.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf tikz-dvips.tex tikz-conf.tex
	makebook kindle

# To make the individual chapter files we use dvips, so we
# need to recompile the dvi file with the dvips tikz driver.
multivariable-dvips: *.tex
	ln -sf multi.tex multi_or_single.tex
	ln -sf early.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex multivariable.tex
	ln -sf tikz-dvips.tex tikz-conf.tex
	makebook multivariable
	ln -sf multivariable.dvi multivariable-dvips.dvi

single:  *.tex
	rm -f calculus-dvips.dvi
	ln -sf single.tex multi_or_single.tex
	ln -sf early.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf tikz-dvipdfm.tex tikz-conf.tex
	makebook calculus
	dvipdfm  calculus

calculus-dvips:  *.tex
	ln -sf single.tex multi_or_single.tex
	ln -sf early.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf tikz-dvips.tex tikz-conf.tex
	makebook calculus
	ln -sf calculus.dvi calculus-dvips.dvi

latemulti: *.tex
	rm -f multivariable_late-dvips.dvi
	ln -sf multi.tex multi_or_single.tex
	ln -sf late.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex multivariable_late.tex
	ln -sf tikz-dvipdfm.tex tikz-conf.tex
	makebook multivariable_late
	dvipdfm  multivariable_late

multivariable_late-dvips: *.tex
	ln -sf multi.tex multi_or_single.tex
	ln -sf late.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex multivariable_late.tex
	ln -sf tikz-dvips.tex tikz-conf.tex
	makebook multivariable_late
	ln -sf multivariable_late.dvi multivariable_late-dvips.dvi

late: *.tex
	rm -f calculus_late-dvips.dvi
	ln -sf single.tex multi_or_single.tex
	ln -sf late.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex calculus_late.tex
	ln -sf tikz-dvipdfm.tex tikz-conf.tex
	makebook calculus_late
	dvipdfm  calculus_late

calculus_late-dvips: *.tex
	ln -sf single.tex multi_or_single.tex
	ln -sf late.tex transcendentals.tex
	ln -sf live_url_whitman.tex live_url.tex
	ln -sf luluno.tex lulu.tex
	ln -sf calculus.tex calculus_late.tex
	ln -sf tikz-dvips.tex tikz-conf.tex
	makebook calculus_late
	ln -sf calculus_late.dvi calculus_late-dvips.dvi

# This makes an answer booklet with all answers. Since I decided to
# put all answers in the main book, this is not very useful. If you
# add exercises and use the \noanswer macro, this will print all
# answers, including those that do not appear in the book.

all_answers: multivariable.answers
	make_all_answers.pl multivariable
	tex multivariable_answers.tex
	dvipdfm  multivariable_answers

# Make individual pdf files for each chapter. These will have no
# live links. The perl script should figure out where to break
# chapters.

chapters: multivariable-dvips
	make_pdfs.pl multivariable

# Lulu requires full embedding of all fonts, which seems to be
# guaranteed by the -dSubsetFonts=false switch; the lulu versions of
# the pdf files have no live links.

lulusingle: calculus-dvips
	dvips -Pdownload35 calculus -o
	ps2pdf13 -dSubsetFonts=false -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray calculus.ps lulu_calc.pdf

lulumulti: multivariable-dvips
	dvips -Pdownload35 multivariable -o
	ps2pdf13 -dSubsetFonts=false -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray multivariable.ps lulu_multi.pdf

lulusinglelate: calculus_late-dvips
	dvips -Pdownload35 calculus_late -o
	ps2pdf13 -dSubsetFonts=false -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray calculus_late.ps lulu_calc_late.pdf

lulumultilate: multivariable_late-dvips
	dvips -Pdownload35 multivariable_late -o
	ps2pdf13 -dSubsetFonts=false -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray multivariable_late.ps lulu_multi_late.pdf

# This generates the 6x9 version of the book using an external perl script.

smlulu: multivariable-dvips
	small_size.pl multivariable

smlulul: multivariable_late-dvips
	 small_size.pl multivariable_late

smlulus: calculus-dvips
	small_size.pl calculus

smlulusl: calculus_late-dvips
	small_size.pl calculus_late

# The two-up version of the book for lulu.

twoup:  multivariable-dvips
	dvips -Pdownload35 multivariable -o
	pstops "2:0L@.7(8in,-0.3in)+1L@.7(8in,5.37in)" multivariable.ps multivariable_2up.ps
	ps2pdf13 -dSubsetFonts=false -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dAutoRotatePages=/None multivariable_2up.ps multivariable_2up.pdf

clean:
	rm -f *~ *.log *.dvi calculus*.ps multivariable*.ps *.answers \
	multivarible_answers.tex

veryclean: clean
	rm -f calculus*.pdf multivariable*.pdf multivarible_answers.pdf \
	live_url.tex transcendentals.tex multivariable_late.tex \
	lulu.tex multi_or_single.tex multivariable.tex \
	multivariable_late.tex calculus_late.tex tikz-conf.tex \
        *.gnuplot *.table

# I run distclean to make the source directory that I distribute.

distclean: veryclean
	rm -f *.prev *.aux *.bbl *.blg *.cts *.idx *.ilg *.ind *.tdx \
	*.tin *.toc *.pgf testsection.* temp.*
