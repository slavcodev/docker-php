# PHP Docker image

[![GitHub Actions status][ico-github-actions]][link-github]
[![Latest Release][ico-version]][link-github]
[![Software License][ico-license]][link-license]

[ico-version]: https://img.shields.io/github/tag/slavcodev/docker-php.svg?label=latest
[ico-github-actions]: https://github.com/slavcodev/docker-php/workflows/publish/badge.svg
[ico-license]: https://img.shields.io/badge/License-MIT-blue.svg

[link-github]: https://github.com/slavcodev/docker-php
[link-license]: LICENSE
[link-github-package]: https://github.com/slavcodev/docker-php/pkgs/container/docker-php

PHP is a server-side scripting language designed for web development,
but which can also be used as a general-purpose programming language.
PHP can be added to straight HTML or it can be used with a variety of templating engines and web frameworks.
PHP code is usually processed by an interpreter, which is either implemented as a native module on the web-server
or as a common gateway interface (CGI).

## Installation

Pull the image from the [Container registry][link-github-package].
This is the recommended method of installation as it is easier to update image.

```bash
docker pull ghcr.io/slavcodev/docker-php:latest
```

Build the image locally

```bash
git clone git@github.com:slavcodev/docker-php.git 
cd docker-php
docker build . --file Dockerfile \
  --tag ghcr.io/slavcodev/docker-php:latest \
  --build-arg PHP_VERSION=8.0-fpm
```

## Quick start

Using `docker-compose.yml`

```yaml
services:
  php:
    image: ghcr.io/slavcodev/docker-php:latest
    user: ${USER_ID}:${GROUP_ID}
    working_dir: /var/www/html
    volumes:
        - ${APP_COMPOSER_CACHE}:/home/.composer/cache
        - ${APP_SRC}:/var/www/html
    extra_hosts:
        - "host.docker.internal:host-gateway"
```

Alternately, you can manually launch the container.

```bash
docker run --name='php' \
    ghcr.io/slavcodev/docker-php:latest
```

# Publish changes

The image is hosted on [Container registry][link-github-package].

Read the [Working with the Container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry) 
to learn how to publish new version of image.

There is an example:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
docker push -a ghcr.io/slavcodev/docker-php
```
