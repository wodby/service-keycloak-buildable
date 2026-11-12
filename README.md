# Buildable Keycloak service for Kubernetes on Wodby

Run Keycloak with your own themes and providers on Kubernetes with Wodby.

This repository defines the Wodby service manifest for Keycloak built from your
Git repository: your repository holds themes and provider jars, and the build
adds them to the official Keycloak image and runs Keycloak's build.

- [Browse Wodby services](https://wodby.com/services)
- [Wodby service documentation](https://wodby.com/docs/2.0/services/)
- [Service manifest reference](https://wodby.com/docs/2.0/services/template/)

## Service overview

| Property | Manifest configuration |
| --- | --- |
| Service name | `keycloak-buildable` |
| Based on | [`keycloak`](https://github.com/wodby/service-keycloak): versions, links, settings, tokens and resources |
| Versions | Keycloak versions, as in the keycloak service |
| Type | Application service |
| Image | Built from your repository on top of the official Keycloak image |
| Application build | Themes under `themes/` and providers under `providers/`; start from the [Keycloak boilerplate](https://github.com/wodby/keycloak-boilerplate) |

Without your own themes or providers, use the [Keycloak service](https://github.com/wodby/service-keycloak): it needs
no repository or build.

## Use this service

Reference `keycloak-buildable` from a Wodby stack. A service is a reusable
component and does not deploy by itself. The stack defines its links, settings,
versions, resources, and relationship to the rest of the application.

## Maintain a custom version

1. Fork this repository.
2. Edit the service manifest and referenced files.
3. Import the repository as a [Git-backed service](https://wodby.com/docs/2.0/services/create/#create-a-git-backed-service).
4. Reference the service from a stack manifest.

Validate the manifest with:

```bash
wodby service validate-manifest service.yml --org <org-id>
```

See the [service manifest reference](https://wodby.com/docs/2.0/services/template/) and the [managed services index](https://github.com/wodby/services).
