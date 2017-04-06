package main

import (
	"bufio"
	"context"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"os"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/client"
)

func main() {
	username := flag.String("username", "", "Username to pass to docker for authentication with registry")
	password := flag.String("password", "", "Password to pass to docker for authentication with registry")
	email := flag.String("email", "", "Email to pass to docker for authentication with registry")

	flag.Parse()

	imagePullOptions := types.ImagePullOptions{}
	if *username != "" {
		if *password == "" {
			fmt.Println("Password can not be empty if username is specified")
			os.Exit(1)
		}
		if *email == "" {
			fmt.Println("Email can not be empty if username is specified")
			os.Exit(1)
		}

		auth := map[string]string{
			"username": *username,
			"password": *password,
			"email":    *email,
		}

		authBytes, err := json.Marshal(auth)
		if err != nil {
			// This can actually never happen, unless there's a bug in the json package
			panic(err)
		}

		imagePullOptions.RegistryAuth = base64.StdEncoding.EncodeToString(authBytes)
	}

	imageSpec := flag.Arg(0)
	if imageSpec == "" {
		fmt.Println("error: Specify image to pull")
		os.Exit(1)
	}
	ctx := context.Background()

	// The image pull API is probably not going to change for quite a while!
	// This is a hack, but easier than constructing a client manually
	os.Setenv("DOCKER_API_VERSION", "1.23")

	cli, err := client.NewEnvClient()
	if err != nil {
		panic(err)
	}

	pullInfo, err := cli.ImagePull(ctx, imageSpec, imagePullOptions)
	if err != nil {
		// If it doesn't succeed, just error out
		panic(err)
	}
	defer pullInfo.Close()

	pullInfoScanner := bufio.NewScanner(pullInfo)

	lastLine := ""
	for pullInfoScanner.Scan() {
		lastLine = pullInfoScanner.Text()
		fmt.Println(lastLine)
	}

	var lastMessageParsed map[string]interface{}

	err = json.Unmarshal([]byte(lastLine), &lastMessageParsed)
	if err != nil {
		panic(err)
	}

	if _, errorPresent := lastMessageParsed["error"]; errorPresent {
		os.Exit(1)
	}
}
