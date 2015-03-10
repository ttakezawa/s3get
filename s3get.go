package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"net/url"
	"os"
	"strings"

	"github.com/awslabs/aws-sdk-go/aws"
	"github.com/awslabs/aws-sdk-go/gen/s3"
)

// Version is the current version of this application.
const Version string = "1.0.1.dev"

func main() {
	versionFlag := flag.Bool("version", false, "Version")
	accessKey := flag.String("access_key", "", "AWS Access Key")
	secretKey := flag.String("secret_key", "", "AWS Secret Key")
	sessionToken := flag.String("session_token", "", "AWS Session Token")
	region := flag.String("region", "", "AWS Region")
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [options] s3://your-bucket/path/to/object\n", os.Args[0])
		flag.PrintDefaults()
	}

	flag.Parse()
	if *versionFlag {
		fmt.Printf("s3get: v%s\n", Version)
		os.Exit(0)
	}
	if len(flag.Args()) != 1 {
		flag.Usage()
		os.Exit(1)
	}

	objectURL, err := url.Parse(flag.Args()[0])
	if err != nil {
		fmt.Fprint(os.Stderr, err)
		os.Exit(1)
	}
	if objectURL.Scheme != "s3" {
		fmt.Fprint(os.Stderr, "The correct URL is something like s3://your-bucket/path/to/object")
		os.Exit(1)
	}

	creds := aws.DetectCreds(*accessKey, *secretKey, *sessionToken)
	cli := s3.New(creds, *region, nil)

	resp, err := cli.GetObject(
		&s3.GetObjectRequest{
			Bucket: aws.String(objectURL.Host),
			Key:    aws.String(strings.TrimLeft(objectURL.Path, "/")),
		},
	)
	if err != nil {
		fmt.Fprint(os.Stderr, err)
		os.Exit(1)
	}
	bytes, _ := ioutil.ReadAll(resp.Body)
	fmt.Print(string(bytes))
}
