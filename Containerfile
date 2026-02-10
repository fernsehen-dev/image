FROM scratch AS ctx
COPY build_files /

FROM quay.io/fedora/fedora-bootc:44

COPY system_files /

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
        plasma-workspace-wallpapers \
        qmlkonsole \
        dolphin \
        flatpak && \
    dnf -y copr enable ublue-os/staging && \
    dnf -y install bazaar && \
    dnf -y copr disable ublue-os/staging && \
    dnf -y copr disable horizonproject/fernsehen && \
    curl --retry 3 -Lo /etc/flatpak/remotes.d/flathub.flatpakrepo https://dl.flathub.org/repo/flathub.flatpakrepo && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.plasma.emojier.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kdeconnect.app.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kmenuedit.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.kdeconnect.sms.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/kdesystemsettings.desktop' && \
    rm -rf /usr/share/applications/systemsettings.desktop && \
    mv /usr/share/applications/systemsettings_edit.desktop /usr/share/applications/systemsettings.desktop && \
    sh -c 'echo Hidden=true >> /usr/share/applications/org.kde.plasma.settings.open.desktop' && \
    sh -c 'echo Hidden=true >> /usr/share/applications/plasma-bigscreen-swap-session.desktop' && \
    rm -rf /usr/share/wayland-sessions/plasma.desktop && \
    
RUN bootc container lint
