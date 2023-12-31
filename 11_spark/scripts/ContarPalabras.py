import sys
try:
    from pyspark import SparkContext, SparkConf
    
    conf = SparkConf()
    sc = SparkContext(conf=conf)
    inputPath = sys.argv[1]
    outputPath = sys.argv[2]

    Path = sc._gateway.jvm.org.apache.hadoop.fs.Path
    FileSystem = sc._gateway.jvm.org.apache.hadoop.fs.FileSystem
    Configuration = sc._gateway.jvm.org.apache.hadoop.conf.Configuration
    fs = FileSystem.get(Configuration())

    if fs.exists(Path(inputPath)) == False:
        print("El fichero de entrada no existe")

    else:
        if fs.exists(Path(outputPath)):
            fs.delete(Path(outputPath), True)

        tfile = sc.textFile(inputPath)
        ffile = tfile.flatMap(lambda l: l.split(" "))
        mfile = ffile.map(lambda w: (w, 1))
        rbkfile = mfile.reduceByKey(lambda t, e: t + e)
        rbkfile.saveAsTextFile(outputPath)

        print("El fichero de salida se ha creado correctamente")
except ImportError as e:
    print("Error al ejecutar el programa", e)
    sys.exit(1)
        