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
	/ 建立重矫正ContextWriter对象:writer（多个reduce输出目录）：writer = new RecalibratorContextWriter(context, true);
	public RecalibratorContextWriter(Context ctx,boolean multiple){
		/ 当mutiple为true；建立多个reduce输出为真mos就不为null
		/ 将该对象的Context赋值给RecalibratorContextWriter类对象的成员变量context
		/ 创建SamRecordWritable对象给value
	}
	/ 创建重比对处理器对象:engine（根据根据重比对参数option,reference文件genomeShare，dbsnp加载器loader，read的SAM头文件mHeader，多reducer输出对象Writer）
	/ 假如重矫正为真{
		/ 创建重矫正处理的engine对象：recalEngine（根据扩展的hadoop参数extendOption获取是否进行重矫正,reference文件genomeShare，，read的SAM头文件mHeader,扩展的hadoop参数extendOption获取是否进行重比对，多个reduce输出对象writer）
	}
}

public void reduce(WindowsBasedWritable key, Iterable<SamRecordWritable> values, Context context) throws IOException, InterruptedException{
	/ 利用key获取染色体索引值，有可能为-1（read没有比对上reference）
	/ 获取对应的窗体ID
	/ 判断染色体ID是否为-1，假如-1就是read未必对上reference
	/ 假如read未比对上reference{
		/ 遍历所有的read，{
			/ 构建GaeaSamRecord
			/ reduce输出
		}
		/ 清空SAMRecord列表,清空过滤后的SAMRecord列表
		/ reduce结束；
	}
	/ 利用染色体ID和窗体ID设置win（包含染色体名，染色体ID，窗体起始位置，窗体终止位置）
	/ Window win = setWindows(chrIndex, winNum)
	private Window setWindows(int chrIndex, int winNum) {
		/ 获取窗体ID对应的窗体起始位置（相对于reference）
		/ 假如获取染色ID对应的序列为null，抛出运行时异常，reference上没有对应的对应染色体ID的序列
		/ 获取染色体ID对应的染色体名
		/ 获取窗体ID对应的终止窗体位置（相对于reference）：条件：窗体终止位置小于染色体长度？；是：窗体终止位置；否：染色体长度(染色体终止位置)
		/ 返回:一个包含染色体名，染色体ID，窗体起始位置，窗体终止位置的window对象。
	}
	/ 假如重比对为真{不用管}
	/ 假如重矫正为真
	/ else if (extendOption.isRecalibration()){
		/ 比对reads：根据null， reads，窗体内包含的contigName（染色体名），窗体ID，
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
					/ 根据染色体信息，窗口起始位置，窗口终止位置设置窗体内碱基序列
					/ set(chrInfo, start, end);
					public void set(ChromosomeInformationShare chrInfo, int _start, int _end){
						/ 获取窗体内的碱基序列sequences（reference上的碱基序列）
						/ 获取窗体内所有碱基中包含的已知SNPs
					}
				}
			}
			/ records为null，但是iterator不为null
			/ 遍历所的SAMRecordWritable read {
				/ 获取read所在的窗体ID readWinNum=read比对起始位置/windowsSize(默认值10000)
				/ 获取GaeaSamRecord对象sam：根据mHeader，read，是否输出该read（假如该read所在窗体和reduce的窗体一致，就设置mustBeOut为true，否则为false;mustBeOut判断该read是否需要最终被输出。什么情况下会出现read的ID和窗体的ID号不一致呢?因为前面是通过不同的方法划分窗口的，详见WindowsBasedMapper.wdl的winNums）
				/ read碱基质量统计
				/ baseQualityStatistics(sam);
				private void baseQualityStatistics(GaeaSamRecord read){
					/ 假如mustBeOut为真（read的ID和窗体的ID一致，输出该read）{
						/ 假如read过滤没有通过,(read的过滤包含filterDuplicateRead;filterMappingQualityUnavailable;filterMappingQualityUnavailable;filterNotPrimaryAlignment;filterUnmappedReads;FailsVendorQualityCheckFilter;和MalformedReadFilter：checkInvalidAlignmentStart;checkInvalidAlignmentEnd;checkAlignmentDisagreesWithHeader;checkHasReadGroup;checkMismatchingBasesAndQuals;checkCigarDisagreesWithAlignment){
							/ 比对read，通过协变量矫正read
							/ mapRead(read);
							private void mapRead(GaeaSamRecord read) {
								/ 假如read是SOLiDRead或者参数选项是SOLID_RECAL_MODE；该read就什么都不做，退出比对read函数
								/ 获取read的比对起始位置和终止位置
								/ 获取read的各个碱基相对于reference的偏移量int[] readOffsets
								/ 获取read的碱基质量值byte[] quals
								/ 获取read的碱基byte[] bases
								/ 设置碱基与dbsnp的一致性consistent，read的协变量rcovariate
								/ 遍历read上的碱基{
									/ 获取该位点碱基相对于reference的位置qpos
									/ 判断该位点是SNP为假(只判断mismatch？){
										/ 该位点与reference上碱基不匹配{
											/ 假如read的Color Space与预先设置的color标签值不一致？，退出比对read函数。
											/ 否则,计算该read的协变量
											/ rcovariate = RecalibratorUtil.computeCovariates(read, covariates);{
												/ 见 RecalibratorUtil.wdl
											}
										}
										/ 假如该碱基未必对在reference上，或碱基质量值小于6，或该read的协变量为null，或该碱基与read的Color space不一致；退出当前碱基操作，继续遍历下一个碱基操作
										/ 根据碱基在reference上的位置，碱基字节码，碱基质量，reference上的碱基字符值（强转为字节码值byte），read的协变量。更新数据表。
										/ dataUpdate(qpos, (byte) bases[qpos], quals[qpos], (byte) information.getBase(i), rcovariate);
										public boolean dataUpdate(final int offset, final byte base, final byte quality, final byte refBase,final ReadCovariates readCovariates){
											/ 判断read碱基与ref碱基是否不一致isError：！不一致：true，！一致：false
											/ 事件类型为SNP EventType eventType
											/ 根据该偏移位置（位点)和对应的事件类型，获取协变量int[] keys值.(包含0=ReadGroup,1=Quality,2=Context或Cycle)
											/ 获取当前事件的索引(SNP的索引为0)int eventIndex=0
											/ 获取NestedObjectArray<RecalibratorDatum> rgRecalTable
											/ 获取原先的RecalibratorDatum rgPreviousDatum:根据keys[0]=0;eventIndex=0;
											/ 获取该rg的RecalibratorDatum rgThisDatum:根据碱基质量和与reference的碱基的一致性boolean值
											/ 假如返回的rgPreviousDatum 为null{
												/ 将rgThisDatum加入到rgRecalTable中（包含rgThisDatum，0=ReadGroup,0=eventIndex）
											}/ 否则{
												/ 将rgPreviousDatum和rgThisDatum合并
												/ rgPreviousDatum.combine(rgThisDatum);
												public void combine(RecalibratorDatum other) {
													/ 计算合并后的误差combineErrors：原始(测序下机)误差与比对误差
													/ 给rgPreviousDatum对象增加碱基数量numBases
													/ 计算rgPreviousDatum的estimatedQuality值：根据合并后的误差combineErrors和碱基数numBases
													/ 给rgPreviousDatum对象增加numMismatches数量	
												}
											}
											/ 获取NestedObjectArray<RecalibratorDatum> qualRecalTable
											/ 获取原先的qualPreviousDatum：根据readgroup，quality，和SNP
											/ 假如qualPreviousDatum为null{
												/ 根据碱基质量和isError创建RecalibratorDatum，并将其添加到qualRecalTable中：（RecalibratorDatum对象，readgroup，quality，SNP）
											}/ 否则{
												/ 给qualPreviousDatum增加碱基数，
												/ 假如误差为true，就增加MismatchNumber
											}
											/ 遍历可选的协变量（Context或Cycle）{
												/ 假如协变量对应的keys[i]小于0，跳过本次循环
												/ 获取可选协变量的表格covRecalTable
												/ 获取原先的covPreviousDatum：根据readGroup，quality，可选协变量，SNP
												/ 假如covPreviousDatum为null{
													/ 根据碱基质量和isError创建RecalibratorDatum对象，并将其添加到covRecalTable中：（RecalibratorDatum对象，readGroup，quality，可选协变量，SNP）
												}/ 否则{
													/ 给covPreviousDatum增加碱基数
													/ 假如误差为true，就增加MismatchNumber
												}
											}
											/ 返回 碱基是否与reference上的碱基一致性判断。
										}
									} 
								}
							}
						}
					}
				}
				/ 假如是重比对为真{输出read}该步骤可以忽略
			}
		}
	}
	/ 清空 ArrayList<GaeaSamRecord> records和 ArrayList<GaeaSamRecord> filteredRecords
}

protected void cleanup(Context context) throws IOException, InterruptedException{
	/ 假如质量值矫正为真{
		/ 获取重矫正表格RecalibratorTable table=RecalibratorTable recalibratorTables
		/ 输出重矫正表格
		/ writer.write(table);
		public void write(RecalibratorTable table){
			/ 将所有的table里的值转换成String； table.valueStrings()
			public ArrayList<String> valueStrings(){
				/ 创建一个ArrayList<String> arrays
				/ 遍历所有的table{
					/ 获取第i个table
					/ 获取第i个table对应的所有元素；table.getAllLeaves();
					public List<Leave> getAllLeaves(){
						/ 创建List<Leave> result
						/ 将所有的Leaves填充到result；fillAllLeaves(data, new int[0], result);
						private void fillAllLeaves(final Object[] array, final int[] path, final List<Leave> result){
							/ 遍历所有的readGroup数据{
								/ 获取第key(从0开始)readGroup对应的Object value
								/ 假如Object value为null，结束本次循环进入下一次循环
								/ 否则创建一个int[] newPath对象（为了进行唯一性区分，因为只要对象的地址值才会是唯一的）
								/ 假如Object value是Object[] 实例{
								/ 进入递归调用并填充所有的Leaves
								}/ 否则{
									/ 根据int[] newPath和Object value封装一个Leave对象，并将其添加到List<Leave> result中
								}
							}
						}
						/ 返回填充所有Leaves的result对象
					}
					/ 遍历第i个table所有的leaves{
						/ 将leave转换成String；leave.toString(i)：根据第i个表的索引值
						 public String toString(int index){
						 	/ 创建StringBuilder对象sb，添加index，添加"\t",添加一个readGroup对应多个pu的情况keys,添加pu，添加"\t"，添加(rgtable或PU对应的table)内容（碱基数量，mismatch数量，estimatedQuality）
						 }
						 / 添加leave的String到ArrayList<String> arrays
					}
				}
				/ 返回ArrayList<String> arrays
			}
			/ 遍历所有table转成String的对象{
				/ 假如mos为null{
					/ 输出str值
				}否则(mos不为null，说明是多个输出，也就是说有多个reduce){
					/ 输出多个reducer
				}
			}
		}
	}
}