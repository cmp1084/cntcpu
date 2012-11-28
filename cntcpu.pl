#!/usr/bin/perl
################################################################################
#
# CPU counter tool
# Fixes the CPUS variable in compile scripts for optimal compilation.
#
# Author: Marcus Jansson <mjansson256@gmail.com>
# Date: 2012-11-27
#
################################################################################

# The name (and location) of the script files
my $toolchain = "toolchain.sh";
my $toolchain_work = "$toolchain.wrk";

my $cpus = 0;
my $p;

# Read cpuinfo to get nr of cpu's on this system
open FH, "</proc/cpuinfo";

while($p = <FH>) {
	$cpus++ if($p =~ /processor/s);
}

# Done reading cpuinfo
close FH;

# Try to open script file and a work copy
die "Error opening $toolchain\n" unless open FH, "<$toolchain";
die "Error opening $toolchain_work\n" unless open FN, ">$toolchain_work";

while($p = <FH>) {
	if($p =~ /^(\s*)\${0}CPUS(\s*)=/) {
		print FN "$1CPUS$2=$2$cpus\n";
		
		print "Fixing:\n";
		print "CPUS = $cpus\n"; 

	} else {
		print FN $p;
	}
}

# Done reading/writing files, close them
close FH;
close FN;

# Remove old script and rename the working copy
die "Error removing $toolchain\n" unless unlink $toolchain;
die "Error renaming $toolchain\n" unless rename $toolchain_work, $toolchain;

die "Done"
