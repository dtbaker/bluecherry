# Bluecherry Docker:

```
docker build -t bluecherry .
```

# unRAID + Bluecherry

If you are running unraid with a private docker `repository` then you can push bluecherry there and then launch via the unraid web UI.

Make sure your PC has `{ "insecure-registries":["192.168.0.123:5000"] }` inside `/etc/docker/daemon.json` ( then `service docker restart` ) otherwise you'll get a https docker error when trying to push from your PC to a local repository.

First build the docker image with `docker build` as per above.

Then tag & push the image to your unraid repository.

```
docker tag bluecherry 192.168.0.123:5000/my-bluecherry
docker push 192.168.0.123:5000/my-bluecherry
```

Then go to Docker > Add Container > `192.168.0.123:5000/my-bluecherry` > Forward a port through to `7001` for the web UI, and forward another port through to `7002` for RTSP.

Once running then you can connect to your unraid server to open bluecherry at `https://192.168.0.123:7001` (or whatever port you decided to forward through). Default login was `admin / bluecherry`

unraid community app + dockerhub coming soon.


