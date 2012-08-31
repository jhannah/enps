use strict;
use 5.10.0;

my @files = `find data -name "*.txt"`;
foreach my $f (@files) {
   chomp $f;
   say $f;
   my @f = split m#/#, $f;
   my ($y, $m) = @f[1,2];
   open my $in, "<", $f or die;
   my $begin; 
   while (<$in>) {
      chomp;
      if (/^\s+1\s\w/) { $begin = 1; }   # Start reading this file.
      next unless ($begin);              # We're still in the headers. Skip. 
      last unless (/^\s+\d+\s\w/);       # Data has ended. Stop reading this file.
      say "   $_";
      my @l = split /\s+/;
      shift @l unless ($l[0]);   # discard first column if empty

      # "Super Senior" splits on spaces. Ooops. Fix it.
      if ($l[-4] eq "Super" && $l[-3] eq "Senior") {
         $l[-4] = "Super Senior";
         splice @l, -3, 1;
      }

      # If Age is blank it's undef
      unless ($l[-3] =~ /[a-z]/) {
         splice @l, -2, 0, 'undef';
      }

      # Before 2008-04 the fields 'Mil' and 'Law' did not exist.
      if ($y < 2008 || ($y == 2008 && $m < 4)) {
         splice @l, -5, 0, 'undef', 'undef';
      }

      # If USPSA is blank it's undef
      if ($l[-11] =~ /[a-z]/) {
         splice @l, -10, 0, 'undef';
      }

      # If their name had more than one space fix it.
      while (@l > 14) {
         $l[1] = "$l[1] $l[2]";
         splice @l, 2, 1;
      }

      # Remove comma from last name.
      $l[1] =~ s/,$//;

      say join "|", @l;

      my ($place, $lname, $fname, $uspsa, $class, $division, $pf, $lady, $for, $age, $points, $stgperc) = @l;

   }
}


