timestamp=`date +%Y-%m-%d_%H%M%S`
duration=5
profiler_path=~/java/binaries/async-profiler/async-profiler-2.9-linux-x64

$profiler_path/profiler.sh -e wall -i 5ms -d $duration -o flat        -f "Factorize-wall-flat-${timestamp}.txt" jps
$profiler_path/profiler.sh -e wall -i 5ms -d $duration -o traces      -f "Factorize-wall-traces-${timestamp}.txt" jps
$profiler_path/profiler.sh -e wall -i 5ms -d $duration -o flat,traces -f "Factorize-wall-flat+traces-${timestamp}.txt" jps
$profiler_path/profiler.sh -e wall -i 5ms -d $duration -o tree        -f "Factorize-wall-tree-${timestamp}.html" jps
$profiler_path/profiler.sh -e wall -i 5ms -d $duration -o flamegraph  -f "Factorize-wall-flamegraph-${timestamp}.html" jps

$profiler_path/profiler.sh -e cpu -i 5ms -d $duration -o flat        -f "Factorize-cpu-flat-${timestamp}.txt" jps
$profiler_path/profiler.sh -e cpu -i 5ms -d $duration -o traces      -f "Factorize-cpu-traces-${timestamp}.txt" jps
$profiler_path/profiler.sh -e cpu -i 5ms -d $duration -o flat,traces -f "Factorize-cpu-flat+traces-${timestamp}.txt" jps
$profiler_path/profiler.sh -e cpu -i 5ms -d $duration -o tree        -f "Factorize-cpu-tree-${timestamp}.html" jps
