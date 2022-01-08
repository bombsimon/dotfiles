#!/usr/bin/env perl

=head1 DESCRIPTION

This script is to be run once when setting up a new machine. It will configure
the global essentials and even if it's idempotent there  should never be a need
to run this more than once.

=cut

use warnings;
use strict;
use feature qw( say );

use Carp qw( croak );

exit main();

sub main {
    my $os = $^O;

    ssh_config();

    if ( $os eq "darwin" ) {
        macos_key_repeat();
        macos_setup_shortcuts();
        macos_reload_settings();
    }

    return 1;
}

sub ssh_config {
    my $ssh_config_file = "$ENV{HOME}/.ssh/config";

    return if -f $ssh_config_file;

    my $ssh_config = <<"EOF";
Host github.com
  HostName github.com

Host gist.github.com
  HostName gist.github.com

Host gist.github.com github.com
  Port 22
  User git
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes
  ForwardAgent yes
  AddKeysToAgent yes
EOF

    open my $fh, ">>", $ssh_config_file || croak "Could not open file for writing: $!";
    print $fh $ssh_config;
    close $fh;

    return 1;
}

sub macos_reload_settings {
    my $reload_settings_cmd
      = "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u";

    system( $reload_settings_cmd );

    return 1;
}

sub macos_key_repeat {
    # More keys can be found here: https://mths.be/macos
    my @cmds = (
        # Enable key repeat and set it's speed
        "defaults write com.apple.Accessibility KeyRepeatDelay -float 0.5",
        "defaults write com.apple.Accessibility KeyRepeatInterval -float 0.083333333",
        "defaults write NSGlobalDomain KeyRepeat -int 2",
        "defaults write NSGlobalDomain InitialKeyRepeat -int 20",

        # Use scroll gesture with the Ctrl (^) modifier key to zoom
        "defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true",
        "defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144",

        # Follow the keyboard focus while zoomed in
        "defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true",

        # Allow to tab between modal button
        "defaults write NSGlobalDomain AppleKeyboardUIMode -int 2",
    );

    foreach my $cmd ( @cmds ) {
        system( $cmd);
    }

    return 1;

}

sub macos_setup_shortcuts {
    # The way I got these codes was to set the default settings, then dump my
    # config with:
    #
    #     defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys > 1
    #
    # Then I changed to my preferred settings and ran
    #
    #     defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys > 2
    #
    # And finally I diffed the files to see what I had changed.
    #
    #     diff -U5 -u 1 2
    my $symbolic_hotkeys_plist_file = "~/Library/Preferences/com.apple.symbolichotkeys.plist";
    my $plist_buddy_bin             = "/usr/libexec/PlistBuddy";

    my @settings = (
        {
            description => "Save picture of screen to file",
            id          => 28,
            parameters  => [ 51, 20, 1441792 ],
        },
        {
            description => "Copy picture of screen to the clipboard",
            id          => 29,
            parameters  => [ 51, 20, 1179648 ],
        },
        {
            description => "Save picture of selected area to file",
            id          => 30,
            parameters  => [ 52, 21, 1441792 ],
        },
        {
            description => "Copy picture of selected area to the clipboard",
            id          => 31,
            parameters  => [ 52, 21, 1179648 ],
        },
        {
            description => "Show Spotlight search",
            id          => 64,
            parameters  => [ 32, 49, 262144 ],
        },
        {
            description => "Mission control",
            disable     => 1,
            ids         => [ 32, 34 ],
        },
        {
            description => "Application window",
            disable     => 1,
            ids         => [ 33, 35 ],
        },
        {
            description => "Move left a space",
            disable     => 1,
            ids         => [ 79, 80 ],
        },
        {
            description => "Move right a space",
            disable     => 1,
            ids         => [ 81, 82 ],
        },
    );

    foreach my $setting ( @settings ) {
        my $action = $setting->{disable} ? "Disabling" : "Configuring";
        say "$action '$setting->{description}'";

        my @cmds = ();

        if ( $setting->{disable} ) {
            foreach my $id ( @{ $setting->{ids} } ) {
                push @cmds,
                  sprintf( '%s -c "Set :AppleSymbolicHotKeys:%d:enabled bool false" %s',
                    $plist_buddy_bin, $id, $symbolic_hotkeys_plist_file );
            }
        }
        else {
            push @cmds,
              (
                sprintf(
                    '%s -c "Delete :AppleSymbolicHotKeys:%d:value:parameters" %s',
                    $plist_buddy_bin, $setting->{id}, $symbolic_hotkeys_plist_file
                ),
                sprintf(
                    '%s -c "Add :AppleSymbolicHotKeys:%d:value:parameters array" %s',
                    $plist_buddy_bin, $setting->{id}, $symbolic_hotkeys_plist_file
                ),
              );

            foreach my $param ( @{ $setting->{parameters} } ) {
                push @cmds,
                  sprintf( '%s -c "Add :AppleSymbolicHotKeys:%d:value:parameters: integer %d" %s',
                    $plist_buddy_bin, $setting->{id}, $param, $symbolic_hotkeys_plist_file );
            }
        }

        foreach my $cmd ( @cmds ) {
            system( $cmd );
        }
    }

    return 1;
}

