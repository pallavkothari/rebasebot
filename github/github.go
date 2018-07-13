// Package github provides a simple client for the GitHub API
package github

import (
	"net/http"
	"os"
	"strings"
	"crypto/tls"
)

const (
	mediaType   = "application/vnd.github.v3+json"
	contentType = "application/json"
	agent       = "rebasebot"
)

var (
	githubEndpoint	string
	username   string
	password   string
	signature  string
	tr = &http.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true},}
	httpClient = &http.Client{Transport:tr}
)

func init() {
	githubEndpoint = os.Getenv("GITHUB_ENDPOINT")
	username = os.Getenv("GITHUB_USERNAME")
	password = os.Getenv("GITHUB_PASSWORD")
	signature = os.Getenv("SECRET")
}

// Returns a request set up for the GitHub API
func NewGitHubRequest(path string) *http.Request {
	requestUrl := githubEndpoint + path
	request, _ := http.NewRequest("GET", requestUrl, nil)
	request.SetBasicAuth(username, password)
	request.Header.Set("Accept", mediaType)
	request.Header.Set("Content-Type", contentType)
	request.Header.Set("User-Agent", agent)

	return request
}

// Check to see if logged in user was mentioned in comment
func WasMentioned(c Comment) bool {
	return strings.Contains(c.Body, "@"+username)
}
