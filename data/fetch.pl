use strict;
use 5.10.0;
use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
my $domain = "http://www.easternnebraskapracticalshooters.com";
 
get_it('2006', '12', "$domain/2006/results/12/pistol/pistol-finals.txt");
get_it('2006', '11', "$domain/2006/results/11/pistol/Pistol-Finals-Match.txt");
get_it('2006', '07', "$domain/2006/results/pistol-july-2006.txt");
get_it('2006', '06', "$domain/2006/results/pistol-june-2006.txt");
get_it('2006', '04', "$domain/2006/results/pistol-april-2006.txt");
get_it('2006', '03', "$domain/2006/results/pistol-march-2006.txt");
get_it('2006', '02', "$domain/2006/results/pistol-february-2006.txt");
get_it('2006', '01', "$domain/2006/results/pistol-january-2006.txt");
foreach my $y (2007) {
   foreach my $m (1..12) {
      $m = sprintf("%02d", $m);
      my $url = "$domain/$y/results/$m/pistol/pistol-finals-all-divisions.txt";
      get_it($y, $m, $url);
   }
}
foreach my $y (2008..2011) {
   foreach my $m (1..12) {
      $m = sprintf("%02d", $m);
      my $url = "$domain/$y/matches/$m/pistol/finals.txt";
      get_it($y, $m, $url);
   }
}
foreach my $y (2012) {
   foreach my $m (1..12) {
      $m = sprintf("%02d", $m);
      my $url = "$domain/$y/$m/pistol/finals.txt";
      get_it($y, $m, $url);
   }
}



sub get_it {
   my ($y, $m, $url) = @_;
   say $url;
   my $response = $ua->get($url);
   if ($response->is_success) {
      foreach my $d ("$y", "$y/$m", "$y/$m/pistol") {
         unless (-d $d) { 
            mkdir($d) or die;
         }
      }
      open my $out, ">", "$y/$m/pistol/finals.txt" or die;
      print $out $response->decoded_content;
      say "   Success";
   } else {
      say "   " . $response->status_line;
   }
}



