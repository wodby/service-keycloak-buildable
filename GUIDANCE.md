# Buildable Keycloak on Wodby

This service is the [keycloak](https://github.com/wodby/service-keycloak) service built from the app's repository: its
guidance applies to settings, the database, the administrator, the hostname and health checks. This page covers what
differs.

## Image

The image is built from the app's Git repository on top of the same official Keycloak image the keycloak service runs,
so the service's versions are Keycloak versions. Start the repository from the
[Keycloak boilerplate](https://github.com/wodby/keycloak-boilerplate). The build adds:

- `providers/*.jar`: custom providers (SPIs), such as authenticators, user storage, event listeners or protocol
  mappers, copied to `/opt/keycloak/providers`;
- `themes/<name>/`: themes, with one directory per type (`login`, `account`, `email`, `admin`) holding its
  `theme.properties`, copied to `/opt/keycloak/themes`.

The build fails when a theme has the name of one of Keycloak's own themes (`base`, `keycloak`, `keycloak.v2`) or has no
`theme.properties`. It then runs `kc.sh build` with the service's build-time options (PostgreSQL, health and metrics
endpoints), so the container starts without rebuilding Keycloak.

Keycloak's version comes from the service version and the image, not from the repository: providers must support it.

## Themes

Select a theme for a realm in Keycloak's administration console, under **Realm settings > Themes**. Themes are part of
the image, so changes reach Keycloak with the next deployment.
