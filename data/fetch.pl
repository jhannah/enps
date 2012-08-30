use strict;
use 5.10.0;
use LWP::UserAgent;
 
my $ua = LWP::UserAgent->new;
$ua->timeout(10);
 
foreach my $y (2012) {
   foreach my $m (1..12) {
      $m = sprintf("%02d", $m);
      my $url = "http://www.easternnebraskapracticalshooters.com/$y/$m/pistol/finals.txt";
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
}



