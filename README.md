Welcome to the smoke-phalcon overlay!
=====================================

This is where ebuilds for [Gentoo](https://www.gentoo.org/) are maintained
for the [Phalcon PHP framework](https://phalconphp.com)

The overlay is hosted on Github at:
- https://github.com/smoke/phalcon-gentoo-overlay

Hopefully it will be available soon as layman overlay and
probably in the future on the official Gentoo Overlays infrastructure.

Get Started
-----------

### Get the overlay

#### Option 1 - using portage repos.conf

Add the following settings in your /etc/portage/repos.conf or as a file /etc/portage/repos.conf/smoke-phalcon.conf
```ini
[smoke-phalcon]
location = /usr/local/phalcon-gentoo-overlay
sync-type = git
sync-uri = https://github.com/smoke/phalcon-gentoo-overlay.git
auto-sync = yes
```

Sync the overlay
```bash
emaint sync -r smoke-phalcon # or emerge --sync to sync all
```

#### Option 2 - using layman

Note this overlay is not yet available as layman overlay!
TODO - write instructions

### Emerge the package

You might need to add dev-php/phalcon in /etc/portage/package.accept_keywords
as the ebuilds are may still be keyworded.
```bash
echo "dev-php/phalcon" >> /etc/portage/package.accept_keywords
```

emerge the package
```bash
emerge dev-php/phalcon
```

Restart your webserver or php-fpm and enjoy!

General Questions and Support
-----------------------------

This overlay and its ebuilds just provide the [Phalcon PHP framework](https://phalconphp.com) package for [Gentoo](https://www.gentoo.org/)

In case of issues using these ebuilds with Gentoo please [open an issue in github in this project](https://github.com/smoke/phalcon-gentoo-overlay/issues).

In case of issues with the Phalcon itself get support from its [respective maintainers](https://github.com/phalcon/cphalcon/issues).
