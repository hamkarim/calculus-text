#!/usr/bin/perl
$debug = 0;
$do_cmd = 1;

# $i = -0; # For roman-numeral prefatory material
$i = -1;
# $prev_start = 0; # For roman-numeral prefatory material
$prev_start = 1;
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

# find the total number of pages in the document.

$filename = $basename;
$filename .= "_full.ps";
$cmd = "dvips -o $filename $dviname > /dev/null 2>&1 ";
print "$cmd\n";
if ($do_cmd) { 
  system $cmd;
  $result=`/usr/bin/psselect -p_1 < $filename 2>&1 > /dev/null | cat`;
  if ($result =~ /\[([0-9]+)\]/ ) { $total_pages = $1; }
  unlink $filename;
}

# We can compute the starting pages and lengths of the chapters from
# the table of contents, except for the last chapter and prefatory
# material.
# Update: with numbering starting at 1=title page, the prefatory material
# works fine too.

$prev_title = "intro";

open (cts,"$basename.toc");
while (<cts>) { 
  if ( /tocchapterentry \{([ ,:0-9a-zA-Z\\]+)\}\{[ .0-9a-zA-Z\\]+\}\{([0-9]+)\}/ ) {
    $title = $1;
    $new_start = $2;
    $title =~ s/\\[a-z]+//;
    $title =~ s/ /_/g;
    if ($debug) { print "Title: $title\n"; }
    if ($debug) { print "New chapter page: $new_start\n"; }
    if ( $prev_start ) {
      $i++;
      $length = $new_start - $prev_start;
      $pages += $length;
      $filename = $basename."_";
      if ( $i < 10 ) { $filename .= "0"; }
      $filename .= $i;
      $filename .= "_";
      $filename .= $prev_title;
      $filename =~ s/:/-/;
#      $pdfname = $filename;
      $filename .= ".ps";
#      $pdfname .= ".pdf";
      $cmd = "dvips -p$prev_start -n$length -o $filename $dviname > /dev/null 2>&1 ";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      $cmd = "ps2pdf $filename";
#      $last_page = $new_start - 1;
#      $cmd = "dvipdfm -o $pdfname -s $prev_start-$last_page $basename";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      $twoname = $filename;
      $twoname =~ s/\.ps$/_2up.ps/;
      $cmd = "psnup -2 $filename $twoname";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      $cmd = "ps2pdf $twoname";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      $fourname = $filename;
      $fourname =~ s/\.ps$/_4up.ps/;
      $cmd = "psnup -4 $filename $fourname";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      $cmd = "ps2pdf $fourname";
      print "$cmd\n";
      if ( $do_cmd ) { system $cmd; }
      if ( $do_cmd ) { 
	unlink $filename; 
	unlink $twoname;
	unlink $fourname;
      }
    }
    $prev_start = $new_start;
    $prev_title = $title;
  }
}

close cts;

# Now the last chapter, for which we don't know or need the length.

$i++;
$filename = $basename."_";
if ( $i < 10 ) { $filename .= "0"; }
$filename .= $i;
$filename .= "_";
$filename .= $title;
$filename .= ".ps";
$cmd = "dvips -p$prev_start -o $filename $dviname > /dev/null 2>&1 ";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
$cmd = "ps2pdf $filename";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
$twoname = $filename;
$twoname =~ s/\.ps$/_2up.ps/;
$cmd = "psnup -2 $filename $twoname";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
$cmd = "ps2pdf $twoname";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
$fourname = $filename;
$fourname =~ s/\.ps$/_4up.ps/;
$cmd = "psnup -4 $filename $fourname";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
$cmd = "ps2pdf $fourname";
print "$cmd\n";
if ( $do_cmd ) { system $cmd; }
# Uncomment for roman-numeral prefatory material.
# if ( $do_cmd ) { 
# # Find the number of pages in the last chapter.
#   $result=`/usr/bin/psselect -p_1 < $filename 2>&1 > /dev/null | cat`;
#   if ($debug) { print "Result: $result\n"; }
#   if ($result =~ /\[([0-9]+)\]/ ) { $count = $1; }
#   if ($debug) { print "Count: $count\n"; }
#   unlink $filename; 
#   unlink $twoname;
#   unlink $fourname;
#   $pages += $count;
# }
# 
# # Now we can do the prefatory material, since we know the total length
# # and the number of pages processed in all the chapters.
# 
# if ($debug) { print "Pages: $pages out of $total_pages\n"; }
# $length = $total_pages - $pages;
# 
# $filename = $basename."_00_intro.ps";
# $cmd = "dvips -n$length -o $filename $basename > /dev/null 2>&1 ";
# print "$cmd\n";
# if ( $do_cmd ) { system $cmd; }
# $cmd = "ps2pdf $filename";
# if ( $do_cmd ) { system $cmd; }
# $twoname = $filename;
# $twoname =~ s/\.ps$/_2up.ps/;
# $cmd = "psnup -2 $filename $twoname";
# print "$cmd\n";
# if ( $do_cmd ) { system $cmd; }
# $cmd = "ps2pdf $twoname";
# print "$cmd\n";
# if ( $do_cmd ) { system $cmd; }
# $fourname = $filename;
# $fourname =~ s/\.ps$/_4up.ps/;
# $cmd = "psnup -4 $filename $fourname";
# print "$cmd\n";
# if ( $do_cmd ) { system $cmd; }
# $cmd = "ps2pdf $fourname";
# print "$cmd\n";
# if ( $do_cmd ) { system $cmd; }
if ( $do_cmd ) { 
  unlink $filename; 
  unlink $twoname;
  unlink $fourname;
}

