# UrBackup Docker Client
Source files for the Docker image hejare/urbackup-client at https://hub.docker.com/r/hejare/urbackup-client/.

## Introduction
The UrBackup solution has a comprehensive list of featuers and supported systems. The official website states that 

> UrBackup is an easy to setup Open Source client/server backup system, that through a combination of image and file backups accomplishes both data safety and a fast restoration time.

This Docker image runs a UrBackup client. Note that it does not run the UrBackup server. Please see https://www.urbackup.org for more information on the complete UrBackup solution.

## Starting the Docker container
You may start the container by simply running

```
docker run hejare/urbackup-client
```

This will start the UrBackup client and automatically connect to any UrBackup servers on the local network.

In order to connect the client to a server outside of the local network, a number of parameters as environment variables:

```
docker run \
  -e COMPUTERNAME=<your-client-computer-name> \
  -e INTERNET_MODE_ENABLED=true \
  -e INTERNET_SERVER=<your-server-name-or-ip> \
  -e INTERNET_AUTHKEY=<your-client-authkey> \
  hejare/urbackup-client
```

