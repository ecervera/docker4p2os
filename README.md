# docker4p2os

The Pioneer robot is connected through a USB/Serial converter, which appears in Linux as `/dev/ttyUSB0`.

Please make sure that your user (in the robot PC) belongs to the group `dialout`.

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
  p2os:kinetic /bin/bash
```

Inside docker terminal for activating the motors, teleoperation, and [using the gripper](http://playerstage.sourceforge.net/doc/Player-2.0.0/player/group__interface__gripper.html#gb7487dae409a9df347f091b06a545e46):
```
rostopic pub -1 /cmd_motor_state p2os_msgs/MotorState 1
rosrun teleop_twist_keyboard teleop_twist_keyboard.py 
```
Open gripper:
```
rostopic pub -1 /gripper_control p2os_msgs/GripperState \
'{grip: {state: 1, dir: 0, inner_beam: False, outer_beam: False, left_contact: False, right_contact: False}, lift: {state: 0, dir: 0, position: 0.0 }}'
```
Close gripper:
```
rostopic pub -1 /gripper_control p2os_msgs/GripperState \
'{grip: {state: 2, dir: 0, inner_beam: False, outer_beam: False, left_contact: False, right_contact: False}, lift: {state: 0, dir: 0, position: 0.0 }}'
```
Up gripper:
```
rostopic pub -1 /gripper_control p2os_msgs/GripperState \
'{grip: {state: 4, dir: 0, inner_beam: False, outer_beam: False, left_contact: False, right_contact: False}, lift: {state: 0, dir: 0, position: 0.0 }}'

```
Down gripper:
```
rostopic pub -1 /gripper_control p2os_msgs/GripperState \
'{grip: {state: 5, dir: 0, inner_beam: False, outer_beam: False, left_contact: False, right_contact: False}, lift: {state: 0, dir: 0, position: 0.0 }}'
```
