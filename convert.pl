use strict;
use utf8;
binmode(STDOUT,':utf8');
my $filename = 'file.txt';
my $fileout = 'fileout.txt';
my $text;
my $itog;
my @lines;
my @alines;

if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
	while (my $row = <$fh>) {
		chomp $row;
		$text = $text.$row;
		push @lines, $row;
	}
	close($fh);
} else {
	warn "Could not open file '$filename' $!";
}

for (my $i = 0; $i <= $#lines; $i++) {
	if ($lines[$i] =~ s/<A[^>]+?HREF\s*=\s*["']?([^'" >]+?)[ '"].*?>([^<]+)//si) {
		
		my $nach = $1;

		my $con = $2;
		
		$nach =~ s/.*\//:/g;
		$nach =~ s/$/">/;

		$alines[$i] = $nach.$con;

		if ($alines[$i] =~ m/&nbsp;/) {
			$alines[$i] =~ s/&nbsp;//g;
		}
		$alines[$i] =~ s/^\s+|\s+$//g;
		
		my $date;
		# тут баг
		if ($lines[$i] =~ m/\d{1,2}\.\d{1,2}\.\d\d\d\d.*\)/) {
			$date = $&;
			$alines[$i] = $alines[$i]."</a> \($date</p>";
		}
		else {
			$alines[$i] = $alines[$i]."</a></p>";
		}

		if (($alines[$i] =~ /.doc/i) or ($alines[$i] =~ /.docx/i) or ($alines[$i] =~ /.rtf/i) ) {
			$alines[$i] =~ s/:/<p style="line-height: normal;" dir="ltr"><img src="images\/doc_admin\/ico\/ms_word1.png" alt="" style="float: left;" border="0" \/><a href="images\/doc_admin\/xxxxx\//;
		}

		if (($alines[$i] =~ /.xls/i) or ($alines[$i] =~ /.xlsx/i)) {
			$alines[$i] =~ s/:/<p style="line-height: normal;" dir="ltr"><img src="images\/doc_admin\/ico\/ms_excel1.png" alt="" style="float: left;" border="0" \/><a href="images\/doc_admin\/xxxxx\//;
		}

		if (($alines[$i] =~ /.zip/i) or ($alines[$i] =~ /.rar/i)) {
			$alines[$i] =~ s/:/<p style="line-height: normal;" dir="ltr"><img src="images\/doc_admin\/ico\/winrar.png" alt="" style="float: left;" border="0" \/><a href="images\/doc_admin\/xxxxx\//;
		}

		if ($alines[$i] =~ /.pdf/i) {
			$alines[$i] =~ s/:/<p style="line-height: normal;" dir="ltr"><img src="images\/doc_admin\/ico\/pdf.png" alt="" style="float: left;" border="0" \/><a href="images\/doc_admin\/xxxxx\//;
		}

		if (($alines[$i] =~ /.ppt/i) or ($alines[$i] =~ /.pptx/i)) {
			$alines[$i] =~ s/:/<p style="line-height: normal;" dir="ltr"><img src="images\/doc_admin\/ico\/pps.png" alt="" style="float: left;" border="0" \/><a href="images\/doc_admin\/xxxxx\//;
		}
	}
}

@alines = grep {$_} @alines; 

foreach (@alines) {
	$itog = $itog.$_."\n";
}

#print $itog;

if (open(my $fho, '>:encoding(UTF-8)', $fileout)) {
		print $fho $itog;
	close($fho);
} else {
	warn "Could not open file '$fileout' $!";
}