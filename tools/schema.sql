-- Maintainers Table
create table m8rs (
	m8rid integer not null unique primary key,
	m8r text not null unique check(length(m8r) > 0)
);

-- Uploaders Table
create table uploaders (
	uploaderid integer not null unique primary key,
	uploader text not null unique check(length(uploader) > 0)
);

-- Groups Table
create table groups (
	groupid integer not null unique primary key,
	groupname text not null unique check(length(groupname) > 0)
);

-- Packages Table
create table pkgs (
	pkgid integer not null unique primary key,
	m8rid integer not null references m8rs(m8rid),
	uploaderid integer not null references uploaders(uploaderid),
	parentid integer references pkgs(pkgid),
	pkgname text not null check(length(pkgname) > 0),
	pkgver text not null check(length(pkgver) > 0),
	pkgdesc text not null check(length(pkgdesc) > 0),
	url text not null check(url like 'http://%' or url like 'https://%'),
	sha1sum text not null check(length(trim(sha1sum, '0123456789abcdefABCDEF')) == 0 and length(sha1sum) == 40),
	arch text not null check(arch in ('i686', 'x86_64')),
	csize integer not null,
	usize integer not null,
	updatedate integer not null,
	builddate integer not null
);

-- Groups Junction Table
create table groups_jt (
	pkgid integer not null references pkgs(pkgid),
	groupid integer not null references groups(groupid)
);

-- Depends Junction Table
create table depends_jt (
	pkgid integer not null references pkgs(pkgid),
	dependid integer not null references pkgs(pkgid)
);

-- Conflicts Junction Table
create table conflicts_jt (
	pkgid integer not null references pkgs(pkgid),
	conflictid integer not null references pkgs(pkgid)
);

-- Provides Junction Table
create table provides_jt (
	pkgid integer not null references pkgs(pkgid),
	provideid integer not null references pkgs(pkgid)
);

-- Files Table
create table files (
	fileid integer not null unique primary key,
	pkgid integer not null references pkgs(pkgid),
	type integer not null check(type between 0 and 6),
	perm integer not null check(perm between 0 and 4095),
	uid integer not null check(uid between 0 and 1023),
	gid integer not null check(gid between 0 and 1023),
	size integer not null,
	time integer not null,
	path text not null check(length(path) > 0)
);

