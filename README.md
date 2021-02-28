# README

Main backend monolith for Dusic bot

## Secrets

Secrets schema:
```
db:
  password: db_password
vk:
  login: +88005553535
  password: 'password'
donations:
  vkponchik:
    group_id: 0
    api_key: ''
  vkdonate:
    group_id: 0
    api_key: ''
hmac_secret: `https://cloud.google.com/network-connectivity/docs/vpn/how-to/generating-pre-shared-key`
secret_key_base: `rake secret`
```
