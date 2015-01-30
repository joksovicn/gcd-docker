############################################################
# Dockerfile to emulate Google Cloud Datastore
# Based on oracle-java7
############################################################

# Set the base image to oracle-java7
FROM dockerfile/java:oracle-java7

# File Author / Maintainer
MAINTAINER Nemanja Joksovic

################## BEGIN INSTALLATION ######################

# Download and unpack Google Cloud Datastore
RUN \
  cd /root && \
  curl -o v1beta2.zip http://storage.googleapis.com/gcd/tools/gcd-v1beta2-rev1-2.1.1.zip && \
  unzip v1beta2.zip && \
  rm v1beta2.zip

# Create .bashrc profile file
RUN \
  echo >> /root/.bashrc && \
  echo 'export DATASTORE_HOST=http://0.0.0.0:8000' >> /root/.bashrc && \
  echo 'export DATASTORE_DATASET=temp_data' >> /root/.bashrc

# Create a temp data folder
RUN \
  cd /root && \
  mkdir temp_data && \
  /root/gcd-v1beta2-rev1-2.1.1/gcd.sh create --dataset_id=temp_data /root/temp_data/

##################### INSTALLATION END #####################

# Define working directory
WORKDIR /root

# Expose the default port
EXPOSE 8000

# Set default container command
ENTRYPOINT ["./gcd-v1beta2-rev1-2.1.1/gcd.sh", "start", "--host=0.0.0.0", "--port=8000", "/root/temp_data"]
