# crfasrnn docker


This is a dockerfile for building a docker image to run CRFASRNN with Caffe.

### Build your own docker image
1. Make sure your have installed docker.

2. In your terminal, git clone the repository and build the docker image with the following command. Make sure you have downloaded the TVG_CRFRNN_COCO_VOC.caffemodel and TVG_CRFRNN_COCO_VOC.prototxt before this command.
```
docker build -t crfasrnn .
```

### How to run your own docker image after you build them
3. Then run the following command to run the docker image

```
docker run -it -p 8888:8888 crfasrnn jupyter notebook --allow-root
```

4. In your browser (e.g. Chrome), you can type the following link to access to the jupyter notebook, and play with the code
```
localhost:8888
```


### License
MIT LICENSE.
