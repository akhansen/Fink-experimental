#!/usr/bin/env perl
use strict;
use Getopt::Long;

my $increment_revision;
my $fixed_revision;
my $type;
my $new_type_value;
my $minimum_type;
my $debug;
my $in_place;
my $revision_step;

my $result = GetOptions (
							"increment-revision" => \$increment_revision,
							"step=i" => \$revision_step,
							"revision=s" => \$fixed_revision,
							"type=s" => \$type,
							"new-type-value=s" => \$new_type_value,
							"minimum-type=s" => \$minimum_type,
							"debug" => \$debug,
							"in-place" => \$in_place,
						);
print STDERR "$result\n" if $debug;

# Check for valid inputs
# bail out if none of the change options are set
# bail if there are no filename arguments
unless (@ARGV) {
	&show_usage;
	die "** One or more files to transform must be specified.\n";
}
unless (($increment_revision) || ($fixed_revision) || ($type)) {
	&show_usage;
	die "** None of the required flags was chosen.  No operation performed.\n"; 
}
# --type must be set to use --new-type-value or --minimum-type
if (($new_type_value || $minimum_type)  && !$type) {
	&show_usage;
	die "** --type must be specified to use --new-type-value and/or --minimum-type.\n";
}
# --type requires --new-type-value
if ($type && !$new_type_value) {
	&show_usage;
	die "** --new-type-value must be set when using --type.\n";
}
# --step requires --increment-revision
if ($revision_step && !$increment_revision) {
	&show_usage;
	die "** --increment-revision must be set when using --step.\n";
}
if ($revision_step && !$increment_revision) {
	&show_usage;
	die "** --increment-revision must be set when using --step.\n";
}
# only one of --increment-revision or --revision may be chosen
if ($increment_revision && $fixed_revision) {
	&show_usage;
	die "** Only one of --increment-revision and --revision may be used.\n";
}
$revision_step = 1 if !$revision_step;

print "##### Processing:\n@ARGV\n#####\n" if $debug;
my $oldrev;
my $newrev;
my $revtest=($fixed_revision || $increment_revision) ;
my $oldtypes;
my $newtypes;
my $typetest;
my $currfile=$ARGV[0];
my $firstrun=1;
$^I='.bak' if $in_place;
while (<>) {
	print STDERR " ### Now working on $ARGV ### \n" if ($debug && $firstrun);
	# revision
	if ($revtest) {
		($oldrev)=/Revision:\s*(\S*)/;
		if ($oldrev) {
			$newrev = $oldrev;
			$newrev += $revision_step if $increment_revision;
			$newrev = $fixed_revision if $fixed_revision;
			print STDERR "## old: $oldrev\tnew: $newrev ##\n" if ($debug);
			s/(Revision:\s*)\S*/\1$newrev/ if $oldrev;
		}
	}
	# types generalized for multiline
	if ($type) {
		($oldtypes)=/$type\s*\((.*?)\)/;
		if ($oldtypes) {
			($oldtypes)=/$type\s*\((:?.*$minimum_type.*?)\)/ if ($minimum_type);
			$newtypes="$oldtypes $new_type_value";
			print STDERR "## old: $oldtypes\n## new: $newtypes\n" if ($debug && $oldtypes);
			s/($type\s*\().*?(\))/$1$newtypes$2/ if $oldtypes;
		}
	}
	print;
} continue {
	if ($currfile ne $ARGV) {
		$currfile=$ARGV;
		$firstrun=1;
	} else {
		$firstrun=0;
	}
}

sub show_usage {
	print "\nUsage:\n";
	print "\tinfo-auto-update.plx <[[--increment-revision [--step]] | [--revision]]\n";
	print "\t                      | [--type <--new-type-value> [--minimum-type]]>\n";
	print "\t                      [--debug] [--in-place] <list of .info files>\n\n";
	print "\n";
	print "\tOne of --type, --increment-revision, or --revision must be chosen.\n";
	print "\n";
	print "\tOptions:\n\n";
	print "\t--increment-revision:  increment the revision of all of the packages\n";
	print "\t  in the list of .info files.  The default increment is +1.\n";
	print "\t\t--step=<val>:  set this parameter to use an increment of <val>.\n";
	print "\n\t--revision=:  set the revision of all of the packages in the list\n";
	print "\t  to <val>.\n";
	print "\n\tOnly one of --increment-revision or --revision may be selected.\n";
	print "\n";
}
