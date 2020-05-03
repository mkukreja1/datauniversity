##### Configuration Parameters  ##################################################################

HADOOP_EXAMPLES_JAR=/opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hadoop-0.20-mapreduce/hadoop-test-2.6.0-mr1-cdh5.9.0.jar
BENCHMARK_DIR=/user/mkukreja/benchmark
NNBENCH_DIR=$BENCHMARK_DIR/NNBench-`hostname -s`
MAPPERS=100
REDUCERS=50
NUMBERFILES=100000
LOGDIR=/home/kukrejam/benchmark/nnbenchlogs
DATE=`date +%Y-%m-%d:%H:%M:%S`
RESULTSFILE="$LOGDIR/nnbench_results_$DATE"

###################################################################################################
echo "Start NNBench Test at $DATE with NUMBERFILES=$NUMBERFILES, MAPPERS=$MAPPERS, REDUCERS=$REDUCERS" >> $RESULTSFILE 2>&1

if [ ! -d "$LOGDIR" ]
then
    mkdir $LOGDIR
fi

hadoop fs -rm -r -skipTrash $NNBENCH_DIR >> $RESULTSFILE 2>&1

# Run NNBench
hadoop jar $HADOOP_EXAMPLES_JAR nnbench -operation create_write -maps $MAPPERS -reduces $REDUCERS -blockSize 1 -bytesToWrite 0 -numberOfFiles $NUMBERFILES -replicationFactorPerFile 3 -readFileAfterOpen true -baseDir $NNBENCH_DIR >> $RESULTSFILE 2>&1
 
mv NNBench_results.log $LOGDIR/NNBench_results_$DATE.log

echo "End NNBench Test at $DATE" >> $RESULTSFILE 2>&1

