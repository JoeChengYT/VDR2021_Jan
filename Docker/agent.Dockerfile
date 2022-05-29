# Base image
FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
ENV LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-key del 3bf863cc && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y vim wget bzip2 ca-certificates curl git
RUN apt-get install -y python3 python3-dev python3-pip python3-yaml git build-essential cmake libtool m4 automake byacc bison flex libxml2-dev libxml2 2to3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install opencv-python --upgrade
RUN python3 -m pip install python-igraph==0.8.2
RUN apt-get install -y python3-igraph
RUN python3 -m pip install scipy rospkg configparser zmq igraph trajectory_planning_helpers scikit-build cmake catkin_pkg rosdep rosinstall_generator rosinstall wstool vcstools catkin_tools
RUN apt remove -y python3-numpy
RUN pip install pyfiglet prettytable

WORKDIR /root/projects/.
RUN git clone https://github.com/autorope/donkeycar && \
    git clone https://github.com/tawnkramer/gym-donkeycar && \
    cd donkeycar && \
    git checkout master

WORKDIR /root/projects/donkeycar
RUN pip install -e .[pc] && \
    pip install tensorflow==2.4.0 tensorflow-gpu==2.4.0

WORKDIR /root/projects/gym-donkeycar
RUN pip install -e .[gym-donkeycar]

RUN apt -y install python3-opencv
COPY ./Team_ahoy_racer  /root/Team_ahoy_racer
WORKDIR /root/Team_ahoy_racer
