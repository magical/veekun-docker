Builds a [docker][] container for [veekun][].

[docker]: https://docker.com
[veekun]: http://veekun.com

Build:

    docker build -t veekun .

Run:

    docker run -d -p 80:80 veekun

TODO:

- /var/log should probably be a volume mount.

- The container is 826 MB. Try to pare that down.

- Drop privileges.

- Use postgres for the db.
