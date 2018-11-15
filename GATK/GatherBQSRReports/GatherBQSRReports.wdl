// 收集分散的BQSR重矫正报告到一个单独的文件中
// 分散的BQSR报告文件列表{
	public final List<File> inputReports = new ArrayList<>();
}

// 输出收集的报告文件{
	public File outputReport；
}

// protected Object doWork(){
	// 检验分散的BQSR报告文件是否可读且不是一个目录，有任何错误，运行时都会抛出异常
	// inputReports.forEach(IOUtil::assertFileIsReadable);{
		public static void assertFileIsReadable(final File file)
	}
	// 检查文件是否为非空文件，是否为可写范围,或者不存在，但是其父目录是存在的且是可写的，假如情况为false则抛出运行时异常
	// IOUtil.assertFileIsWritable(outputReport);{
		public static void assertFileIsWritable(final File file){
			
		}
	}
}