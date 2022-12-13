# nixlet.tf

[terraform-docs]: https://terraform-docs.io
[terraform]: https://terraform.io
[digitalocean]: https://digitalocean.com
[nixos]: https://nixos.org

a [terraform] module to create a [nixos] droplet on [digitalocean].

## usage as a terraform module

Start with something like this (_everything except `source` is optional_):

```hcl
module "nixlet" {
  source        = "github.com/polis-dev/nixlet.tf"

  # defaults to nixos-unstable, with flakes, and other sane defaults.
  nixos_channel = "nixos-unstable"

  # custom nixos configuration can be specified inline or via file().
  nixos_config  = <<-NIXOS_CONFIG
  { config, lib, pkgs, ... }: {
    /*
    add your configuration here...
    */
  }
  NIXOS_CONFIG

  # increased droplet size to make nixlet go vroooom!
  droplet_size  = "s-4vcpu-8gb-intel"
}
```

Then run `terraform init` and then `terraform plan`.

## stand-alone / local setup

1. install [terraform] and [terraform-docs]. run `./terraform.sh` to show available commands.

2. run `./terraform.sh init` to fetch required providers.

3. export `DIGITALOCEAN_TOKEN=...` (directly, or via the example .envrc) to set your credentials.

4. plan a deployment with `./terraform.sh plan`.

5. apply the plan with `./terraform.sh apply`.

6. ssh to your host and enjoy! allow ~5-10 minutes to provision; try not to modify anything while its still provisioning (or just `tail -f /var/log/cloud-init-output.log`).

7. clean up everything with `./terraform.sh destroy`.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) (~> 2.2)

- <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) (~> 2.0)

## Inputs

The following input variables are supported:

### <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size)

Description: which digitalocean droplet size should be used?

Default: `"s-1vcpu-1gb-intel"`

### <a name="input_droplet_tags"></a> [droplet\_tags](#input\_droplet\_tags)

Description: tags to apply to droplet.

Default:

```json
[
  "nixos"
]
```

### <a name="input_extra_volume"></a> [extra\_volume](#input\_extra\_volume)

Description: provision a Block Volume for host?

Default: `false`

### <a name="input_extra_volume_size"></a> [extra\_volume\_size](#input\_extra\_volume\_size)

Description: how big should the extra volume be in GB?

Default: `100`

### <a name="input_floating_ip"></a> [floating\_ip](#input\_floating\_ip)

Description: reserve a floating IP droplet host?

Default: `true`

### <a name="input_hostname"></a> [hostname](#input\_hostname)

Description: what name should be given to instance?

Default: `"nixlet"`

### <a name="input_image"></a> [image](#input\_image)

Description: change this at your own risk. it "just works" like this...

Default: `"debian-11-x64"`

### <a name="input_nixos_channel"></a> [nixos\_channel](#input\_nixos\_channel)

Description: which nix channel should be used for managed hosts?

Default: `"nixos-unstable"`

### <a name="input_nixos_config"></a> [nixos\_config](#input\_nixos\_config)

Description: extra nixos config file, included in place of the default custom.nix in this module.

Default: `""`

### <a name="input_region"></a> [region](#input\_region)

Description: which digitalocean region should be used?

Default: `"nyc3"`

### <a name="input_ssh_key_ids"></a> [ssh\_key\_ids](#input\_ssh\_key\_ids)

Description: ssh key ids to grant root ssh access. does not create them. if unspecified, all currently available ssh keys will be used (within the  project containing this API token).

Default: `[]`

### <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)

Description: name of the VPC to target, if "default" will be appended with -$region

Default: `"default"`

## Outputs

The following outputs are exported:

### <a name="output_ipv4_address"></a> [ipv4\_address](#output\_ipv4\_address)

Description: public ipv4 address

### <a name="output_ipv6_address"></a> [ipv6\_address](#output\_ipv6\_address)

Description: public ipv6 address

### <a name="output_remote_log_file"></a> [remote\_log\_file](#output\_remote\_log\_file)

Description: logs from cloud-init will be in this path on the remote host. you can use something like `ssh root@<IP> tail -f <PATH>` to follow installation as it goes.

### <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command)

Description: ssh command

### <a name="output_ssh_username"></a> [ssh\_username](#output\_ssh\_username)

Description: ssh username
<!-- END_TF_DOCS -->

_NOTE that the documentation is automatically updated by [terraform-docs]._
