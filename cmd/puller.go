package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"os"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
)

func main() {
	flag.Parse()

	imageSpec := flag.Arg(0)
	if imageSpec == "" {
		fmt.Println("error: Specify image to pull")
		os.Exit(1)
	}
	ctx := context.Background()

	// This is a hack, but easier than constructing a client manually
	os.Setenv("DOCKER_API_VERSION", "1.24")

	cli, err := client.NewEnvClient()
	if err != nil {
		panic(err)
	}

	pullInfo, err := cli.ImagePull(ctx, imageSpec, types.ImagePullOptions{})
	if err != nil {
		panic(err)
	}
	defer pullInfo.Close()

	pullInfoScanner := bufio.NewScanner(pullInfo)
	for pullInfoScanner.Scan() {
		fmt.Println(pullInfoScanner.Text())
	}
}
