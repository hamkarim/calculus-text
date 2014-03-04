# Whitman Calculus Textbook

This is the source code for the open source calculus textbook at
http://www.whitman.edu/mathematics/multivariable/.

## To build on Ubuntu/Debian

As root, install LaTeX packages:

```bash
apt-get install texlive-latex-recommended texlive-latex-extra texlive-metapost
```

Within the top-leve directory of the source distribution, you can build the text
as follows:

```bash
make
```

This will produce a file called multivariable.pdf. Enjoy.
