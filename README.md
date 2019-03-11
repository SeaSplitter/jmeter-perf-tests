# JMeter Perf Testing Suite

## Pre-Requisites

1. You already have a [Packet Host](https://www.packet.com) account setup with appropriate billing details filled out

2. An SSH key under your control has been configured as either a user and/or project level SSH key for authorizing connections to devices

3. Optionally create a project under your Packet Host account and take note of the project UUID (if you don't provide this, terraform is configured to create one)

4. Terraform v0.12.0-beta1 or later is installed. This is easily done via `tfenv`:

        brew install tfenv
        tfenv install 0.12.0-beta1

## Initializing Terraform

1. Create `terraform.tfvars` based on provided sample file

2. Download provider plugins needed by terraform v0.12.0 (this will not be neccessary once v0.12.0 reaches GA release)

        mkdir -p ~/.terraform.d/plugins/darwin_amd64 ~/.terraform.d/plugins/downloads

        (cd ~/.terraform.d/plugins/downloads; wget -N http://terraform-0.12.0-dev-snapshots.s3-website-us-west-2.amazonaws.com/terraform-provider-packet/1.4.0-dev20190216H00-dev/terraform-provider-packet_1.4.0-dev20190216H00-dev_darwin_amd64.zip)
        (cd ~/.terraform.d/plugins/downloads; wget -N http://terraform-0.12.0-dev-snapshots.s3-website-us-west-2.amazonaws.com/terraform-provider-random/3.0.0-dev20190216H01-dev/terraform-provider-random_3.0.0-dev20190216H01-dev_darwin_amd64.zip)

        find ~/.terraform.d/plugins/downloads -type f -name '*.zip' | xargs -n1 unzip -n -d ~/.terraform.d/plugins/darwin_amd64

3. Initialize terraform state

        (cd env-packet; terraform init)

## Terraform State Backends

Given the purpose of the JMeter servers is not to exist forever, but to spun up for a single individuals use and then destroyed, the environments described here are configured to use local terraform state files which are ignored by git. If a state backend which supports versioning and/or collaboration is desired, add a `backend.tf` file referencing the sample file for an example of storing state in a GCS bucket. Once this file is created, you will need to re-run `terraform init`.

## Creating Jmeter Instances

Run `terraform apply` specifying how many instances to create from within the `env-packet` directory:

    (cd env-packet; terraform apply -var instance_count=1)

## Destroying Jmeter Instances

Run `terraform apply` without specifying any vaue for `instance_count` (which defaults to 0) or use `terraform destroy` (this will also destroy the containing project but only IF it was created by terraform) within the `env-packet` directory.

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This project was created in 2019 by [David Alger](http://davidalger.com/).
