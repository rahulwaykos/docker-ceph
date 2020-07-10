
# Ceph rbd for Docker volume
  ![docker-ceph](https://raw.githubusercontent.com/rahulwaykos/docker-ceph/master/docker-ceph.png)
  
 ## Ceph
 Ceph is an open-source software storage platform, implements object storage on a single distributed computer cluster, and provides 3in1 interfaces for : object-, block- and file-level storage. Ceph aims primarily for completely distributed operation without a single point of failure, scalable to the exabyte level, and freely available.
 
 ## Docker 
 Docker is opensource containerization technology. It is set of Platform as a Service(PaaS) product which uses OS-level virtualization to deliver the software as packages called Containers. Containers are isolated from each other which run on their own environment. Unlike the virtual machines which create seperate environment, docker allows containers to share or use kernel of same machine on which it is running. 
 
 ### Volumes in Docker
  Containers data is not persistent. Data inside a container gets deleted after container is terminated. To avoid loss of container data docker volumes comes into the picture. Volume is attached to container to store the data. The most direct way is declare a volume at run-time with the -v flag. Docker volumes are a way to map a file path inside a container, called a mount point, to a file system path or file-like object outside the container. Anything written to the Docker volume will be stored externally, so will persist across the lifetime of one or more containers.
 Docker volumes use a Docker storage driver to control how they interact with the storage layer they use. By default this driver provides access to the local file system. In our case we are going to use Ceph-RBD plugin. With the help of this plugin, we are going to create docker volume from the ceph rbd.
 
 ### Prerequisites:
 - Ceph Cluster
 - Docker
 
 ### Let's Do It
 Docker machine needs access for pool from ceph storage. To make this possible we need keyring from ceph admin. First we are going to create pool inside ceph cluster named docker_vol and then generate key for the same as a docker user.
 ```
 ceph osd pool create docker_vol 32
 ceph auth get-or-create client.docker osd 'allow rw pool=docker_vol' mon 'allow r'  -o /etc/ceph/ceph.client.docker.keyring
 ```
 Copy above generated keyring and ceph.conf file to docker client. Install ceph-common package to run ceph commands on docker machine. Move all copied files to the /etc/ceph/ directory. Now run following command 
 
 ![lspools](https://raw.githubusercontent.com/rahulwaykos/docker-ceph/master/Screenshot_2020-07-11_00-40-46.png)
 
 Next step is to install plugin for docker:
 ```
 docker plugin install wetopi/rbd \
  --alias=wetopi/rbd \
  LOG_LEVEL=1 \
  RBD_CONF_POOL="docker_vol" \
  RBD_CONF_CLUSTER=ceph \
  RBD_CONF_KEYRING_USER=client.docker
  ```
  Check it it is installed:
 
 ![plugin](https://raw.githubusercontent.com/rahulwaykos/docker-ceph/master/plugin.png)

Now create volume with following command:

 ![volume-ls](https://raw.githubusercontent.com/rahulwaykos/docker-ceph/master/volume-ls.png)
  
  Note: If volume create command some-how fails, please consider disabling some rbd features on client machine.
  
  Hope you enjoyed this blog!!! Happy Ceph-ing!!!
  
 
