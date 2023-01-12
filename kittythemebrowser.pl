#!/usr/bin/env -S perl -w

# KITTY THEME BROWSER
# use + or - to scroll
# hit alphakey to jump to name
# hit enter to set permanently

use strict;
use Term::ReadKey;
use Cwd 'abs_path';

my $kittyConfigDir=$ENV{HOME}."/.config/kitty";
my $kittyThemeDir="${kittyConfigDir}/kitty-themes/themes";
my $currentTheme=abs_path($kittyConfigDir."/theme.conf");

if (! (-d $kittyThemeDir and -r $kittyThemeDir and -x $kittyThemeDir)) {
	print("Kitty theme directory (${kittyThemeDir}) does not exist.\n");
	exit 1;
}

my @themes;
opendir(DIR,$kittyThemeDir) or die;
while(defined(my $file=readdir(DIR))) {
	next if $file eq '.' or $file eq '..';
	my $f=$kittyThemeDir."/".$file;
	push @themes, $f;
}
closedir(DIR);
@themes=sort @themes;
my $idx=-1;
die("No themes!") if @themes==0;

print("
# KITTY THEME BROWSER
# use + or - to scroll
# hit alphakey to jump to name
# hit enter to set permanently (by creating a symlink)
# ctrl-c to quit

# requries kitty kitty-themes https://github.com/dexpota/kitty-themes
# and kitty remote control mode enabled

");

if($currentTheme ne $kittyConfigDir."/theme.conf" and $currentTheme=~/([^\/]+).conf$/) {
	print("# Your current saved theme is $1\n\n");
}

ReadMode('cbreak');
my $fn='';
my $lastidx=-1;
while(1) {

	my $ch=ReadKey(0);
	last unless defined $ch;
	if ($ch eq '-') {
		if($idx>0) { $idx--; } 
		else       { $idx=@themes-1; }
	}
	elsif (($ch eq '+' or $ch eq '=')) {
		if($idx<@themes-1) { $idx++; }
		else               { $idx=0; }
	}
	elsif (ord($ch)==10 and $fn ne '') { 
		my $th="${kittyConfigDir}/theme.conf";
		my $cmd="rm -f ${th}; ln -s ${fn} ${th}";
		print $cmd."\n";
		`$cmd`;
		next;
	}
	elsif($ch ge '0' and $ch le '9' or $ch ge 'a' and $ch le 'z' or $ch ge 'A' and $ch le 'Z') {
		my $jdx=search($ch);
		$idx=$jdx if ($jdx>=0);
	}
	next if $idx==$lastidx;
	$fn=${themes[${idx}]};	
	print($fn."\n");
	`kitty @ set-colors -a '${fn}'` ;
	$lastidx=$idx;
}
ReadMode('normal');

sub search {

	my ($ch,$recurseonce)=@_;
	$recurseonce=1 if (!defined $recurseonce);
	# keys @themes; # this resets the themes iterator, don't!
	while (my ($k, $v) = each @themes) {
		my @x=split "/", $v;
		my $fn=$x[@x-1];
		return $k if substr ($fn,0,1) eq $ch;
	}
	return search($ch, 0) if $recurseonce; # just makes the each loop auto skip to the beginning
	return -1;
}
