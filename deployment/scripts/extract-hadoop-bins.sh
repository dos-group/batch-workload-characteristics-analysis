# extract hadoop binaries for hibench
sudo tar -xzvf /usr/hdp/current/hadoop-client/mapreduce.tar.gz \
    --wildcards \
    --strip-components=4 \
    -C /usr/hdp/current/hadoop-client/examples/ \
    'hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-*-tests.jar'

sudo mv /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-*-tests.jar /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-tests.jar
sudo chmod +x /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-tests.jar