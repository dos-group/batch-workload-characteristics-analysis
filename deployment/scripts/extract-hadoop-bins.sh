# extract hadoop binaries for hibench
tar -xzvf /usr/hdp/current/hadoop-client/mapreduce.tar.gz \
    --wildcards \
    --strip-components=4 \
    -C /usr/hdp/current/hadoop-client/examples/ \
    'hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-*-tests.jar'

mv /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-*-tests.jar /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-tests.jar
chmod +x /usr/hdp/current/hadoop-client/examples/hadoop-mapreduce-client-jobclient-tests.jar