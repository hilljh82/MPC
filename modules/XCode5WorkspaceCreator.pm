package XCode5WorkspaceCreator;

# ************************************************************
# Description   : A XCode Workspace Creator
# Author        : James H. Hill
# Create Date   : 2/4/2014
# $Id$
# ************************************************************

# ************************************************************
# Pragmas
# ************************************************************

use strict;
use XCode5ProjectCreator;
use WorkspaceCreator;

use vars qw(@ISA);
@ISA = qw(WorkspaceCreator);

# ************************************************************
# Data Section
# ************************************************************

# ************************************************************
# Subroutine Section
# ************************************************************

sub workspace_file_extension {
  return '.xcworkspacedata';
}


sub workspace_file_name {
  my $self = shift;
  my $workspace_dir  = $self->get_workspace_name () . '.xcworkspace';
  
  # The workspace files is located under a directory in the same
  # location as the workspace file.
  #
  # TODO Is this the correct way to create the new directory?
  mkdir ($workspace_dir);
  
  my $contents = $self->get_modified_workspace_name ("contents", $self->workspace_file_extension());
  return $workspace_dir . '/' . $contents;
}


sub pre_workspace {
  my($self, $fh) = @_;
  my $crlf = $self->crlf();

  ## Begin the workspace definition, which will contain all the projects.
  print $fh '<?xml version="1.0" encoding="UTF-8"?>', $crlf,
            '<Workspace version="1.0">', $crlf;
}

sub write_comps {
  my($self, $fh) = @_;
  my $crlf = $self->crlf();

  foreach my $project ($self->sort_dependencies($self->get_projects(), 0)) {
    # Remove the project file location since all we need is the directory
    # where the project file is located (i.e., the package).
    $project =~ s/\/project.pbxproj//;
 
    print $fh "  <FileRef location=\"group:$project\"></FileRef>", $crlf;
  }
}

sub post_workspace {
  my($self, $fh, $gen) = @_;
  my $crlf = $self->crlf();

  # Create a component group consisting of all the projects.
  print $fh '</Workspace>', $crlf;
}

sub get_properties {
  my $self = shift;

  ## Create the map of properties that we support.
  my $props = {};

  ## Merge in properties from all base projects
  foreach my $base (@ISA) {
    my $func = $base . '::get_properties';
    my $p = $self->$func();
    foreach my $key (keys %$p) {
      $$props{$key} = $$p{$key};
    }
  }

  return $props;
}

1;
