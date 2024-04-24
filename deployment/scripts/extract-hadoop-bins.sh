# extract hadoop binaries for hibench
tar -xzvf /usr/hdp/current/hadoop-client/mapreduce.tar.gz \
    --wildcards \
    --strip-components=4 \
    -C ~/ \
    'hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar' \
    'hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-*-tests.jar'