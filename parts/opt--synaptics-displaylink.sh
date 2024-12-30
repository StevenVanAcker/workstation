#!/bin/sh -e
# DESCRIPTION: Synaptics DisplayLink drivers

# for at least Dell D6000 docking station "DisplayLink Dell Universal Dock D6000"

# bypass the silly .deb from https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb
mkdir -p /etc/apt/sources.list.d/ 
cat > /etc/apt/sources.list.d/synaptics.list <<EOF
deb [signed-by=/usr/share/keyrings/synaptics-repository-keyring.gpg] https://www.synaptics.com/sites/default/files/Ubuntu stable main
deb [signed-by=/usr/share/keyrings/synaptics-repository-keyring.gpg] https://www.synaptics.com/sites/default/files/Ubuntu stable non-free
EOF

mkdir -p /usr/share/keyrings/
base64 -d > /usr/share/keyrings/synaptics-repository-keyring.gpg <<EOF
mQINBGM76wkBEAC5dcDFny5/OAMyzs68hLNriNDIzaW7oAHJPzTEduqmNx4Tu5ZVefll5BtcyU4y
HQmBS7v2ruqe+GaGtxBoE3SZUJDugECzaLBMLFSTcw1ACQOg15QH4vNVoEp6H4tz9AQuP0MMdUKK
N07sxGQhUL58dJPnpZxfAiEsd5nLQfDE1wcP4DomI8CCBkDEwqXmItrfOzkseXraBniBZwDOybg9
vdR1SsC1lZQhtOWYB1rMCeNpE5Y/GTWeQFuljGokZss8JoUMgpLXhEA50v8NGOhv5sT0kbxAMWI4
gu32CZv8myqAqefKlpYiBsEfz8Noak2tG3V4RsE9UfwbTk8MrP9JObD9kGMu3lq+mgqUFtA4cysp
jY6mvbbLzAClAYB1quaYCwqUIC+PnYJlSNWPe117I6rDdtRZ/+KlMUJJsGTogNKFIRMWWMy1vdHA
eefw00jnWsz7uDZ+/86JOMLG4wojaJsQy8+/0n5x/HpzvR1AVKjPDciKTm0qHv4+eI5zh1QI9ctd
6oMdnUQFbmKQWYqoOna8ADEXrxYqRPg9BqV1Iec/378VMvJL81Ur2xkRuWUcELl/K5XaobPoOLUR
oslpVGDqiuVUPq06nOvwn4hDvn/za4SJSOUQX7dOBvoicX1nWXwH8l7Zl90Qm4K4X7FSDga7YSQ3
deQP1jma9qa/xQARAQABtK9TeW5hcHRpY3MgRGlzcGxheUxpbmsgRHJpdmVyIFB1YmxpYyBSZXBv
c2l0b3J5IFNpZ25pbmcgS2V5IChTeW5hcHRpY3MgSW5jLiBTeW5hcHRpY3MgVGVjaG5pY2FsIFN1
cHBvcnQgPHRlY2huaWNhbC1lbnF1aXJpZXNAc3luYXB0aWNzLmNvbT4pIDx0ZWNobmljYWwtZW5x
dWlyaWVzQHN5bmFwdGljcy5jb20+iQJUBBMBCAA+FiEEXOwOg+T2qLoFd5JyOs+qZaiS5aUFAmM7
6wkCGy8FCQlmAYAFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQOs+qZaiS5aWtqBAAuNt6T+X0
yafUvJXeM/aDPOsTja5ZPH5J/+5kVkxs8hH9R2pvdbK2kHIaNBMrdhxc3dyUNySBeqylnU6bwjDv
4BA7hkPnMjJ4yU3mXmozglqH2dPEF3Hy3Nyt2y15wAEvoCJBF0wOXkD74utHYj2Au1sbcSBKzkOB
7gS3WqcBAZ3aoO211JFpjPAHCGH+4aIlu64vzZvsXi6PFkxH1qPNc4RJ+DmeHaPQqAYxvzSrm/Jb
4GMIw9/0EbwGvx/4MWGt/qtDDWW54HYxiy4HHflx1znRVUqnAP5Lw91WxnMmUTtqwO57f3hXQ/pV
BD5UniNEp53ofj2KdpN+qbuWW8lUmUZS8Q2MsEuzCUNe+Fja8g/ZbOS868zO3PaTi2Fvqx5KOXrC
cgJaYzv21UJcc9mtgfhk6Dz7u5mUbvDHgVapMml94fc7JlLhYsDh4iyXgYwPuwa+of6+oOhU82y3
bB4DA85ryvBZ0RanDghp5T7QZT8xglveuPkII36dKmDQcZGKTqhbUysYbEF0hdNmZZUh9G1JojRW
kt+zyj7KVrItcwY4Qs+m6FwTmJQ5MGTT9/SevKHhWBaI3/ovUy0YHd1dmtpRtdHzZfoBiJIDMdee
juUtgRJ2Ood+hUiUwPxK9I5Ek0ePqPDQ9SKdOMZr1OwAHLxQ9In0SZ0jlVsu1a+O7Oc=
EOF

yes | aptdcon --hide-terminal --refresh
yes | aptdcon --hide-terminal --install="displaylink-driver"
