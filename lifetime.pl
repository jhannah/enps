use strict;
use 5.10.0;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=enps.sqlite","","");

# my ($place, $lname, $fname, $uspsa, $class, $division, $pf, $lady, $for, $age, $points, $stgperc) = @l;
my $strsql = "select lname, fname, sum(points) points from results group by lname, fname order by sum(points) desc";
my $sth = $dbh->prepare($strsql);
$sth->execute;
while (my $href = $sth->fetchrow_hashref) {
   say "$href->{lname}, $href->{fname} $href->{points}";
}
$sth->finish;


$dbh->disconnect;


