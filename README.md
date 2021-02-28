# Token Generator

## Purpose

This project provides:
- an HTTP endpoint to construct and return a Json Web Token, required to access the Apple Music API
- a simple homepage for the TabWriter app, served from as the root of the api

## Structure

The project is constructed in 3 parts to deliver these aspects:

### Generator

A Spring Boot application that returns the JWT in response to requests to `/api/token`.

To construct the token, the following environment variables must be available for the application:
- APPLE_MUSIC_PRIVATE_KEY
- APPLE_MUSIC_KEY_IDENTIFIER
- APPLE_MUSIC_TEAM_ID

In addition, requests to `/api/token` are authorised with a token which should be set with the `AUTH_TOKEN` environment variables. Requests are authorized if the `Authorization` header is set to `APIKey ...`.

In addition, the generator contains static html and css for the TabWriter homepage. This is served from the statically by the Spring Boot app with requests to `/`.

The application is built and tested by Gradle and can be built into a docker image using the palantir Gradle plugin. This is can be pushed to `dgrew/tokengenerator:${VERSION}`

### Proxy

This part of the project builds on the Nginx Docker image to provide a reverse proxy for the Spring Boot Generator application. The nginx config forwards all requests to the Generator. 

By default it only accepts requests on port 80. However, there is an `update_config.sh` script which, if called after the container has launched, will enable TLS encryption using certbot letsencrypt, and update the configuration to enforce https. Note, `update_config.sh` must be called with the `--enable-encryption` and `-d {DOMAIN}` flags.

### Terraform

This provides configuration to deploy the Generator and Proxy to AWS. To save costs, and with the minimal expected traffic, both containers are currently run on a single EC2 instance. 

In addition to creating the instance and using `user_data` to bootstrap it with the containers, this directory also creates:

- ssm parameters for the environment variables required by the generator, see above. These are pulled from SSM when the EC2 instance launches and made available to the generator
- a route 53 A record pointing to the EC2 instance. Note, a domain is passed as a Terraform variable, and an AWS hosted zone should already exist for this domain.

Terraform Cloud is used as a remote backend to support GitHub Actions deployments.

## Build & Release

The repository has two pipelines for use with GitHub Actions:

1. test.yml - runs Generator unit tests and Terraform validation for any push requests
2. deploy.yml - when a release is published this builds and pushes images for the generator and the proxy. They are tagged with the commit sha. It then destroys any existing Terraform in the prod workspace and re-applies Terraform in the prod workspace.

The reason for destroying and then re-applying is that this is using a single EC2 instance to host all images and so it would require custom scripts to update images in flight. This is excessive given the expected number of releases. In addition, it is a stateless application and so a complete destroy and re-build is not problematic.

To update infrastructure, create a new GitHub release.