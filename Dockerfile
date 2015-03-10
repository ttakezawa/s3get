FROM scratch
COPY bin/s3get /s3get
ENTRYPOINT ["/s3get"]
