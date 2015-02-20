# stack_wordpress

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with stack_wordpress](#beginning-with-stack_wordpress)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

This contains manifests to set up a multi-tier LAMP stack containing:
* One or more wordpress installations
* A database server
* HAProxy load balancer

## Setup

### Setup Requirements

On the agent run, nodes including the manifests in this module
use the PuppetDB API to discover each other. All nodes must be able
to communicate with the PuppetDB API listening on port 8081 on the
puppetmaster. Ensure that you whitelist using the appropriate regexes
or disable the certificate whitelist.
See [https://docs.puppetlabs.com/puppetdb/latest/configure.html#certificate-whitelist](https://docs.puppetlabs.com/puppetdb/latest/configure.html#certificate-whitelist)
for more information

## Usage

## Reference

## Limitations

This module has been tested on:
  * Centos 6
  * Ubuntu 12.04
  * Ubuntu 14.04

## Development

The module repository is [here](https://github.com/jaronson/stack_wordpress.git). Issues should be filed in the repository.
