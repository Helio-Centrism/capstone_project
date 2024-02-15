# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Set the working directory in the container
WORKDIR /app

# Set noninteractive mode for package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies and essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    software-properties-common \
    pciutils \
    lsb-release \
    gnupg \
    gcc-9 \
    g++-9 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes PPA and install Python 3.8
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.8 python3.8-distutils

# Install pip for Python 3.8
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3.8 get-pip.py

# Intsall necessary python packages 
RUN pip3.8 install \
    numpy==1.19.5 \
    opencv-python==4.5.3.56 \
    pandas==1.3.3 \
    matplotlib==3.4.3 \
    scikit-image==0.17.2 \
    scipy==1.7.3 \
    typing-extensions==3.7.4.3 \
    asgiref==3.4.1 \
    Django==3.2

# Reset to default interactive mode
ENV DEBIAN_FRONTEND=dialog

# Download CUDA, cudnn and tensorflow 
RUN wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_11.0.2_450.51.05_linux.run && \
    wget https://developer.download.nvidia.com/compute/redist/cudnn/v8.0.5/cudnn-11.0-linux-x64-v8.0.5.39.tgz 

# Expose ports 
EXPOSE 8000

# Set the default command to run at container runtime
CMD sh -c "\
    sh cuda_11.0.2_450.51.05_linux.run --silent --driver --toolkit --override && \
    export PATH=/usr/local/cuda/bin${PATH:+:${PATH}} && \
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc &&\
    . ~/.bashrc &&\
    tar -xzvf cudnn-11.0-linux-x64-v8.0.5.39.tgz && \
    cp cuda/include/cudnn.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_adv_infer.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_adv_train.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_backend.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_cnn_infer.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_cnn_train.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_ops_infer.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_ops_train.h /usr/local/cuda/include && \
    cp cuda/include/cudnn_version.h /usr/local/cuda/include && \
    cp cuda/lib64/libcudnn.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_infer.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_infer.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_infer.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_train.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_train.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_adv_train.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_infer.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_infer.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_infer.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_train.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_train.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_cnn_train.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_infer.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_infer.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_infer.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_train.so /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_train.so.8 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_ops_train.so.8.0.5 /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_static.a /usr/local/cuda/lib64 && \
    cp cuda/lib64/libcudnn_static.a /usr/local/cuda/lib64 && \
    chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn* && \
    pip3.8 install tensorflow-gpu==2.4 && \
    rm -rf cuda_11.0.2_450.51.05_linux.run && \
    rm -rf cudnn-11.0-linux-x64-v8.0.5.39.tgz && \
    rm -rf cuda && \
    /bin/bash"