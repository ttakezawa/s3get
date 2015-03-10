FROM scratch
COPY build/linux_amd64/s3get /s3get
ENTRYPOINT ["/s3get"]
