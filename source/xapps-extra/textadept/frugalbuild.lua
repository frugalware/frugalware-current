-- Frugalware Linux FrugalBuild LPeg Lexer

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token(l.WHITESPACE, l.space^1)

-- comments
local comment = token(l.COMMENT, '#' * l.nonnewline^0)

-- strings
local sq_str = l.delimited_range("'", nil, true)
local dq_str = l.delimited_range('"', '\\', true)
local ex_str = l.delimited_range('`', '\\', true)
local heredoc = '<<' * P(function(input, index)
  local s, e, _, delimiter =
    input:find('(["\']?)([%a_][%w_]*)%1[\n\r\f;]+', index)
  if s == index and delimiter then
    local _, e = input:find('[\n\r\f]+'..delimiter, e)
    return e and e + 1 or #input + 1
  end
end)
local string = token(l.STRING, sq_str + dq_str + ex_str + heredoc)

-- numbers
local number = token(l.NUMBER, l.float + l.integer)

-- keywords
local keyword = token(l.KEYWORD, word_match({
  'if', 'then', 'elif', 'else', 'fi', 'case', 'in', 'esac', 'while', 'for',
  'do', 'done', 'continue', 'local', 'return',
  -- operators
  '-a', '-b', '-c', '-d', '-e', '-f', '-g', '-h', '-k', '-p', '-r', '-s', '-t',
  '-u', '-w', '-x', '-O', '-G', '-L', '-S', '-N', '-nt', '-ot', '-ef', '-o',
  '-z', '-n', '-eq', '-ne', '-lt', '-le', '-gt', '-ge'
}, '-'))

-- identifiers
local identifier = token(l.IDENTIFIER, l.word)

-- variables
local variable = token(l.VARIABLE, '$' * (S('!#?*@$') +
                       l.delimited_range('()', nil, true, false, '\n') +
                       l.delimited_range('[]', nil, true, false, '\n') +
                       l.delimited_range('{}', nil, true, false, '\n') +
                       l.delimited_range('`', nil, true, false, '\n') +
                       l.digit^1 +
                       l.word))

-- operators
local operator = token(l.OPERATOR, S('=!<>+-/*^~.,:;?()[]{}'))

-- functions
local func = token(l.FUNCTION, word_match {
  'Finclude', 'build', 'check_option', 'CMake_build', 'CMake_conf', 'CMake_install', 'CMake_make',
  'CMake_prepare_build', 'CMake_setup', 'Facu', 'Famsn_clean_files', 'Fant', 'Fautoconfize',
  'Fautoreconf', 'Fbuild', 'Fbuild_amsn', 'Fbuild_drupal', 'Fbuild_fonts', 'Fbuild_gnome_scriptlet',
  'Fbuild_haskell', 'Fbuild_haskell_regscripts', 'Fbuildkernel', 'Fbuild_kernelmod_scriptlet',
  'Fbuild_mono', 'Fbuildnetsurf', 'Fbuild_nvidia', 'Fbuild_nvidia_scriptlet', 'Fbuild_octave',
  'Fbuild_opensync', 'Fbuildpear', 'Fbuildpecl', 'Fbuild_perl', 'Fbuildsawfish',
  'Fbuild_slice_scrollkeeper', 'Fcd', 'Fcheckkernel', 'Fcleandestdir', '_F_clutter_getver',
  'Fconf', 'Fconfoptstryset', 'Fcp', 'Fcpr', 'Fcprel', 'Fcprrel', 'Fdesktop', 'Fdesktop2',
  'Fdeststrip', 'Fdie', 'Fdirschmod', 'Fdirschown', 'Fdoc', 'Fdocrel', 'Fexe', 'Fexec', 'Fexerel',
  'Fextract', 'Ffile', 'Ffilerel', 'Ffileschmod', 'Ffileschown', 'Fgcj', 'Fgcjshared', 'Fgenscriptlet',
  '_F_gnome_getver', 'Fgnustep_build', 'Fgnustep_init', 'Ficon', 'Ficonrel', 'Finstall', 'Finstallgem',
  'Finstallrel', 'Fjar', 'Fjavacleanup', 'Fkernel_genscriptlet_hook', 'Fkernelmod_genscriptlet_hook',
  'Fkernelver_genscriptlet_hook', 'Flastarchive', 'Flasttar', 'Flasttarbz2', 'Flasttgz', 'Fln', 'Fmake',
  'Fmakeinstall', 'Fman', 'Fmanrel', 'Fmessage', 'Fmkdir', 'Fmonocleanup', 'Fmonocompileaot', 'Fmonoexport',
  'Fmsgfmt', 'Fmv', 'Fnant', 'Fpatch', 'Fpatchall', 'Frcd', 'Frcd2', 'Freplace', 'Frm', 'Fsanitizeversion',
  'Fseamonkeyinstall', 'Fsed', 'Fsort', 'Fsplit', 'Fsubdestdir', 'Fsubdestdirinfo', 'Fsubmv', 'Ftreecmp',
  'Funpack_makeself', 'Funpack_scm', 'Fup2gnubz2', 'Fup2gnugz', 'Fuse', 'Fwcat', 'Fwrapper', 'Fxpiinstall',
  'i18n_language_from_locale', 'i18n_language_from_subtag', 'i18n_region_from_subtag', 'i18n_script_from_subtag',
  'KDE_build', 'KDE_cleanup', 'KDE_export_flags', 'KDE_install', 'KDE_make', 'KDE_make_split', 'KDE_project_install',
  'KDE_project_split', 'KDE_split', 'mozilla_i18n_foreach_lang', 'mozilla_i18n_lang_add', 'mozilla_i18n_lang_describe',
  'mozilla_i18n_lang_fini', 'mozilla_i18n_lang_install'
})

local constant = token(l.CONSTANT, word_match {
  'pkgname', 'pkgver', 'pkgrel', 'pkgdesc', 'pkgdesc_localized', 'url', 'license', 'install', 'up2date', 'source',
  'sha1sums', 'signatures', 'groups', 'archs', 'backup', 'depends', 'makedepends', 'rodepends', 'conflicts',
  'provides', 'removes', 'replaces', 'options', 'subpkgs', 'subdescs', 'subdescs_localized', 'sublicense',
  'subreplaces', 'subgroups', 'subdepends', 'subrodepends', 'subremoves', 'subconflicts', 'subprovides',
  'subbackup', 'subinstall', 'suboptions', 'subarchs', '_F_amsn_clean_files', '_F_amsn_name', '_F_archive_grep',
  '_F_archive_grepv', '_F_archive_name', '_F_archive_nolinksonly', '_F_archive_nosort', '_F_archive_prefix',
  'Farchs', '_F_aspell_lang', '_F_aspell_noverstrip', '_F_aspell_ver', '_F_berlios_dirname', '_F_berlios_ext',
  '_F_berlios_name', 'Fbuildchost', '_F_cd_path', '_F_clutter_devel', '_F_clutter_name', '_F_clutter_pkgurl',
  '_F_cmake_color', '_F_cmake_confopts', '_F_cmake_in_source_build', '_F_cmake_rpath', '_F_cmake_src',
  '_F_cmake_type', '_F_cmake_verbose', '_F_compiz_name', '_F_compiz_version', '_F_conf_configure',
  'Fconfopts', '_F_conf_outsource', '_F_conf_perl_pipefrom', '_F_desktop_categories', '_F_desktop_desc',
  '_F_desktop_exec', '_F_desktop_filename', '_F_desktop_icon', '_F_desktop_mime', '_F_desktop_mimetypes',
  '_F_desktop_name', '_F_desktop_show_in', 'Fdestdir', 'Fdestir', '_F_drupal_dev', '_F_drupal_module',
  '_F_drupal_ver', '_F_e17_name', '_F_emul_arch', '_F_emul_name', '_F_emul_ver', '_F_extract_taropts',
  '_F_firefox_ext', '_F_firefox_id', '_F_firefox_name', '_F_firefox_nocurly', '_F_fonts_dir',
  '_F_fonts_subdir', '_F_gem_name', '_F_gensciptlet_hooks', '_F_genscriptlet_hooks', '_F_genscriptlet_install',
  '_F_gnome_desktop', '_F_gnome_devel', '_F_gnome_entries', '_F_gnome_iconcache', '_F_gnome_mime', '_F_gnome_name',
  '_F_gnome_pkgurl', '_F_gnome_pygtkdefsdir', '_F_gnome_schemas', '_F_gnome_scriptlet', '_F_gnome_scrollkeeper',
  '_F_gnustep_category', '_F_gnustep_name', '_F_googlecode_dirname', '_F_googlecode_ext', '_F_googlecode_name',
  '_F_googlecode_sep', '_F_haskell_confopts', '_F_haskell_ext', '_F_haskell_install', '_F_haskell_name',
  '_F_haskell_prefix', '_F_haskell_register_dir', '_F_haskell_sep', '_F_haskell_setup', 'Fincdir', '_F_java_cflags',
  '_F_javacleanup_opts', '_F_java_compiler', '_F_java_ldflags', '_F_java_no_gcj', '_F_kde_defaults', '_F_kde_dirname',
  '_F_kde_final', '_F_kde_folder', '_F_kde_id', '_F_kde_id2', '_F_kde_mirror', '_F_kde_name', '_F_kde_pkgver',
  '_F_kde_qtver', '_F_kde_subpkgs_custom_path', '_F_kde_unstable', '_F_kde_ver', '_F_kernel_dontfakeversion',
  '_F_kernelmod_dir', '_F_kernelmod_name', '_F_kernelmod_pkgver', '_F_kernelmod_rel', '_F_kernelmod_scriptlet',
  '_F_kernelmod_uname', '_F_kernelmod_ver', '_F_kernel_name', '_F_kernel_patches', '_F_kernel_path', '_F_kernel_rel',
  '_F_kernel_stable', '_F_kernel_uname', '_F_kernel_ver', '_F_kernel_verbose', '_F_kernelver_rel', '_F_kernelver_stable',
  '_F_kernelver_ver', '_F_kernel_vmlinuz', 'Flocalstatedir', 'Fmandir', 'Fmenudir', '_F_mono_aot', '_F_mozilla_i18n_dirname',
  '_F_mozilla_i18n_mirror', '_F_mozilla_i18n_name', '_F_mozilla_i18n_xpidirname', '_F_netsurf_name', '_F_netsurf_project',
  '_F_nvidia_arch', '_F_nvidia_install', '_F_nvidia_legacyver', '_F_nvidia_linkver', '_F_nvidia_name',
  '_F_nvidia_opencl_linkver', '_F_nvidia_pkgnum', 'F_nvidia_pkgnum', '_F_nvidia_up2date', '_F_pear_name',
  '_F_pecl_name', '_F_perl_author', '_F_perl_ext', '_F_perl_name', '_F_perl_no_source', '_F_perl_no_up2date',
  '_F_perl_no_url', '_F_perl_sourcename', '_F_perl_url', 'Fpkgversep', 'Fprefix', '_F_python_libdir', '_F_python_ver',
  '_F_rcd_name', '_F_sawfish_file', '_F_sawfish_name', '_F_scm_git_cloneopts', '_F_scm_module', '_F_scm_password',
  '_F_scm_tag', '_F_scm_tag2', '_F_scm_type', '_F_scm_url', '_F_seamonkey_ext', '_F_seamonkey_name',
  '_F_seamonkey_up2date_url', '_F_sourceforge_dirname', '_F_sourceforge_ext', '_F_sourceforge_mirror',
  '_F_sourceforge_name', '_F_sourceforge_pkgver', '_F_sourceforge_prefix', '_F_sourceforge_realname',
  '_F_sourceforge_sep', '_F_sourceforge_url', 'Fsrcdir', 'Fsysconfdir', '_F_treecmp_findopts', '_F_vim_desc',
  '_F_vim_encodings', '_F_vim_lang', '_F_xfce_goodies_dir', '_F_xfce_goodies_ext', '_F_xfce_name', '_F_xfce_ver',
  '_F_xorg_dir', '_F_xorg_ind', '_F_xorg_name', '_F_xorg_release_dir', '_F_xorg_url', '_F_xorg_version'
})

_rules = {
  { 'whitespace', ws },
  { 'comment', comment },
  { 'string', string },
  { 'number', number },
  { 'keyword', keyword },
  { 'function', func },
  { 'constant', constant },
  { 'identifier', identifier },
  { 'variable', variable },
  { 'operator', operator },
  { 'any_char', l.any_char },
}
