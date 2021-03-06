#
# VimOutliner (OTL) XHTML pretty printer for mod_perl2/apache2.
#
# Copyright (c) 2006-2009, Mahlon E. Smith <mahlon@martini.nu>
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Mahlon E. Smith nor the names of his
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

package Apache::OTL;
use strict;
use warnings;
use Apache2::Const qw/ DECLINED OK /;
use Apache2::Request;
use Apache2::RequestRec;
use Apache2::RequestUtil;
use Apache2::RequestIO;
use Apache2::Log;
use Time::HiRes 'gettimeofday';

sub handler
{
    my $VERSION = '0.6';
    my $ID      = '$Id$';
    my $r       = shift;
    my $t0      = Time::HiRes::gettimeofday;
    my (
        $file,          # the absolute file path
        $title,         # the file's title
        $uri,           # the file uri
        $data,          # file contents
        @blocks,        # todo groupings
        $mtime,         # last modification time of otl file
        $get,           # get arguments (sorting, etc)
        %opt,           # options from otl file
    );

    # sanity checks
    return DECLINED unless $r->method eq 'GET';

    ( $file, $uri ) = ( $r->filename, $r->uri );
    return DECLINED unless -e $file;
    $mtime = localtime( (stat(_))[9] );

    my $req = Apache2::Request->new($r);
    $get = $req->param || {};

    my %re = (
        title       => qr/(?:.+)?\/(.+).otl$/i,
        percent     => qr/(\[.\]) (\d+)%/,
        todo        => qr/(\[_\]) /,
        done        => qr/(\[X\]) /,
        user        => qr/^(?:\t+)?\<(.+)/,
        user_wrap   => qr/^(?:\t+)?\>(.+)/,
        body_wrap   => qr/^(?:\t+)?:(.+)/,
        body        => qr/^(?:\t+)?;(.+)/,
        time        => qr/(\d{2}:\d{2}:\d{2})/,
        date        => qr/(\d{2,4}-\d{2}-\d{2})/,
        subitem     => qr/^\t(?!\t)/,
        remove_tabs => qr/^(?:\t+)?(.+)/,
        linetext    => qr/^(?:\[.\] (?:\d+%)?)? (.+)/,

        comma_sep   => qr/(?:\s+)?\,(?:\s+)?/,
        hideline    => qr/(?:\t+)?\#/,
    );

    # snag file
    open OTL, $file
        or ( $r->log_error("Unable to read $file: $!") && return DECLINED );
    do {
        local $/ = undef;
        $data = <OTL>;  # shlorp
    };
    close OTL;

    # just spit out the plain otl if requested.
    if ( $get->{'show'} && $get->{show} eq 'source' ) {
        $r->content_type('text/plain');
        $r->print( $data );
        return OK;
    }           

    # divide each outline into groups
    # skip blocks that start with a comment '#'
    @blocks = grep { $_ !~ /^\#/ } split /\n\n+/, $data;

    # get optional settings and otl title
    {
        my $settings = shift @blocks;
        if ($settings =~ $re{user}) {
            %opt = map { split /=/ } split /\s?:/, $1;
        }
        
        # if the first group wasn't a comment,
        # we probably just aren't using a settings
        # line.  push the group back into place.
        else {
            unshift @blocks, $settings;
        }
    }

    # Now that we have tried to detect settings,
    # remove any level 0 blocks that are user data.
    @blocks = grep { $_ !~ /^[\<\>]/ } @blocks;

    # GET args override settings
    $opt{$_} = $get->{$_} foreach keys %$get;

    # set title (fallback to file uri)
    $title =
        $opt{title}
      ? $opt{title}
      : $1 if $uri =~ $re{title};

    # start html output
    $r->content_type('text/html');
    $r->print(<<EHTML);
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
    <!--
        generated by otl_handler $VERSION
        Mahlon E. Smith <mahlon\@martini.nu>
        http://projects.martini.nu/apache-otl/

        Get VimOutliner at: http://www.vimoutliner.org/
    -->
    <head>
        <title>$title</title>
EHTML

    # optional styles
    if ( $opt{style} ) {
        foreach ( split /$re{'comma_sep'}/, $opt{style} ) {
            my $media = $_ =~ /print/ ? 'print' : 'screen';
            print qq{\t<link href="$_" rel="stylesheet" media="$media" type="text/css" />\n};
        }
    }

    # optional javascript
    if ( $opt{js} ) {
        $r->print( "\t<script type=\"text/javascript\" src=\"$_\"></script>\n" )
            foreach split /$re{'comma_sep'}/, $opt{js};
        $r->print( ' ' x 4, "</head>\n" );
        $r->print( ' ' x 4, "<body>\n" );
    } else {
        $r->print(<<EHTML);
    </head>
    <body>
EHTML
    }

    # title, last modification times
    $r->print("<div class=\"header\">$opt{title}</div>\n") if $opt{title};
    $r->print("<div class=\"last_mod\">Last modified: $mtime</div>\n") if $opt{last_mod};
    if ($opt{legend}) {
        $r->print(<<EHTML);
<div class="legend">
<span class="done">Item completed</span><br />
<span class="todo">Item is incomplete</span><br />
</div>
EHTML
    }

    # sorter
    if ($opt{sort}) {
        my %sorts = (
            alpha   => 'alphabetical',
            percent => 'percentages',
        );
        $r->print("<div class=\"sort\">Sort: \n");
        foreach (sort keys %sorts) {
            if ($opt{sorttype} eq $_ && $opt{sortrev}) {
                $r->print("<a href=\"$uri?sorttype=$_\">$sorts{$_}</a>&nbsp;");
            } elsif ($opt{sorttype} eq $_ && ! $opt{sortrev}) {
                $r->print("<a href=\"$uri?sorttype=$_&sortrev=1\">$sorts{$_}</a>&nbsp;");
            } else {
                $r->print("<a href=\"$uri?sorttype=$_\">$sorts{$_}</a>&nbsp;");
            }
        }
        $r->print("</div>\n");
    }

    foreach my $block ( sort { sorter(\%opt, \%re) } @blocks ) {
        # separate outline items
        my @lines;
        foreach my $line ( split /\n/, $block ) {
            push @lines, $line unless $line =~ $re{hideline} ||
                $line =~ $re{user} || $line =~ $re{user_wrap};
        }

        my $data  = [];

        # build structure and get item counts
        my ( $subs, $comments, $subsubs ) = ( 0, 0, 0 );
        foreach ( @lines ) {
            if (/$re{body_wrap}/) {
                $comments++;
            }
            elsif (/$re{subitem}/) {
                $subs++;
            }

            my $level = 0;
            $level = $1 =~ tr/\t/\t/ if /^(\t+)/;
            $level++;

            s#$re{remove_tabs}#$1# unless $opt{'debug'};
            push @$data, [ $level, $_ ];
        }
        $subsubs = ( scalar @lines - 1 ) - $subs - $comments;

        # begin parsing structure
        $r->print("<div class=\"outline\">\n");
        $r->print("<ul>\n") unless $opt{'debug'};
        my $i = 0;
        foreach ( @$data ) {
            my ( $level, $line ) = @$_;

            if ( $opt{'debug'} ) {
                my $in = "&nbsp;" x $level x 4;
                $r->print( "$level:$in $line<br />\n" );
                next;
            }

            my $next_level = $data->[ $i+1 ] ? $data->[ $i+1 ]->[0] : 0;
            my $in = "\t" x $level;

            $line =~ s#$re{'time'}#<span class="time">$1</span>#g;
            $line =~ s#$re{date}#<span class="date">$1</span>#g;
            $line =~ s#$re{percent}#$1 <span class="percent">$2%</span>#;

            # append counts
            if ( $i == 0 && $opt{counts} && $line !~ $re{comment} ) {
                my $itmstr  = $subs == 1    ? 'item'    : 'items';
                my $sitmstr = $subsubs == 1 ? 'subitem' : 'subitems';
                $line .= " <span class=\"counts\">$subs $itmstr, $subsubs $sitmstr</span>";
            }

            my $li_class = '>';
            $li_class = ' class="todo">'        if $line =~ s#$re{todo}##;
            $li_class = ' class="done">'        if $line =~ s#$re{done}##;
            $li_class = ' class="comment_pre">' if $line =~ s#$re{body}#$1#;
            $li_class = ' class="comment">'     if $line =~ s#$re{body_wrap}#$1#;

            if ( $next_level == $level || $next_level == 0 ) {
                $r->print( "$in<li" . $li_class . "$line</li>\n" );
            }

            elsif ( $next_level < $level ) {
                $r->print( "$in<li" . $li_class . "$line</li>\n" );
                for (my $x = $level - 1; $x >= $next_level; $x--) {
                    my $in = "\t" x $x;
                    $r->print( "$in</ul>\n$in</li>\n" );
                }
            }

            else {
                # implicit: $next_level > $level AND $next_level != 0
                $r->print("$in<li" . $li_class . "$line\n$in<ul>\n");
            }

            $i++;
        }

        unless ( $opt{'debug'} ) {
            for (my $x = $data->[ scalar @$data - 1]->[0] - 1; $x > 0; $x--) {
                my $in = "\t" x $x;
                $r->print( "$in</ul>\n$in</li>\n" );
            }
            $r->print( "</ul>\n" );
        }
        $r->print( "</div>\n\n" );
    }

    my $t1 = Time::HiRes::gettimeofday;
    my $td = sprintf("%0.3f", $t1 - $t0);
    $r->print("    <div class=\"timer\">OTL parsed in $td secs</div>\n") if $opt{timer};
    $r->print(<<EHTML);
    </body>
</html>
EHTML

    return OK;
}

sub sorter
{
    my ($opt, $re) = @_;
    return 0 unless $opt->{sorttype};
    my ($sa, $sb);
    if ($opt->{sorttype} eq 'percent') {
        $sa = $2 if $a =~ $re->{percent};
        $sb = $2 if $b =~ $re->{percent};
        return $opt->{sortrev} ? $sb <=> $sa : $sa <=> $sb;
    }
    else {
        $sa = $1 if $a =~ $re->{linetext};
        $sb = $1 if $b =~ $re->{linetext};
        return $opt->{sortrev} ? $sb cmp $sa : $sa cmp $sb;
    }
}

1;

