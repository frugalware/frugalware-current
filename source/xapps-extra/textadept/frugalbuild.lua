--[[
  Mitchell's lexers/shellscript.lua
  Copyright (c) 2006-2009 Mitchell Foral. All rights reserved.

  SciTE-tools homepage: http://caladbolg.net/scite.php
  Send email to: mitchell<att>caladbolg<dott>net

  Permission to use, copy, modify, and distribute this file
  is granted, provided credit is given to Mitchell.

  Shell LPeg lexer
]]--

module(..., package.seeall)
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local ws = token('whitespace', space^1)

-- comments
local comment = token('comment', '#' * nonnewline^0)

-- strings
local sq_str = delimited_range("'", nil, true)
local dq_str = delimited_range('"', '\\', true)
local ex_str = delimited_range('`', '\\', true)
local heredoc = '<<' * P(function(input, index)
  local s, e, _, delimiter = input:find('(["\']?)([%a_][%w_]*)%1[\n\r\f;]+', index)
  if s == index and delimiter then
    local _, e = input:find('[\n\r\f]+'..delimiter, e)
    return e and e + 1 or #input + 1
  end
end)
local string = token('string', sq_str + dq_str + ex_str + heredoc)

-- numbers
local number = token('number', float + integer)

-- keywords
local keyword = token('keyword', word_match(word_list{
  'if', 'then', 'elif', 'else', 'fi', 'case', 'in', 'esac', 'while', 'for',
  'do', 'done', 'continue', 'local', 'return',
  -- operators
  '-a', '-b', '-c', '-d', '-e', '-f', '-g', '-h', '-k', '-p', '-r', '-s', '-t',
  '-u', '-w', '-x', '-O', '-G', '-L', '-S', '-N', '-nt', '-ot', '-ef', '-o',
  '-z', '-n', '-eq', '-ne', '-lt', '-le', '-gt', '-ge'
}, '-'))

-- identifiers
local identifier = token('identifier', word)

-- variables
local variable = token('variable', '$' * (S('!#?*@$') +
  delimited_range('()', nil, true, false, '\n') +
  delimited_range('[]', nil, true, false, '\n') +
  delimited_range('{}', nil, true, false, '\n') +
  delimited_range('`', nil, true, false, '\n') +
  digit^1 +
  word))

-- functions
local functions = token('function', word_match(word_list{
  'CMake_build', 'CMake_conf', 'CMake_make', 'CMake_prepare_build', 'Facu',
  'Famsn_clean_files', 'Fant', 'Fautoconfize', 'Fautoreconf', 'Fbuild',
  'Fbuild_amsn', 'Fbuild_drupal', 'Fbuild_fonts', 'Fbuild_gnome_scriptlet',
  'Fbuild_haskell', 'Fbuild_haskell_regscripts', 'Fbuild_kde',
  'Fbuild_kde_reconf', 'Fbuild_kde_split_docs', 'Fbuild_kernelmod_scriptlet',
  'Fbuild_mono', 'Fbuild_nvidia', 'Fbuild_nvidia_scriptlet', 'Fbuild_octave',
  'Fbuild_opensync', 'Fbuild_perl', 'Fbuild_rox', 'Fbuild_slice_scrollkeeper',
  'Fbuild_thunderbird_i18n_scriptlet', 'Fbuildkernel', 'Fbuildpear',
  'Fbuildpecl', 'Fbuildsawfish', 'Fcd', 'Fcheckkernel', 'Fconf',
  'Fconfoptstryset', 'Fcp', 'Fcpr', 'Fcprel', 'Fcprrel', 'Fdesktop',
  'Fdesktop2', 'Fdeststrip', 'Fdie', 'Fdirschmod', 'Fdirschown', 'Fdoc',
  'Fdocrel', 'Fexe', 'Fexec', 'Fexerel', 'Fextract', 'Ffile', 'Ffilerel',
  'Ffileschmod', 'Ffileschown', 'Fgcj', 'Fgcjshared', 'Fgnustep_build',
  'Fgnustep_init', 'Ficon', 'Ficonrel', 'Finstall', 'Finstallgem',
  'Finstallrel', 'Fjar', 'Fjavacleanup', 'Flastarchive', 'Flasttar',
  'Flasttarbz2', 'Flasttgz', 'Fln', 'Fmake', 'Fmakeinstall', 'Fman',
  'Fmanrel', 'Fmessage', 'Fmkdir', 'Fmonocleanup', 'Fmonocompileaot',
  'Fmonoexport', 'Fmsgfmt', 'Fmv', 'Fnant', 'Fpatch', 'Fpatchall', 'Frcd',
  'Frcd2', 'Frm', 'Frox_cleanup', 'Frox_compile', 'Frox_install',
  'Frox_mkdir', 'Frox_setup', 'Fsanitizeversion', 'Fseamonkeyinstall',
  'Fsed', 'Fsort', 'Fsplit', 'Funpack_makeself', 'Funpack_scm', 'Fup2gnubz2',
  'Fup2gnugz', 'Fuse', 'Fwrapper', 'Fxpiinstall', 'build', 'check_option',
  'Finclude'
}))

-- constants (variable names)
local constants = token('constant', word_match(word_list{
  '_F_amsn_clean_files', '_F_amsn_name', '_F_archive_grep', '_F_archive_grepv',
  '_F_archive_name', '_F_archive_nolinksonly', '_F_archive_nosort',
  '_F_archive_prefix', '_F_aspell_lang', '_F_aspell_noverstrip',
  '_F_aspell_ver', '_F_berlios_dirname', '_F_berlios_ext', '_F_berlios_name',
  '_F_cd_path', '_F_clutter_devel', '_F_clutter_name', '_F_clutter_pkgurl',
  '_F_cmake_color', '_F_cmake_confopts', '_F_cmake_type', '_F_cmake_verbose',
  '_F_compiz_name', '_F_compiz_version', '_F_conf_configure',
  '_F_conf_perl_pipefrom', '_F_desktop_categories', '_F_desktop_desc',
  '_F_desktop_exec', '_F_desktop_filename', '_F_desktop_icon',
  '_F_desktop_mime', '_F_desktop_name', '_F_desktop_show_in',
  '_F_drupal_dev', '_F_drupal_module', '_F_drupal_ver', '_F_e17_name',
  '_F_emul_arch', '_F_firefox_ext', '_F_firefox_id', '_F_firefox_name',
  '_F_firefox_nocurly', '_F_fonts_subdir', '_F_gem_name', '_F_gnome_desktop',
  '_F_gnome_devel', '_F_gnome_entries', '_F_gnome_iconcache',
  '_F_gnome_mime', '_F_gnome_name', '_F_gnome_pkgurl', '_F_gnome_pygtkdefsdir',
  '_F_gnome_schemas', '_F_gnome_scriptlet', '_F_gnome_scrollkeeper',
  '_F_gnustep_name', '_F_googlecode_dirname', '_F_googlecode_ext',
  '_F_googlecode_name', '_F_googlecode_sep', '_F_haskell_confopts',
  '_F_haskell_ext', '_F_haskell_install', '_F_haskell_name',
  '_F_haskell_prefix', '_F_haskell_register_dir', '_F_haskell_sep',
  '_F_java_cflags', '_F_java_compiler', '_F_java_jars', '_F_java_ldflags',
  '_F_javacleanup_opts', '_F_kde_build_debug', '_F_kde_defaults',
  '_F_kde_do_not_compile', '_F_kde_id', '_F_kde_id2', '_F_kde_name',
  '_F_kde_reconf', '_F_kde_split_docs', '_F_kde_ver',
  '_F_kernel_dontfakeversion', '_F_kernel_name', '_F_kernel_path',
  '_F_kernel_rel', '_F_kernel_stable', '_F_kernel_uname', '_F_kernel_ver',
  '_F_kernel_vmlinuz', '_F_kernelmod_dir', '_F_kernelmod_name',
  '_F_kernelmod_pkgver', '_F_kernelmod_rel', '_F_kernelmod_scriptlet',
  '_F_kernelmod_uname', '_F_kernelmod_ver', '_F_kernelver_rel',
  '_F_kernelver_stable', '_F_kernelver_ver', '_F_nvidia_arch',
  '_F_nvidia_install', '_F_nvidia_legacyver', '_F_nvidia_linkver',
  '_F_nvidia_name', '_F_nvidia_pkgnum', '_F_nvidia_up2date', '_F_pear_name',
  '_F_pecl_name', '_F_perl_author', '_F_perl_ext', '_F_perl_name',
  '_F_perl_no_source', '_F_perl_no_up2date', '_F_perl_no_url',
  '_F_perl_sourcename', '_F_perl_url', '_F_python_libdir', '_F_python_ver',
  '_F_rcd_name', '_F_rox_name', '_F_rox_sep', '_F_rox_subdir',
  '_F_rox_use_hayber', '_F_rox_use_kerofin', '_F_rox_use_rox4debian',
  '_F_rox_use_sourceforge', '_F_sawfish_file', '_F_sawfish_name',
  '_F_scm_module', '_F_scm_password', '_F_scm_tag', '_F_scm_type',
  '_F_scm_url', '_F_seamonkey_ext', '_F_seamonkey_name',
  '_F_seamonkey_up2date_url', '_F_sourceforge_broken_up2date',
  '_F_sourceforge_dirname', '_F_sourceforge_ext', '_F_sourceforge_mirror',
  '_F_sourceforge_name', '_F_sourceforge_pkgver', '_F_sourceforge_prefix',
  '_F_sourceforge_sep', '_F_vim_desc', '_F_vim_encodings', '_F_vim_lang',
  '_F_vim_sug_encodings', '_F_xfce_goodies_dir', '_F_xfce_goodies_ext',
  '_F_xfce_name', '_F_xorg_ind', '_F_xorg_name', 'pkgname', 'pkgver',
  'pkgrel', 'pkgdesc', 'pkgdesc_localized', 'url', 'license', 'install',
  'up2date', 'source', 'sha1sums', 'signatures', 'groups', 'archs', 'backup',
  'depends', 'makedepends', 'rodepends', 'conflicts', 'provides', 'removes',
  'replaces', 'options', 'subpkgs', 'subdescs', 'subdescs_localized',
  'sublicense', 'subreplaces', 'subgroups', 'subdepends', 'subrodepends',
  'subremoves', 'subconflicts', 'subprovides', 'subbackup', 'subinstall',
  'suboptions', 'subarchs'
}))

-- operators
local operator = token('operator', S('=!<>+-/*^~.,:;?()[]{}'))

function LoadTokens()
  add_token(frugalbuild, 'whitespace', ws)
  add_token(frugalbuild, 'comment', comment)
  add_token(frugalbuild, 'string', string)
  add_token(frugalbuild, 'number', number)
  add_token(frugalbuild, 'keyword', keyword)
  add_token(frugalbuild, 'function', functions)
  add_token(frugalbuild, 'constant', constants)
  add_token(frugalbuild, 'identifier', identifier)
  add_token(frugalbuild, 'variable', variable)
  add_token(frugalbuild, 'operator', operator)
  add_token(frugalbuild, 'any_char', any_char)
end
