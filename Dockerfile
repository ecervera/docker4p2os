FROM ros:kinetic-ros-base

RUN apt-get update && apt-get install -y \
    ros-kinetic-p2os-driver ros-kinetic-p2os-launch \
    ros-kinetic-p2os-msgs ros-kinetic-p2os-teleop \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    ros-kinetic-teleop-twist-keyboard \
    && rm -rf /var/lib/apt/lists/*

ADD p2os_driver.launch /root

CMD ["roslaunch", "/root/p2os_driver.launch"]

