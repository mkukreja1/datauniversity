##### Configuration Parameters  ##################################################################

#HADOOP_EXAMPLES_JAR=/usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2.6.0-cdh5.8.0.jar
HADOOP_EXAMPLES_JAR=/opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hadoop-mapreduce/hadoop-mapreduce-examples-2.6.0-cdh5.9.0.jar
BENCHMARK_DIR=/user/mkukreja/benchmark
SIZE=20000000000
NUM_MAPPERS=50
#SIZE=5000000,  NUM_MAPPERS=5  will create 5  HDFS files 100MB approx each, total data 500 MB approx
#SIZE=10000000, NUM_MAPPERS=5  will create 5  HDFS files 200MB approx each, total data 1000 MB approx
#SIZE=20000000, NUM_MAPPERS=5  will create 5  HDFS files 400MB approx each, total data 2000 MB approx
#SIZE=20000000, NUM_MAPPERS=10 will create 10 HDFS files 200MB approx each, total data 2000 MB approx
#SIZE=40000000, NUM_MAPPERS=5  will create 5  HDFS files 800MB approx each, total data 4000 MB approx

TERASORT_INPUT_DIR=$BENCHMARK_DIR/terasort/$SIZE/input
TERASORT_OUTPUT_DIR=$BENCHMARK_DIR/terasort/$SIZE/output
TERASORT_VALIDATE_DIR=$BENCHMARK_DIR/terasort/$SIZE/validate

LOGDIR=/home/kukrejam/benchmark/teragenlogs
DATE=`date +%Y-%m-%d:%H:%M:%S`
RESULTSFILE="$LOGDIR/teragen_results_$DATE"

###################################################################################################
echo "Start Teragen Test at $DATE" >> $RESULTSFILE 2>&1

if [ ! -d "$LOGDIR" ]
then
    mkdir $LOGDIR
fi

hadoop fs -rm -r -skipTrash $TERASORT_INPUT_DIR  >> $RESULTSFILE 2>&1
hadoop fs -rm -r -skipTrash $TERASORT_OUTPUT_DIR  >> $RESULTSFILE 2>&1
hadoop fs -rm -r -skipTrash $TERASORT_VALIDATE_DIR  >> $RESULTSFILE 2>&1

echo "Time taken for Data Generation" >> $RESULTSFILE 2>&1
# Run Teragen
#hadoop jar $HADOOP_EXAMPLES_JAR teragen $SIZE $TERASORT_INPUT_DIR 
time hadoop jar $HADOOP_EXAMPLES_JAR teragen \
-Dmapreduce.map.log.level=INFO \
-Dmapreduce.reduce.log.level=INFO \
-Dyarn.app.mapreduce.am.log.level=INFO \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.cpu.vcores=1 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.map.maxattempts=1 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.output.compress=true \
-Dmapreduce.map.output.compress.codec=org.apache.hadoop.io.compress.Lz4Codec \
-Dmapreduce.reduce.cpu.vcores=1 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dmapreduce.reduce.maxattempts=1 \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.task.io.sort.factor=100 \
-Dmapreduce.task.io.sort.mb=384 \
-Dyarn.app.mapreduce.am.command.opts=-Xmx768m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dmapred.map.tasks=$NUM_MAPPERS \
$SIZE $TERASORT_INPUT_DIR >> $RESULTSFILE 2>&1
 
echo "Time taken for Sorting" >> $RESULTSFILE 2>&1
# Run Terasort
#hadoop jar $HADOOP_EXAMPLES_JAR terasort $TERASORT_INPUT_DIR $TERASORT_OUTPUT_DIR
time hadoop jar $HADOOP_EXAMPLES_JAR terasort \
-Dmapreduce.map.log.level=INFO \
-Dmapreduce.reduce.log.level=INFO \
-Dyarn.app.mapreduce.am.log.level=INFO \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.cpu.vcores=1 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.map.maxattempts=1 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.output.compress=true \
-Dmapreduce.map.output.compress.codec=org.apache.hadoop.io.compress.Lz4Codec \
-Dmapreduce.reduce.cpu.vcores=1 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dmapreduce.reduce.maxattempts=1 \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.task.io.sort.factor=300 \
-Dmapreduce.task.io.sort.mb=384 \
-Dyarn.app.mapreduce.am.command.opts=-Xmx768m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dmapred.reduce.tasks=92 \
-Dmapreduce.terasort.output.replication=1 \
$TERASORT_INPUT_DIR $TERASORT_OUTPUT_DIR >> $RESULTSFILE 2>&1

echo "Time taken for Validating" >> $RESULTSFILE 2>&1
# Run Teravalidate
#hadoop jar $HADOOP_EXAMPLES_JAR teravalidate $TERASORT_OUTPUT_DIR $TERASORT_VALIDATE_DIR
time hadoop jar $HADOOP_EXAMPLES_JAR teravalidate \
-Ddfs.blocksize=256M \
-Dio.file.buffer.size=131072 \
-Dmapreduce.map.memory.mb=2048 \
-Dmapreduce.map.java.opts=-Xmx1536m \
-Dmapreduce.reduce.memory.mb=2048 \
-Dmapreduce.reduce.java.opts=-Xmx1536m \
-Dyarn.app.mapreduce.am.resource.mb=1024 \
-Dyarn.app.mapreduce.am.command-opts=-Xmx768m \
-Dmapreduce.task.io.sort.mb=1 \
-Dmapred.map.tasks=185 \
-Dmapred.reduce.tasks=185 \
$TERASORT_OUTPUT_DIR $TERASORT_VALIDATE_DIR >> $RESULTSFILE 2>&1

echo "End Teragen Test at $DATE" >> $RESULTSFILE 2>&1

