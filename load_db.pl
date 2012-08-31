use strict;
use 5.10.0;

use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=enps.sqlite","","");
my $strsql = "insert into results (year, month, place, lname, fname, uspsa, class, division, pf, lady, mil, law, for, age, points, stgperc) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
my $sth = $dbh->prepare($strsql);


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
      # say "   $_";
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

      # "Limited 10" gets split
      if ($l[-10] eq "Limited" && $l[-9] eq "10") {
         $l[-10] = "Limited 10";
         splice @l, -9, 1;
      }
    
      # "Single Stack" gets split
      if ($l[-10] eq "Single" && $l[-9] eq "Stack") {
         $l[-10] = "Single Stack";
         splice @l, -9, 1;
      }

      # USPSA "Pen" throws off our logic below
      if ($l[-11] eq "Pen") {
         $l[-11] = "PENDING";
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

      # say join "|", @l;
      $sth->execute($y, $m, @l);
      # my ($place, $lname, $fname, $uspsa, $class, $division, $pf, $lady, $for, $age, $points, $stgperc) = @l;
   }
}


