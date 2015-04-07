FROM progrium/busybox

RUN opkg-install ca-certificates
RUN cat /etc/ssl/certs/*.crt > /etc/ssl/certs/ca-certificates.crt && \
    sed -i -r '/^#.+/d' /etc/ssl/certs/ca-certificates.crt

COPY build/linux_amd64/s3get /s3get
ENTRYPOINT ["/s3get"]
