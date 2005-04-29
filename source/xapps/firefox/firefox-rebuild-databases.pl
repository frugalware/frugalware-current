#!/usr/bin/perl

use File::Path;
use File::Copy;
use File::Glob ":glob";
use POSIX ":sys_wait_h";

$timeout = 60;

%{ENV}->{"MOZILLA_FIVE_HOME"}="/usr/lib/firefox-VERSION";
%{ENV}->{"LD_LIBRARY_PATH"}="/usr/lib/firefox-VERSION";
%{ENV}->{"MOZ_DISABLE_GNOME"}="1";

umask 022;

if ( -f "/usr/lib/firefox-VERSION/regxpcom" )
{
    # remove all of the old files
    rmtree("/usr/lib/firefox-VERSION/chrome/overlayinfo");
    unlink </usr/lib/firefox-VERSION/chrome/*.rdf>;
    unlink("/usr/lib/firefox-VERSION/component.reg");
    unlink("/usr/lib/firefox-VERSION/components/compreg.dat");
    unlink("/usr/lib/firefox-VERSION/components/xpti.dat");

    # create a new clean path
    mkpath("/usr/lib/firefox-VERSION/chrome/overlayinfo");

    # rebuild the installed-chrome.txt file from the installed
    # languages
    if ( -f "/usr/lib/firefox-VERSION/chrome/lang/installed-chrome.txt" ) {
	rebuild_lang_files();
    }

    # run regxpcom
    $pid = fork();

    # I am the child.
    if ($pid == 0) {
	exec("/usr/lib/firefox-VERSION/regxpcom > /dev/null 2> /dev/null");
    }
    # I am the parent.
    else {
	my $timepassed = 0;
	do {
	    $kid = waitpid($pid, &WNOHANG);
	    sleep(1);
	    $timepassed++;
        } until $kid == -1 || $timepassed > $timeout;

	# should we kill?
	if ($timepassed > $timeout) {
	    kill (9, $pid);
	    # kill -9 can leave threads hanging around
	    system("/usr/bin/killall -9 regxpcom");
	}
    }

    # and run regchrome for good measure
    $pid = fork();

    # I am the child.
    if ($pid == 0) {
	exec("/usr/lib/firefox-VERSION/regchrome > /dev/null 2> /dev/null");
    }
    # I am the parent.
    else {
	my $timepassed = 0;
	do {
	    $kid = waitpid($pid, &WNOHANG);
	    sleep(1);
	    $timepassed++;
        } until $kid == -1 || $timepassed > $timeout;

	# should we kill?
	if ($timepassed > $timeout) {
	    kill (9, $pid);
	    # kill -9 can leave threads hanging around
	    system("/usr/bin/killall -9 regchrome");
	}
    }

}


# Exec the "generate-chome.sh" script so that installed-chrome.txt gets re-generated
exec("cd ".%{ENV}->{"MOZILLA_FIVE_HOME"}."/chrome/rc.d && ./generate-chrome.sh");


sub rebuild_lang_files {
    unlink("/usr/lib/firefox-VERSION/chrome/installed-chrome.txt");

    open (OUTPUT, "+>", "/usr/lib/firefox-VERSION/chrome/installed-chrome.txt")||
	die("Failed to open installed-chrome.txt: $!\n");

    copy("/usr/lib/firefox-VERSION/chrome/lang/installed-chrome.txt",
	 \*OUTPUT);

    foreach (bsd_glob("/usr/lib/firefox-VERSION/chrome/lang/lang-*.txt")) {
	copy($_, \*OUTPUT);
    }

    copy("/usr/lib/firefox-VERSION/chrome/lang/default.txt",
	 \*OUTPUT);
}
