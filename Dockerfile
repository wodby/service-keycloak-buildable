# Adds the app repository's Keycloak providers and themes to the Keycloak image
# of the service version, then runs Keycloak's build with the service's
# build-time options, so the container starts without rebuilding.
ARG WODBY_BASE_IMAGE

FROM ${WODBY_BASE_IMAGE} AS app

ARG COPY_FROM

COPY ${COPY_FROM} /tmp/app

# Keycloak's image has no package manager, so the checks run in this stage.
USER root

RUN set -e; \
    mkdir -p /tmp/out/providers /tmp/out/themes; \
    for jar in /tmp/app/providers/*.jar; do \
        [ -f "${jar}" ] || continue; \
        cp "${jar}" /tmp/out/providers/; \
    done; \
    for dir in /tmp/app/themes/*/; do \
        [ -d "${dir}" ] || continue; \
        name="$(basename "${dir}")"; \
        case "${name}" in \
            base|keycloak|keycloak.v2) \
                echo "themes/${name} has the name of one of Keycloak's own themes; rename it" >&2; \
                exit 1 ;; \
        esac; \
        if ! ls "${dir}"*/theme.properties >/dev/null 2>&1; then \
            echo "themes/${name} has no <type>/theme.properties, such as login/theme.properties, so it is not a Keycloak theme" >&2; \
            exit 1; \
        fi; \
        cp -R "${dir%/}" /tmp/out/themes/; \
    done; \
    echo "Providers: $(ls /tmp/out/providers | tr '\n' ' ')"; \
    echo "Themes: $(ls /tmp/out/themes | tr '\n' ' ')"

FROM ${WODBY_BASE_IMAGE}

COPY --from=app --chown=keycloak:root /tmp/out/providers/ /opt/keycloak/providers/
COPY --from=app --chown=keycloak:root /tmp/out/themes/ /opt/keycloak/themes/

# The service's build-time options. Keycloak rebuilds on start only when the
# options it runs with differ.
ENV KC_DB=postgres \
    KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true

RUN /opt/keycloak/bin/kc.sh build
