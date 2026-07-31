FROM frrouting/frr

RUN apk update && \
    apk add --no-cache openssh sudo && \
    ssh-keygen -A

RUN adduser -D -s /bin/ash admin && \
    echo "admin:MotDePasseTemporaire" | chpasswd && \
    addgroup admin frrvty

RUN echo "admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/admin && \
    chmod 440 /etc/sudoers.d/admin

RUN mkdir -p /run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]
