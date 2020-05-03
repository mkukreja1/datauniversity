##### Configuration Parameters  ##################################################################

HADOOP_EXAMPLES_JAR=/opt/cloudera/parcels/CDH-5.9.0-1.cdh5.9.0.p0.23/lib/hadoop-0.20-mapreduce/hadoop-test-2.6.0-mr1-cdh5.9.0.jar
BENCHMARK_DIR=/user/mkukreja/benchmark
TESTDFSIO_OUTPUT_DIR=$BENCHMARK_DIR/TestDFSIO
NUMBERFILES=500
FILESIZE=5000
#NUMBERFILES=10 output files of size 1GB(FILESIZE=1000) for a total of 10GB 
LOGDIR=/home/kukrejam/benchmark//testdfsiologs
DATE=`date +%Y-%m-%d:%H:%M:%S`
RESULTSFILE="$LOGDIR/testdfsio_results_$DATE"

###################################################################################################
echo "Start TestDFSIO Test at $DATE for NUMBERFILES=$NUMBERFILES, FILESIZE=$FILESIZE" >> $RESULTSFILE 2>&1

if [ ! -d "$LOGDIR" ]
then
    mkdir $LOGDIR
fi

# Run TestDFSIO write
hadoop jar $HADOOP_EXAMPLES_JAR TestDFSIO -write -nrFiles $NUMBERFILES -fileSize $FILESIZE >> $RESULTSFILE 2>&1

# Run TestDFSIO read
hadoop jar $HADOOP_EXAMPLES_JAR TestDFSIO -read -nrFiles $NUMBERFILES -fileSize $FILESIZE >> $RESULTSFILE 2>&1 

# Run TestDFSIO clean
hadoop jar $HADOOP_EXAMPLES_JAR TestDFSIO -clean >> $RESULTSFILE 2>&1

mv TestDFSIO_results.log $LOGDIR/TestDFSIO_results__$DATE.log
echo "End TestDFSIO Test at $DATE" >> $RESULTSFILE 2>&1

