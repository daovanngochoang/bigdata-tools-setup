
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

gpg --import KEYS

export HADOOP_VERSION=3.3.1
export HADOOP_URL=https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

mkdir -p /opt/hadoop-$HADOOP_VERSION/logs

mkdir -p /hadoop-data

export HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
export HADOOP_CONF_DIR=/etc/hadoop
export MULTIHOMED_NETWORK=1
export USER=root
export PATH=$PATH:$HADOOP_HOME/bin/

cp master_config/* "$HADOOP_HOME/etc/hadoop/" 

./master-set-up.sh