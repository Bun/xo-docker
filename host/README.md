# Docker host image

## TODO

* Automatically use latest version of Alpine
* ec2-user-data script runs before networking is available and thus doesn't
  work
* Some initrd files are based on Alpine's ISO initrd; check licensing or fix
* mdev related stuff can be trimmed down a bit


## Dependencies

* `busybox-static`
