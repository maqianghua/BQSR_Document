RealignerReducer.wdl

private RealignerOptions option = new RealignerOptions(); /	重比对参数
private SAMFileHeader mHeader = null; / SAM头文件
private QualityControlFilter filter = new QualityControlFilter();	/ 质量过滤控制
private ArrayList<GaeaSamRecord> records = new ArrayList<GaeaSamRecord>();	/ SAMRecord(key 对应的read值)列表
private ArrayList<GaeaSamRecord> filteredRecords = new ArrayList<GaeaSamRecord>();	/ 过滤后的SAMRecord列表
private ReferenceShare genomeShare = null;	/ 参考基因组reference
private DbsnpShare dbsnpShare = null;	/ 已知变异文件dbsnp
private VCFLocalLoader loader = null;	/ VCF本机加载器
private RealignerEngine engine = null;	/ 处理重比对engine
private RecalibratorContextWriter writer = null;	/ 重比对Context
private RecalibratorEngine recalEngine = null;	/ 重矫正engine
private RealignerExtendOptions extendOption = new RealignerExtendOptions();	/ 重比对扩展选项,(接收来自hadoop的一些配置选项)

protected void setup(Context context) throws IOException{
	/ 获取hadopp的设置参数，并解析相应的重比对参数列表
	/ 获取重比对参数列表option
	/ 获取SAM头文件；mHeader
	/ 获取reference文件:genomeShare
	/ 获取dbsnp的vcf文件和*.vcf.window.idx文件:dbsnpShare
	/ 建立dbsnp文件对象加载器:loader
	/ 建立重矫正ContextWriter对象:writer
	/ 创建重比对处理器对象:engine
	/ 假如重矫正为真{
		/ 创建重矫正处理的engine对象：recalEngine
	}
}

public void reduce(WindowsBasedWritable key, Iterable<SamRecordWritable> values, Context context) throws IOException, InterruptedException{
	/ 利用key获取染色体索引值，有可能为-1
	/ 获取对应的窗体ID
	/ 判断染色体ID是否为-1，假如-1就是read未必对上
	/ 假如read未必对上reference{
		/ 遍历所有的read，构建GaeaSamRecord
		/ 清空SAMRecord列表,清空过滤后的SAMRecord列表 
	}
	/ 利用染色体ID和窗体ID设置win
	/ Window win = setWindows(chrIndex, winNum)
	private Window setWindows(int chrIndex, int winNum) {
		/ 获取窗体ID对应的起始窗体位置
		/ 假如获取染色ID对应的序列为null，抛出运行时异常，reference上没有对应的对应染色体ID的序列
		/ 获取染色体ID对应的染色体名
		/ 获取窗体ID对应的终止窗体位置：条件：窗体终止位置小于染色体长度？；是：窗体终止位置；否：染色体长度(染色体终止位置)
		/ 返回:一个包含染色体名，染色体ID，窗体起始位置，窗体终止位置的window对象。
	}
	/ 假如重比对为真{不用管}
	/ 假如重矫正为真
	/ else if (extendOption.isRecalibration()){
		/ 根据null， reads，染色体名，窗体ID，比对reads处理
		/ this.recalEngine.mapReads(null, values, win.getContigName(), winNum);
		public void mapReads(ArrayList<GaeaSamRecord> records, Iterable<SamRecordWritable> iterator, String chrName,int winNum){
			/ 根据染色体名，窗体ID，设置添加BaseAndSNPInformation information的信息
			/ setWindows(chrName, winNum);
			private void setWindows(String chrName, int winNum){
				/ 窗体的起始位置，窗体的终止位置,(相邻的窗体有交叉，详见问题5)
				/ information对象设置reference，染色体名，窗口起始位置，窗口终止位置
				/ information.set(chrInfo, chrName, start, end);
				public void set(ReferenceShare reference, String chrName, int start, int end){
					/ 根据染色体名在reference上获取染色体信息
					/ 根据染色体信息，窗口起始位置，窗口终止位置获取窗体内碱基序列
					/ set(chrInfo, start, end);
					public void set(ChromosomeInformationShare chrInfo, int _start, int _end){
						/ 获取窗体内到的碱基序列
						/ 获取窗体内所有碱基中包含的已知SNPs
					}
				}
			}
			/ records为null，但是iterator不为null
			/ 遍历所的SAMRecordWritable read {
				/ 获取read所在的窗体ID，readWinNum=read比对起始位置/windowsSize(默认值10000)
				/ 获取GaeaSamRecord对象sam，假如该read所在窗体和reduce的窗体一致，就设置mustBeOut为true，否则为false;mustBeOut判断该read是否需要最终被输出。什么情况下会出现read的ID和窗体的ID号不一致呢?因为前面是通过不同的方法划分窗口的，详见WindowsBasedMapper.wdl的winNums
				/ read碱基质量统计
				/ baseQualityStatistics(sam);
				private void baseQualityStatistics(GaeaSamRecord read){
					/ 假如mustBeOut为真（read的ID和窗体的ID一致）{
						/ 假如read过滤没有通过,(read的过滤包含filterDuplicateRead;filterMappingQualityUnavailable;filterMappingQualityUnavailable;filterNotPrimaryAlignment;filterUnmappedReads;FailsVendorQualityCheckFilter;和MalformedReadFilter：checkInvalidAlignmentStart;checkInvalidAlignmentEnd;checkAlignmentDisagreesWithHeader;checkHasReadGroup;checkMismatchingBasesAndQuals;checkCigarDisagreesWithAlignment){
							/ 比对read，通过协变量矫正read
							/ mapRead(read);
							private void mapRead(GaeaSamRecord read) {
								/ 假如read是SOLiDRead或者参数选项是SOLID_RECAL_MODE，就什么都不做
								/ 获取read的比对起始位置和终止位置
								/ 获取read的各个碱基相对于reference的偏移量int[] readOffsets
								/ 获取read的碱基质量值byte[] quals
								/ 获取read的碱基byte[] bases
								/ 设置碱基与dbsnp的一致性，read的协变量
								/ 遍历read上的碱基{
									/ 获取该位点碱基相对于reference的位置
									/ 
								}
							}
						}
					}
				}
			}
		}
	}
}