<IfModule mod_alias.c>
    Alias /gitweb/ /var/www/gitweb/
</IfModule>

<Directory /var/www/gitweb>
    AllowOverride All
    Options ExecCGI
    SetEnv GITWEB_CONFIG /etc/gitweb.conf
    DirectoryIndex gitweb.cgi
    AddHandler cgi-script .cgi
    <IfModule mod_access.c>
        Order allow,deny
	Allow from all
    </IfModule>
</Directory>
