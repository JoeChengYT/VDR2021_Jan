# Base image
FROM nvidia/cuda:11.0-cudnn8-devel-ubuntu18.04
ENV LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y vim wget bzip2 ca-certificates curl git
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.9.2-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    /opt/conda/bin/conda clean --all && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PATH /opt/conda/bin:$PATH

WORKDIR /root/projects/.
RUN git clone https://github.com/autorope/donkeycar && \
    git clone https://github.com/tawnkramer/gym-donkeycar && \
    cd donkeycar && \
    git checkout dev

WORKDIR /root/projects/donkeycar/install/envs
RUN conda env create -f ubuntu.yml

WORKDIR /root/projects/donkeycar
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate donkey && \
    pip install -e .[pc] && \
    pip install tensorflow==2.4.0 tensorflow-gpu==2.4.0

WORKDIR /root/projects/gym-donkeycar
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate donkey && \
    pip install -e .[gym-donkeycar]

COPY ./Team_ahoy_racer  /root/Team_ahoy_racer
RUN echo "conda activate donkey" >> ~/.bashrc
WORKDIR /root/Team_ahoy_racer
