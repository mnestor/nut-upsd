Based on https://hub.docker.com/r/instantlinux/nut-upsd for the most part. Redid the Dockerfile to use latest alpine.

Changes from instantlinux version:
1. BUILD_FROM = alpine:latest
2. Allow non-serial ups monitoring
3. Added NOTIFYCMD which should be populated from a config section

```
    environment:
      NOTIFYCMD: /usr/bin/nut_notify
    configs:
      - source: nut_notify
        target: /usr/bin/nut_notify
```