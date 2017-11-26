FROM ubuntu:16.04
LABEL maintainer caffe-maint@googlegroups.com

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        python-scipy \
        unzip &&\
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

COPY caffe.zip /opt
RUN cd /opt && \
    unzip caffe.zip

RUN cd /opt/caffe && \
    pip install --upgrade pip && \
    cd python && for req in $(cat requirements.txt) pydot; do pip install $req; done && cd .. && \
    cp Makefile.config.example Makefile.config && \
    sed -i 's%# CPU_ONLY := 1%CPU_ONLY := 1%' Makefile.config && \
    sed -i 's%INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include%INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include /usr/include/hdf5/serial%' Makefile.config && \
    sed -i 's%LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib%LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/hdf5/serial%' Makefile.config && \
    make -j"$(nproc)" && \
    make pycaffe

    RUN pip --no-cache-dir install --upgrade ipython && \
    	pip --no-cache-dir install \
    		Cython \
    		ipykernel \
    		jupyter \
    		path.py \
    		Pillow \
    		pygments \
    		six \
    		sphinx \
    		wheel \
    		zmq \
    		&& \
    	python -m ipykernel.kernelspec


ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig


# Set up notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/

# Expose Ports for Ipython (8888)
EXPOSE 8888

# Copy the ipython notebook
WORKDIR /workspace
COPY crfasrnn.ipynb TVG_CRFRNN_COCO_VOC.caffemodel TVG_CRFRNN_new_deploy.prototxt input.jpg /workspace/
