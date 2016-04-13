package XCode5ProjectCreator;

# ************************************************************
# Description   : A XCode Project Creator
# Author        : James H. Hill
# Create Date   : 2/4/2014
# $Id$
# ************************************************************

# ************************************************************
# Pragmas
# ************************************************************

use strict;
use ProjectCreator;

use vars qw(@ISA);
@ISA = qw(ProjectCreator);

# ************************************************************
# Data Section
# ************************************************************

my(@uid_framework_buildfiles) = ();
my(@uid_source_buildfiles) = ();
my(@uid_header_buildfiles) = ();
my(@uid_custom_buildfiles) = ();

my(@uid_framework_fileref) = ();
my(@uid_source_fileref) = ();
my(@uid_header_fileref) = ();
my(@uid_custom_fileref) = ();
my($uid_copyfile_fileref);
my($uid_output_fileref);

my(@uid_framework_list) = ();
my(@uid_sourcefile_list) = ();
my(@uid_headerfile_list) = ();
my(@uid_inlinefile_list) = ();
my(@uid_templatefile_list) = ();
my(@uid_customfile_list) = ();

my(@uid_buildrule_list) = ();
my(@uid_custom_types) = ();

my($uid_outputfile);
my($uid_pbxproject);
my($uid_frameworks);
my($uid_sources);
my($uid_PBXGroup);
my($uid_Products);
my($uid_project_group);

my($uid_copyfiles);

my($uid_template_files);
my($uid_header_files);
my($uid_inline_files);

my($uid_pbxnativetarget);
my($uid_pbxnativetarget_configlist);
my(@uid_pbxnativetarget_configs) = ();
my($uid_pbxproject_configlist);
my(@uid_pbxproject_configs) = ();

# ************************************************************
# Subroutine Section
# ************************************************************

sub project_file_extension {
  return ".xcodeproj";
}

sub project_file_name () {
  my($self, $name, $template) = @_;
  $name = $self->get_assignment('project_name') if (!defined $name);
  
  return "$name.xcodeproj/project.pbxproj";
}

sub mpc_dirname () {
  my($self, $name) = @_;  
  $name =~ s/project.pbxproj//;
  return $name;
}

sub get_dll_exe_template_input_file {
  #my $self = shift;
  return 'xcode5';
}


sub get_lib_exe_template_input_file {
  #my $self = shift;
  return 'xcode5';
}


sub get_lib_template_input_file {
  #my $self = shift;
  return 'xcode5';
}


sub get_dll_template_input_file {
  #my $self = shift;
  return 'xcode5';
}

sub fill_value {
  my($self, $name) = @_;
 
  if ($name eq 'genuid') {
    return $self->genuid();
  }
  elsif ($name eq 'genuid_source_buildfile') {
    my($uid) = $self->genuid();
    push (@uid_source_buildfiles, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_framework_buildfile') {
    my($uid) = $self->genuid();
    push (@uid_framework_buildfiles, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_custom_buildfile') {
    my($uid) = $self->genuid();
    push (@uid_custom_buildfiles, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_custom_buildfile_placeholder') {
    push (@uid_custom_buildfiles, $self->genuid());
  }
  elsif ($name eq 'genuid_buildrule') {
    my($uid) = $self->genuid();
    push (@uid_buildrule_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_source_buildfile') {
    return shift @uid_source_buildfiles;
  }
  elsif ($name eq 'getuid_framework_buildfile') {
    return shift @uid_framework_buildfiles;
  }
  elsif ($name eq 'getuid_custom_buildfile') {
    return shift @uid_custom_buildfiles;
  }
  elsif ($name eq 'getuid_custom_buildfile_placeholder') {
    shift @uid_custom_buildfiles;
  }
  elsif ($name eq 'uid_output_fileref') {
    if (!$uid_output_fileref) {
      $uid_output_fileref = $self->genuid ();
    }
    
    return $uid_output_fileref;
  }
  elsif ($name eq 'genuid_source_fileref') {
    my($uid) = $self->genuid();
    push (@uid_source_fileref, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_header_fileref') {
    my($uid) = $self->genuid();
    push (@uid_header_fileref, $uid);
    
    return $uid;
  }   
  elsif ($name eq 'genuid_framework_fileref') {
    my($uid) = $self->genuid();
    push (@uid_framework_fileref, $uid);
    
    return $uid;
  }   
  elsif ($name eq 'genuid_custom_fileref') {
    my($uid) = $self->genuid();
    push (@uid_custom_fileref, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_custom_fileref_placeholder') {
    my($uid) = $self->genuid();
    push (@uid_custom_fileref, $uid);
  }
  elsif ($name eq 'genuid_custom_type') {
    my($uid) = $self->genuid();
    push (@uid_custom_types, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_custom_type') {
    return shift @uid_custom_types;
  }
  elsif ($name eq 'getuid_source_fileref') {
    my($uid) = shift @uid_source_fileref;
    push (@uid_sourcefile_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_header_fileref') {
    my($uid) = $self->genuid();
    push (@uid_headerfile_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_inline_fileref') {
    my($uid) = $self->genuid();
    push (@uid_inlinefile_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_template_fileref') {
    my($uid) = $self->genuid();
    push (@uid_templatefile_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_framework_fileref') {
    my($uid) = shift @uid_framework_fileref;
    push (@uid_framework_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_custom_fileref') {
    my($uid) = shift @uid_custom_fileref;
    push (@uid_customfile_list, $uid);
    
    return $uid;
  }
  elsif ($name eq 'genuid_copyfile_fileref') {
    $uid_copyfile_fileref = $self->genuid();
    return $uid_copyfile_fileref;
  }
  elsif ($name eq 'getuid_sourcefile') {
    return shift @uid_sourcefile_list;
  }
  elsif ($name eq 'getuid_headerfile') {
    return shift @uid_headerfile_list;
  }
  elsif ($name eq 'getuid_inlinefile') {
    return shift @uid_inlinefile_list;
  }
  elsif ($name eq 'getuid_templatefile') {
    return shift @uid_templatefile_list;
  }
  elsif ($name eq 'getuid_framework') {
    return shift @uid_framework_list;
  }
  elsif ($name eq 'getuid_buildrule') {
    return shift @uid_buildrule_list;
  }
  elsif ($name eq 'getuid_customfile') {
    return shift @uid_customfile_list;
  }
  elsif ($name eq 'uid_outputfile') {
    if (!$uid_outputfile) {
      $uid_outputfile = $self->genuid ();
    }
    
    return $uid_outputfile;
  }
  elsif ($name eq 'uid_pbxproject') {
    if (!$uid_pbxproject) {
      $uid_pbxproject = $self->genuid ();
    }
    
    return $uid_pbxproject;
  }
  elsif ($name eq 'uid_frameworks') {
    if (!$uid_frameworks) {
      $uid_frameworks = $self->genuid ();
    }
    
    return $uid_frameworks;
  }
  elsif ($name eq 'uid_sources') {
    if (!$uid_sources) {
      $uid_sources = $self->genuid ();      
    }
    
    return $uid_sources;
  }
  elsif ($name eq 'uid_pbxgroup') {
    if (!$uid_PBXGroup) {
      $uid_PBXGroup = $self->genuid ();
    }
    
    return $uid_PBXGroup;
  }
  elsif ($name eq 'uid_products') {
    if (!$uid_Products) {
      $uid_Products = $self->genuid ();
    }
    
    return $uid_Products;
  }
  elsif ($name eq 'uid_copyfiles') {
    if (!$uid_copyfiles) {
      $uid_copyfiles = $self->genuid ();
    }
    
    return $uid_copyfiles;
  }
  elsif ($name eq 'uid_project_group') {
    if (!$uid_project_group) {
      $uid_project_group = $self->genuid ();
    }
    
    return $uid_project_group;
  }
  elsif ($name eq 'uid_pbxnativetarget') {
    if (!$uid_pbxnativetarget) {
      $uid_pbxnativetarget = $self->genuid ();
    }
    
    return $uid_pbxnativetarget;   
  }
  elsif ($name eq 'uid_template_files') {
    if (!$uid_template_files) {
      $uid_template_files = $self->genuid ();
    }
    
    return $uid_template_files;   
  }
  elsif ($name eq 'uid_inline_files') {
    if (!$uid_inline_files) {
      $uid_inline_files = $self->genuid ();
    }
    
    return $uid_inline_files;   
  }
  elsif ($name eq 'uid_header_files') {
    if (!$uid_header_files) {
      $uid_header_files = $self->genuid ();
    }
    
    return $uid_header_files;   
  }
  elsif ($name eq 'uid_pbxnativetarget_configlist') {
    if (!$uid_pbxnativetarget_configlist) {
      $uid_pbxnativetarget_configlist = $self->genuid ();
    }
    
    return $uid_pbxnativetarget_configlist;   
  }
  elsif ($name eq 'genuid_pbxnativetarget_config') {
    my($uid) = $self->genuid ();
    push (@uid_pbxnativetarget_configs, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_pbxnativetarget_config') {
    return shift @uid_pbxnativetarget_configs;
  }
  elsif ($name eq 'uid_pbxproject_configlist') {
    if (!$uid_pbxproject_configlist) {
      $uid_pbxproject_configlist = $self->genuid ();
    }
    
    return $uid_pbxproject_configlist;   
  }
  elsif ($name eq 'genuid_pbxproject_config') {
    my($uid) = $self->genuid ();
    push (@uid_pbxproject_configs, $uid);
    
    return $uid;
  }
  elsif ($name eq 'getuid_pbxproject_config') {
    return shift @uid_pbxproject_configs;
  }
  
  return undef;
}

sub genuid () {
  my(@set) = ('0' ..'9', 'A' .. 'F');
  my($str) = join '' => map $set[rand @set], 1 .. 24;
  
  return $str;
}

1;
