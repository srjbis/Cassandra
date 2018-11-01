################################# Installing wget in EC2-Instance########################################
yum install wget -y;

################################# Downloading JAVA and CASSANDRA packages #########################################
cd /home/ec2-user/;
wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz;
wget http://mirrors.estointernet.in/apache/cassandra/3.11.3/apache-cassandra-3.11.3-bin.tar.gz;

################################ Extracting the packages of JAVA and CASSANDRA ###################################

tar xvf jdk-8u191-linux-x64.tar.gz;
tar xvf apache-cassandra-3.11.3-bin.tar.gz;
mv jdk1.8.0_191 jdk;
mv apache-cassandra-3.11.3 cassandra;

################################ Configuring the environment varriable for JAVA and CASSANDRA ####################

path_of_java=`pwd`
echo "JAVA_HOME=`echo $path_of_java`/jdk" >> /etc/profile;
echo "JRE_HOME=`echo $path_of_java`/jdk/jre" >> /etc/profile;
echo "CASSANDRA_HOME=`echo $path_of_java`/cassandra/" >> /etc/profile;
echo "PATH=\$PATH:\$HOME/.local/bin:\$HOME/bin:\$JAVA_HOME/bin:\$JRE_HOME/bin:\$CASSANDRA_HOME/bin" >> /etc/profile;
echo "export PATH" >> /etc/profile;
source /etc/profile;
source /etc/profile;

################################ configuring CASSANDRA ####################################

sed -i "s/\- seeds: .*/- seeds: \"`hostname -i`\"/g" $CASSANDRA_HOME/conf/cassandra.yaml;
sed -i "s/^listen_address: .*/listen_address: `hostname -i`/g" $CASSANDRA_HOME/conf/cassandra.yaml;
sed -i "s/^rpc_address: .*/rpc_address: `hostname -i`/g" $CASSANDRA_HOME/conf/cassandra.yaml;
sed -i "s/^endpoint_snitch:     .*/endpoint_snitch: GossipingPropertyFileSnitch/g" $CASSANDRA_HOME/conf/cassandra.yaml;
cd $CASSANDRA_HOME;
sudo mkdir data;
chmod 777 data;

############################### starting the CASSANDRA by ec2-user #################################
su ec2-user << EOSU
cd $CASSANDRA_HOME/bin
./cassandra -f
EOSU
