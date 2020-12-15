# docker4p2os

The Pioneer robot is connected through a USB/Serial converter, which appears in Linux as `/dev/ttyUSB0`.

Please make sure that your user belongs to the group `dialout`.

## Networking containers across multiple hosts (in the same network)

Based on [the Docker docs](https://docs.docker.com/network/network-tutorial-overlay/#use-an-overlay-network-for-standalone-containers).

1. In external PC
```
docker swarm init
```
(keep the token step 2)

2. In the robot PC
```
docker swarm join --token <TOKEN> <IP-ADDRESS-OF-MANAGER>:2377
```

3. In external PC
```
docker network create -d overlay --attachable rosnet
```

4. In the robot PC
```
docker run --rm -it --net=rosnet --name pioneer \
  --env ROS_HOSTNAME=pioneer \
  --env ROS_MASTER_URI=http://pioneer:11311 \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \
  p2os:kinetic
```

5. In external PC
```
docker run --rm -it --net=rosnet --name client \
  --env ROS_HOSTNAME=client \
  --env ROS_MASTER_URI=http://pioneer:11311 \
  p2os:kinetic rosrun teleop_twist_keyboard teleop_twist_keyboard.py
```
