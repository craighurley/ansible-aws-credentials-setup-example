# aws-credentials-setup

## Sample ./vars/setup.yaml

You need to create a `./vars/setup.yaml` file, but **do not commit it in unencrypted form to a public repo**.

```yaml
---
# signin_profiles are not manditory; they are used to create the firefox containers config.
signin_profiles:
  - name: foo
    signin_url_prefix: foo-identity
  - name: baz
    signin_url_prefix: baz-organisation

# credentials_profiles are manditory.
credentials_profiles:
  - name: foo
    aws_access_key_id: ACCESS_KEY_ID_FOO
    aws_secret_access_key: SECRET_ACCESS_KEY_FOO
    aws_mfa_device: arn:aws:iam::000000000000:mfa/USER
    region: eu-west-1
  # add config for credentials that are generated by saml2aws
  - name: bar-saml
    aws_access_key_id: saml
    aws_secret_access_key: saml
    region: us-west-1
  # add config for IAM user that does not use MFA (or roles in this example)
  - name: baz
    aws_access_key_id: ACCESS_KEY_ID_BAZ
    aws_secret_access_key: SECRET_ACCESS_KEY_BAZ
    region: us-east-1

# accounts are manditory.
accounts:
  - name: foo-sandpit
    account_id: '111111111111'
    credentials_profile: foo
    signin_url_profile: foo
    roles:
      - Administrator
      - ReadOnly
  - name: foo-prod
    account_id: '222222222222'
    credentials_profile: foo
    signin_url_profile: foo
    roles:
      - Administrator
      - ReadOnly
  - name: bar-sandpit
    account_id: '888888888888'
    credentials_profile: bar-saml
    roles:
      - Administrator
      - ReadOnly
  - name: bar-prod
    account_id: '999999999999'
    credentials_profile: bar-saml
    roles:
      - Administrator
      - ReadOnly
```

## Encrypting your setup.yaml

If you have `ansible-vault`, you can protect your `./vars/setup.yaml` the file with the following commands:

```sh
ansible-vault encrypt ./vars/setup.yaml
ansible-vault edit ./vars/setup.yaml
```

## Playbooks

### Credentials

Create AWS credentials for a given client:

```sh
ansible-playbook ./playbooks/credentials.yaml
```

Note: this also creates a configuration file for the following:

- AWS Extend Switch Roles browser plugin
- Firefox containers

It's useful to be able to check the files created by this playbook, so run the following to add a symlink to `~/.aws/`

```sh
ln -s ~/.aws/ .aws
```
