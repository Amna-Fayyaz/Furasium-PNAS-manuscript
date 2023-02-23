#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
my $add_to_gene_records=1;
my $add_to_mRNA_records=0;
GetOptions(
	"add_to_gene_records!" => \$add_to_gene_records,
	"add_to_mRNA_records!" => \$add_to_mRNA_records,
);

my $ahrd_f = shift;
my %gene_notes;

open(AHRD_FILE, $ahrd_f) or die $!;
while(<AHRD_FILE>) {
    chomp;
    my @split = split /\t/;
    my ($key, $value) = ($split[0], $split[1]);
    $value =~ s/%/%25/g;
    $value =~ s/;/%3B/g;
    $value =~ s/=/%3D/g;
    $value =~ s/&/%26/g;
    $value =~ s/,/%2C/g;
    $gene_notes{$key} = $value;
}
close AHRD_FILE;

#Input file is the corrected GFF that needs addition of Note attr values (ahrd)
while( my $line = <>) {
    if ($line =~ /^#/) {
        print $line;
        next;
    }
    chomp($line);
    $line =~ s/;$//;
    my @split = split("\t", $line);
    my $note;
    if($split[2] eq 'gene' && $add_to_gene_records) {
            my ($gene_id) = ($split[8] =~ /ID=([^;]+)/);
	    $note = $gene_notes{$gene_id};
    }
    elsif($split[2] eq 'mRNA' && $add_to_mRNA_records) {
            my ($gene_id) = ($split[8] =~ /Parent=([^;]+)/);
	    $note = $gene_notes{$gene_id};
    }
    if (defined $note) {
	   $line = &add_it($line, $note);
    }
    print "$line\n";
}

sub add_it {
	my ($line, $note) = @_;
	my @split = split /\t/, $line;
	if ($split[8] =~ /Note=/) {
	    $split[8] =~ s/Note=[^;]*/Note=$note/;
	    $line = join("\t", @split);
	}
	else {
	    $line .= ";Note=$note";
	}
	return $line;
}
