#!/usr/bin/env perl
my $ahrd = shift;
my @fasta = @ARGV;
open(AHRD,$ahrd) || die $!;
my %id2desc = map {chomp; my ($id, $desc) = split /\t/; $id => $desc;} <AHRD>;
close AHRD;
$/="\n>";
foreach my $fasta (@fasta) {
	open(F, $fasta) || die $!;
	open(FA, ">$fasta.ahrd") || die $!;
	while (<F>) {
		s/^>//;
		chomp;
		my ($id, $seq) = /^(\S+)[^\n]*\n(.*)/s;
		my $gid = $id;
		$gid =~ s/-mRNA-\d+$//;
		$gid =~ s/-RA$//;
		my $desc = $id2desc{$gid};
		warn "no AHRD for $gid\n" unless defined $desc;
		print FA ">$id $desc\n$seq\n";
	}
	close F;
	close FA;
}
