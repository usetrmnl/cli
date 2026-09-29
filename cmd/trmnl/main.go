// trmnl is the TRMNL API as a command line. Its commands come from the OpenAPI
// document core publishes, so a new API endpoint needs no change here.
package main

import (
	"fmt"
	"os"
	"path/filepath"

	restish "github.com/rest-sh/restish/v2"
	"github.com/rest-sh/restish/v2/config"
)

var version = "dev" // set by goreleaser

func main() {
	baseURL := envOr("TRMNL_URL", "https://trmnl.com")

	// Keep config and tokens apart from a plain restish install.
	if home, err := os.UserHomeDir(); err == nil {
		setenvIfUnset("RSH_CONFIG_DIR", filepath.Join(home, ".config", "trmnl"))
		setenvIfUnset("RSH_CACHE_DIR", filepath.Join(home, ".cache", "trmnl"))
	}

	cli := restish.New()
	cli.SetCommandName("trmnl")
	cli.SetCommandDescription("TRMNL CLI", "Manage your TRMNL devices, playlists and plugins from the command line.")
	cli.SetVersion(version)
	cli.SetDefaultConfig(&restish.Config{APIs: map[string]*restish.APIConfig{
		"trmnl": {
			BaseURL: baseURL,
			SpecURL: baseURL + "/api-docs/openapi.json",
			Profiles: map[string]*restish.ProfileConfig{
				"default": {Credentials: map[string]*config.CredentialConfig{"bearer_auth": {Auth: &restish.AuthConfig{
					Type: "oauth-authorization-code",
					Params: map[string]string{
						"client_id":     "trmnl-cli",
						"authorize_url": baseURL + "/oidc/authorize",
						"token_url":     baseURL + "/oidc/token",
						"scopes":        "read content devices delete profile apps",
					},
				}}}},
			},
		},
	}})
	cli.SetCommandSurface(restish.CommandSurface{PromotedAPI: "trmnl"})

	if err := cli.Run(os.Args); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func envOr(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

func setenvIfUnset(key, value string) {
	if os.Getenv(key) == "" {
		os.Setenv(key, value)
	}
}
