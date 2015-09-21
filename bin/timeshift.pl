#!/usr/bin/env perl

use strict;
use warnings;

#############################################
# init

my ( $infile, $oper, $shiftime ) = @ARGV;

usage() if not ( $infile and $oper and $shiftime);
usage() if ( $oper ne "+" and $oper ne "-" );

#############################################
# main

open my $fh, "<", $infile or die "error opening '$infile':$!";

$shiftime = time_to_sec($shiftime);

while (<$fh>) {
  if ( m/^(\d{2}:\d{2}:\d{2},\d+)\s\-\-\>\s(\d{2}:\d{2}:\d{2},\d+)/ ) {
    my ($start, $end) = ( $1, $2);

    my $startsec = time_to_sec($start);
    my $endsec = time_to_sec($end);

    if ( $oper eq "+" ) {
      $startsec += $shiftime;
      $endsec += $shiftime;
    } else {
      # bug : should check that time stays positive
      $startsec -= $shiftime;
      $endsec -= $shiftime;
    }

    $start = sec_to_time($startsec);
    $end= sec_to_time($endsec);

    print "$start --> $end\r\n";
  } else {
    print $_ ;
  }
}


close $fh;


#############################################
# subs

sub usage {
  print "usage : $0 <file> <+|-> <duration>\n\n";
  print "duration is expressed in hours:minutes:secondes,milliseconds.\nLeading zeros are optional.\n";
  print "result output to stdout.\n";
  exit 1;
}

sub time_to_sec {
  my $time = shift;

  my @elems = split(':', $time);
  my $seconds = pop @elems;
  my $minutes = pop @elems;
  my $hours   = pop @elems;

  $seconds =~ s/,/./g;

  # force to numerical
  $hours += 0; $minutes += 0; $seconds += 0;

  # convert to seconds for easier manipulation
  my $time_sec =  ( $hours * 3600 ) + ($minutes * 60 ) + $seconds ;

  return $time_sec;
}

sub sec_to_time {
  my $sectime = shift;

  my $hours = sprintf( "%02d", int ( $sectime / 3600 ) );
  my $minutes =  sprintf( "%02d", int ( ( $sectime - ( $hours * 3600 ) ) / 60 ) );
  my $seconds = sprintf( "%06.3f", ( ( $sectime - ( $hours * 3600 ) ) - ( $minutes * 60 )) );

  $seconds =~ s/\./,/g;

  return "$hours:$minutes:$seconds";
}
