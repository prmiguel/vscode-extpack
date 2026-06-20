FROM lscr.io/linuxserver/vscode:latest

# Comma-separated list of VS Code extension IDs, e.g.:
#   --build-arg VSCODE_EXTENSIONS="ms-python.python,redhat.java,vscjava.vscode-spring-boot-dashboard"
ARG VSCODE_EXTENSIONS=""

USER root
RUN chown -R abc:abc /config
COPY install-extensions.sh /tmp/install-extensions.sh
 
# Extensions must be installed as the abc user (the one VS Code actually runs as),
# not root, or they won't be picked up / will land with wrong ownership.
USER abc
 
RUN chmod +x /tmp/install-extensions.sh \
    && /tmp/install-extensions.sh "${VSCODE_EXTENSIONS}"
 
USER root
 
RUN rm -f /tmp/install-extensions.sh
