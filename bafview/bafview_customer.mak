
###############################################################################
# Sample windows GNUmake Makefile for BAFVIEW.  This makefile assumes that the
# code tree is structured as follows:
#
#  <ROOT DIR>\jobs\w32\<this makefile>
#
#  <ROOT DIR>\tools\bafview\<bafview source files>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
#
###############################################################################

###############################################################################
# Ignore errors and continue build.
###############################################################################
.IGNORE:

###############################################################################
# Global Macros.
###############################################################################
CC = cl.exe
LINK = link.exe
VPATH = ../../tools/bafview;

###############################################################################
# release configuration macros for BAFVIEW.
###############################################################################
release_clean release : INTERMEDIATE_DIR = ./release/bafview
RELEASE_OUTPUT_DIR = ./release
RELEASE_DEFINES = /D "WIN32" /D "_WINDOWS"
RELEASE_OPTIONS = /nologo /ML /W4 /GX /Od /YX /FD /GZ /c
RELEASE_INCLUDES = \
	/I "../../tools/bafview" \

RELEASE_LIBRARIES = setargv.obj kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
RELEASE_LIBPATHS = ./release;
RELEASE_DEF_FILES =
RELEASE_LINK_OPTIONS = /nologo /subsystem:console /pdb:"./release/bafview\bafview.pdb" /machine:I386

RELEASE_OBJS =  \
	./release/bafview/bafdecod.obj \
	./release/bafview/bafdisp.obj \
	./release/bafview/baffield.obj \
	./release/bafview/bafmain.obj \
	./release/bafview/bafutil.obj


###############################################################################
# debug configuration macros for BAFVIEW.
###############################################################################
debug_clean debug : INTERMEDIATE_DIR = ./debug/bafview
DEBUG_OUTPUT_DIR = ./debug
DEBUG_DEFINES = /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "NBB_DEBUG"
DEBUG_OPTIONS = /nologo /W4 /Gm /GX /Zi /Od /YX /FD /GZ /c
DEBUG_INCLUDES = \
	/I "../../tools/bafview" \

DEBUG_LIBRARIES = setargv.obj kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib
DEBUG_LIBPATHS = ./debug;
DEBUG_DEF_FILES =
DEBUG_LINK_OPTIONS = /nologo /subsystem:console /debug /machine:I386 /pdb:"./debug/bafview\bafview.pdb"

DEBUG_OBJS =  \
	./debug/bafview/bafdecod.obj \
	./debug/bafview/bafdisp.obj \
	./debug/bafview/baffield.obj \
	./debug/bafview/bafmain.obj \
	./debug/bafview/bafutil.obj

###############################################################################
# Global target definitions for BAFVIEW.
###############################################################################
all: release debug

clean: release_clean debug_clean

.PHONY: release_clean release debug_clean debug

###############################################################################
# An error-handler that renames any .war (warning) files to .erl (error)      #
# files if the target did not build.  If a .war file has no content, it is    #
# removed.                                                                    #
###############################################################################
ERR_WARN_FILE =	\
	@if [ -s $(INTERMEDIATE_DIR)/$*.war ]; then \
		if [ ! -f $@ ]; then \
		mv $(INTERMEDIATE_DIR)/$*.war $(INTERMEDIATE_DIR)/$*.erl; \
		fi; \
	else \
		/bin/rm $(INTERMEDIATE_DIR)/$*.war; \
	fi

###############################################################################
# release configuration target definitions for BAFVIEW.
###############################################################################
release_clean:
	@echo Removing release object files
	@$(RM) $(RELEASE_OBJS)
	@echo Removing release binary file: $(RELEASE_OUTPUT_DIR)/bafview.exe
	@$(RM) $(RELEASE_OUTPUT_DIR)/bafview.exe
	@echo Removing release error and warning files
	@$(RM) $(INTERMEDIATE_DIR)/*.war $(INTERMEDIATE_DIR)/*.erl

release: $(RELEASE_OBJS)
	@if [ ! -d $(RELEASE_OUTPUT_DIR) ]; then mkdir -p $(RELEASE_OUTPUT_DIR); fi
	@echo Linking $(RELEASE_OUTPUT_DIR)/bafview.exe
	@$(LINK) $(RELEASE_LINK_OPTIONS) $(RELEASE_DEF_FILES) /out:"$(RELEASE_OUTPUT_DIR)/bafview.exe" $(RELEASE_OBJS) $(patsubst %;,/libpath:"%",$(subst /,\,$(RELEASE_LIBPATHS))) $(subst /,\,$(RELEASE_LIBRARIES))

###############################################################################
# Rule for making individual object files for BAFVIEW.
###############################################################################
$(RELEASE_OBJS): ./release/bafview/%.obj: %.c
	@if [ ! -d $(INTERMEDIATE_DIR) ]; then mkdir -p $(INTERMEDIATE_DIR); fi
	@if [ -s $(INTERMEDIATE_DIR)/$*.war ]; then $(RM) $(INTERMEDIATE_DIR)/$*.war; fi
	@if [ -s $(INTERMEDIATE_DIR)/$*.erl ]; then $(RM) $(INTERMEDIATE_DIR)/$*.erl; fi
	@echo Compiling $< 	-\>	$@
	@$(CC) $(RELEASE_OPTIONS) $(RELEASE_DEFINES) $(RELEASE_INCLUDES) /Fo"$(subst /,\,$(INTERMEDIATE_DIR))\\" "$(subst /,\,$<)"

###############################################################################
# debug configuration target definitions for BAFVIEW.
###############################################################################
debug_clean:
	@echo Removing debug object files
	@$(RM) $(DEBUG_OBJS)
	@echo Removing debug binary file: $(DEBUG_OUTPUT_DIR)/bafview.exe
	@$(RM) $(DEBUG_OUTPUT_DIR)/bafview.exe
	@echo Removing debug error and warning files
	@$(RM) $(INTERMEDIATE_DIR)/*.war $(INTERMEDIATE_DIR)/*.erl

debug: $(DEBUG_OBJS)
	@if [ ! -d $(DEBUG_OUTPUT_DIR) ]; then mkdir -p $(DEBUG_OUTPUT_DIR); fi
	@echo Linking $(DEBUG_OUTPUT_DIR)/bafview.exe
	@$(LINK) $(DEBUG_LINK_OPTIONS) $(DEBUG_DEF_FILES) /out:"$(DEBUG_OUTPUT_DIR)/bafview.exe" $(DEBUG_OBJS) $(patsubst %;,/libpath:"%",$(subst /,\,$(DEBUG_LIBPATHS))) $(subst /,\,$(DEBUG_LIBRARIES))

###############################################################################
# Rule for making individual object files for BAFVIEW.
###############################################################################
$(DEBUG_OBJS): ./debug/bafview/%.obj: %.c
	@if [ ! -d $(INTERMEDIATE_DIR) ]; then mkdir -p $(INTERMEDIATE_DIR); fi
	@if [ -s $(INTERMEDIATE_DIR)/$*.war ]; then $(RM) $(INTERMEDIATE_DIR)/$*.war; fi
	@if [ -s $(INTERMEDIATE_DIR)/$*.erl ]; then $(RM) $(INTERMEDIATE_DIR)/$*.erl; fi
	@echo Compiling $< 	-\>	$@
	@$(CC) $(DEBUG_OPTIONS) $(DEBUG_DEFINES) $(DEBUG_INCLUDES) /Fo"$(subst /,\,$(INTERMEDIATE_DIR))\\" "$(subst /,\,$<)"

