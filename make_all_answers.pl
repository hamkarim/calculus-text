#!/usr/bin/perl

$debug = 0;
$progname = $0;
$progname =~ s/^\/.*\///;

if ($#ARGV < 0) {
  print "Usage: $progname <basename>\n";
  exit 0;
}

$ifile = $ARGV[0].".answers";
if ($debug) { print "Opening $ifile\n"; }
open(ans,$ifile);
$ofile = $ARGV[0]."_answers.tex";
if ($debug) { print "Opening $ofile\n"; }
open(all,">$ofile");

print all "\\input basic\n";
print all "\\input eplaindrg\n";
print all "\\input calcmacros\n";
print all "\\overfullrule0pt\n";
print all "\\writinganswersfalse\n";

while (<ans>) {
  if ($debug) { print "Newline: $_"; }
  s/^%//;
  print all;
}

print all "\\bye\n";

close(ans);
close(all);
