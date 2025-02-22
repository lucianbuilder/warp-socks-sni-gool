FROM alpine:latest

ARG WARP_VERSION
ARG COMMIT_SHA
ARG TARGETPLATFORM

LABEL WARP_VERSION=${WARP_VERSION}
LABEL COMMIT_SHA=${COMMIT_SHA}

COPY entrypoint.sh /entrypoint.sh

# install dependencies
#RUN case ${TARGETPLATFORM} in \
#      "linux/amd64")   export ARCH="amd64" ;; \
#      "linux/arm64")   export ARCH="armv8" ;; \
#      *) echo "Unsupported TARGETPLATFORM: ${TARGETPLATFORM}" && exit 1 ;; \
#    esac && \
RUN apk update && \
#    echo "Building for ${ARCH} with SNI" &&\
    apk add --no-cache sniproxy proxychains-ng && \
    chmod +x /entrypoint.sh && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/file.zip https://github.com/bepass-org/warp-plus/releases/latest/download/warp-plus_linux-amd64.zip && \
    cd /tmp/downloads/ && \
    unzip /tmp/downloads/file.zip && \
    mv /tmp/downloads/warp-plus /warp-plus && \
    rm -r /tmp/downloads && \
    chmod +x /warp-plus

#ADD warp-plus /warp-plus
ADD sniproxy.conf /etc/sniproxy.conf
ADD proxychains.conf /etc/proxychains/proxychains.conf

# Accept Cloudflare WARP TOS
#RUN mkdir -p /home/warp/.local/share/warp && \
#    echo -n 'yes' > /home/warp/.local/share/warp/accepted-tos.txt

#RUN ln -sf /dev/stdout /var/log/sniproxy/sniproxy.log

EXPOSE 80
EXPOSE 443

#ENV WARP_SLEEP=2
#ENV REGISTER_WHEN_MDM_EXISTS=
#ENV WARP_LICENSE_KEY=
#ENV BETA_FIX_HOST_CONNECTIVITY=

#HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
#  CMD /healthcheck/index.sh


ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
