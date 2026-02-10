
FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-bootc:44

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    dnf -y install dnf5-plugins && \
    dnf -y copr enable horizonproject/fernsehen && \
    dnf -y update && \
    dnf install -y \
        -x *plasma-welcome* \
        google-noto-color-emoji-fonts \
        plasma-bigscreen-git \
        plasma-setup \
        plasma-login-manager \
        konsole \
        dolphin \
        flatpak && \
    curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.plasma.emojier.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kdeconnect.app.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kmenuedit.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kdeconnect.sms.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/kdesystemsettings.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/systemsettings.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.plasma.settings.open.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/plasma-bigscreen-swap-session.desktop' && \
    sh -c 'echo NoDisplay=true >> /usr/share/wayland-sessions/plasma.desktop'
    
RUN bootc container lint
