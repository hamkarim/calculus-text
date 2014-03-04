#!/usr/bin/perl
$debug = 0;
$do_cmd = 1;

$i = 0;
$prev_start = 0;
$pages = 0;

if ( $#ARGV < 0 ) {
  print "Usage: $0 <basename>\n";
  exit 0;
}
$basename = $ARGV[0];
$dviname = $basename."-dvips";

if (!-f "$dviname.dvi") {
  print "You must create $dviname.dvi before running this program.\n";
  exit 0;
}

$cmd = "dvips -Pdownload35 $basename -o";
print "$cmd\n";
if ($do_cmd) { 
  system $cmd;
}

$cmd = "pstops \"2:0\@0.75(-19.8,47),1\@0.75(-7.2,47)\" $basename.ps temp.ps";
print "$cmd\n";
if ($do_cmd) { 
  system $cmd;
}

$outname="lulu_".$basename."_6x9.ps";
open (ifile,"temp.ps");
open (ofile,">$outname");

while (<ifile>) {
  if (!/DocumentPaperSizes:\s+Letter/) {
    s/BoundingBox:\s+0\s+0\s+[0-9]+\s+[0-9]+/BoundingBox: 0 0 432 648/;
    print ofile;
    }
}

close(ifile);
close(ofile);

$cmd = "ps2pdf -dSubsetFonts=false -dDEVICEWIDTHPOINTS=432 -dDEVICEHEIGHTPOINTS=648 $outname";
print "$cmd\n";
if ($do_cmd) { 
  system $cmd;
}
