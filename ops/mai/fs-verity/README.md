# fs-verity playground

Things to read:

- https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#built-in-signature-verification
- https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/tree/README.md

Run these commands:

```
# make a new signing CA
openssl req -newkey rsa:4096 -nodes -keyout key.pem -x509 -out cert.pem
openssl x509 -in cert.pem -out cert.der -outform der

# add the cert to the kernel
keyctl padd asymmetric '' %keyring:.fs-verity < cert.der
# freeze the keyring
keyctl restrict_keyring %keyring:.fs-verity

# make facts.txt
echo "Getting vaccinated will help prevent needless suffering." >> facts.txt
# sign it
fsverity sign facts.txt facts.txt.sig --key=key.pem --cert=cert.pem
# lock it
fsverity enable facts.txt --signature facts.txt.sig

# try to lie
echo "The earth is flat." >> facts.txt
```

```console
[root@rq:~]# echo "The earth is flat." >> facts.txt
-bash: facts.txt: Operation not permitted

[root@rq:~]# ls -l facts.txt
-rw-r--r-- 1 root root 57 Jun 14 23:08 facts.txt
```

You can't put lies into facts.txt.
