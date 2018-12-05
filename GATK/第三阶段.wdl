第三阶段
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\tools\walkers\bqsr\BaseRecalibrator.java
D:\GitHub\back\gatk\src\main\java\org\broadinstitute\hellbender\utils\recalibration\BaseRecalibrationEngine.java

//针对每条read在该位点获取不同的协变量值，并基于该碱基是否匹配到reference特定的位置，在map中增加该位置。
 public void apply( GATKRead read, ReferenceContext ref, FeatureContext featureContext ) {
 	recalibrationEngine.processRead(read, referenceDataSource, featureContext.getValues(knownSites));
 	// 针对每条read在该位点获取不同的协变量值，并基于该碱基是否匹配到reference特定的位置，在map中增加该位置。
 	 public void processRead( final GATKRead originalRead, final ReferenceDataSource refDS, final Iterable<? extends Locatable> knownSites ){
 	 	// read转换
 	 	/ final ReadTransformer transform = makeReadTransform();
 	 	private ReadTransformer makeReadTransform() {
 	 		/ ReadTransformer f0 = (ReadTransformer) BaseRecalibrationEngine::consolidateCigar;
 	 		private static GATKRead consolidateCigar( final GATKRead read )
 	 		private static GATKRead consolidateCigar( final GATKRead read ){
				// 总是合并cigar字符串成一个标准(canonical)的模式，折叠0长度/重复的cigar元素； 下游的编码没必要处理非合并的（non-consolidated）cigar字符串
				read.setCigar(AlignmentUtils.consolidateCigar(read.getCigar()));{
					// 返回一个Cigar对象描述read是如何比对到reference上的，假如没有cigar的话，那就返回一个空的Cigar对象。假如有必要该方法会在read中复制一个cigar，因此修改该方法的返回值，不会修改read的Cigar。该方法的调用者仅仅想迭代Cigar的元素，应该调用getCigarElements()代替，他能提供更好的性能，避免了对象的建立。
					Cigar getCigar();
					// 需要你一个格式良好，合并了的Cigar字符串，从而使得左边的对比代码能正确执行，举例：1M1M1M1D2M1M-->3M3D3M;假如给定的cigar是空值，然后返回的cigar也是空值。注意：折叠这种cigar大小是0的元素。因此2M0M=>2M.输入需要合并的cigar；返回一个连续匹配操作的非空cigar，合并成一个操作（运算符）。
					public static Cigar consolidateCigar( final Cigar c )
					// 使用已存在的{@link Cigar}设置read的Cigar,描述read是如何比对到reference上的
					 void setCigar( final Cigar cigar );
				}
 	 		}
 	 		/ final ReadTransformer readTransformer1 = f.andThen((ReadTransformer) BaseRecalibrationEngine.this::setDefaultBaseQualities);
 			private GATKRead setDefaultBaseQualities( final GATKRead read ){
 				// 检查假如我们是否需要使用默认质量值，假如有必要就添加默认值
	 	 	 	// 1. 假如reads有缺失或者有不完整的质量分数，我们就需要默认质量值
	 	 	 	// 2. 假如默认的碱基质量是一个的正值，我们就添加默认质量值
 	 		}	
 	 	 	/ f.andThen(read -> resetOriginalBaseQualities(read));{
 	 		private GATKRead resetOriginalBaseQualities( final GATKRead read ){
 	 			// 假如用户不使用原始碱基的质量直接返回read{
 	 				// 该标记是告诉GATK使用原始的碱基质量（在BQSR重矫正之前的数据中），被存储在OQ标签中。假如它们存在（OQ），就不使用矫正后的质量分数。read中没有OQ标签，将会使用标准的质量值分数。
 	 				@Argument(fullName="use-original-qualities", shortName = "OQ", doc = "Use the base quality scores from the OQ tag", optional = true)
					public Boolean useOriginalBaseQualities = false;
 	 			}
 	 			// 假如使用原始的碱基质量， 重置read的质量分数到原始值（BQSR前）
 	 			/ return ReadUtils.resetOriginalBaseQualities(read); 	 			
 	 			public static GATKRead resetOriginalBaseQualities(final GATKRead read) 
 	 		}	 	 	
 	 	 	/ f.andThen(ReadClipper::hardClipAdaptorSequence);{
 	 	 		public static GATKRead hardClipAdaptorSequence (final GATKRead read){
 	 	 			return new ReadClipper(read).hardClipAdaptorSequence();{
 	 	 				// 检查是否一个read时候包含接头序列，假如有，就硬过滤掉他们。注意：想明白一个read怎么被检查包含接头序列，查看ReadUtils.getAdaptorBoundary()；返回一个不包含接头序列的新read（有没有比对上的read，就返回空值）
	 	 	 			private GATKRead hardClipAdaptorSequence ()
	 	 	 			// 初始化一个ReadClipper对象；使用add0P方法，你可以设置你的Clpping操作对象。当你已准备好利用所有的Clpping操作对象生成一个新read的时候，就用clipRead().注意：假如你想在一个read上使用Clipping0p类设置一个多操作对象就用该对象。假如你仅仅想应用一个典型的模式的clipping，在该类中使用可得到的静态的clipping函数作为代替方法。返回：clip的read
	 	 	 			public ReadClipper(final GATKRead read) 	 	 	 			
 	 	 			}
 	 	 		}
 	 	 	}
 	 	 	final ReadTransformer readTransformer = f.andThen(ReadClipper::hardClipSoftClippedBases);{
 	 	 		public static GATKRead hardClipSoftClippedBases (final GATKRead read){
 	 	 			return new ReadClipper(read).hardClipSoftClippedBases();{ 	 	 				
	 	 	 			// 在read上将会硬clip每一个已被软clipped碱基；返回：没有已被软clipped碱基的新read（假如所有碱基都是被软clipped且硬clips，非比对read，应该返回空值）
	 	 	 			private GATKRead hardClipSoftClippedBases ()
 	 	 				// 初始化一个ReadClipper对象；使用add0P方法，你可以设置你的Clpping操作对象。当你已准备好利用所有的Clpping操作对象生成一个新read的时候，就用clipRead().注意：假如你想在一个read上使用Clipping0p类设置一个多操作对象就用该对象。假如你仅仅想应用一个典型的模式的clipping，在该类中使用可得到的静态的clipping函数作为代替方法。返回：clip的read
	 	 	 			public ReadClipper(final GATKRead read) 
 	 	 			}
 	 	 		}
 	 	 	}
 	 	 }
 	 	// 整条read都在adapter里面，那就跳过该reads
 	 	if( read.isEmpty() ) return;
 	 	// 重矫正的两个步骤间的共享代码，它使用命令行参数去调整read的属性，就比如quals和platform字符串；输入：需要调整的read；需要共享的参数列表
 	 	RecalUtils.parsePlatformForRead(read, readsHeader, recalArgs);
 	 	// 注意：该函数修用来修改isSNP，isInsertion和isDeletion参数，因此不能被忽略，不管是否执行BAQ
 	 	final int nErrors = calculateIsSNPOrIndel(read, refDS, isSNP, isInsertion, isDeletion);
		// 定位所有的SNP和indel事件，把他们储存在提供的snp，isIns和isDel数组中；并返回总的SNP和indel事件的数量；输入：检测到的read；reference数据资源，存储snp事件的数组（和read的长度一致，初始化值都是0）；存储insertion事件的数组(和read的长度一致，初始化值都是0)；存储deletion的事件数组（和read的长度一致，初始化值都是0）；返回:总的SNP和indel事件的总数
		protected static int calculateIsSNPOrIndel(final GATKRead read, final ReferenceDataSource ref, int[] snp, int[] isIns, int[] isDel) {
			// 在该reference上查询确定的区间(contig)，并同时获得横跨那个区间的所有碱基。调用getBases()方法在返回的ReferenceSequence获得真实的reference碱基。查看BaseUtils类，引导用户知道，在该格式下是怎样处理碱基的。输入：查询的contig区间；查询区间的开始，查询区间的结束；返回：查询并取出横跨区间且包含所有碱基的ReferenceSequence。			
			final byte[] refBases = ref.queryAndPrefetch(read.getContig(), read.getStart(), read.getEnd()).getBases();{
				// 获取该read比对上的contig名称，假如没有独特的比对（没有比对上），有可能会返回null。返回：比对上的contig名称，有可能是null
				String getContig();
				// 返回：基于1开始的位置索引，假如getContig()==null，返回值未定义
				int getStart()
				// 返回基于1开始，结束位置的索引，假如getContig()==null，返回值未定义
				int getEnd()
			}
			for (final CigarElement ce : read.getCigarElements()) {
				// 返回：从该read的不可修改的CigarElements列表;注意：通过调用getCigar().getCigarElements()，默认实现是返回不可修改的保护视图副本； 子类有可能会覆盖该方法
				read.getCigarElements()
				for (final CigarElement ce : read.getCigarElements())
				// 针对不同的Cigar进行相应的操作（自加解释）
				switch (ce.getOperator()) {
					// 匹配或者错配
					case：M
					// 匹配到reference
					case: EQ
					// 错配到reference
					case: X
					// Deletion vs the reference
					case: D
					// 跳过reference的区域
					case: N
					// Insertion vs the reference
					case: I
					// 软切除，跳过read中的部分序列，不改变read的长度
					case: S // ReferenceContext没有软跳过碱基
					// 硬切除，直接剪切掉read中的分布序列，会改变read的长度
					case: H
					// 填补，（简单来说和N类似，也是read比对时，中间跳过参考序列的部分区域）
					case: P
					// 否则抛出不支持的cigar操作
					default:
				}			
			}
			// 我们不会边计算边相加，因为它们有可能在相同的地方被设置为1两次（同时是snp也是insertion？）；返回：总的SNP和indel事件的总和
			nEvents += MathUtils.sum(isDel) + MathUtils.sum(isIns);
		}
		// 注意：出于效率的原因，我们不计算BAQ数组，除非我们真的有一些忽视的错误。对于ILMN数据大约有85%的reads没有错误。条件：snp和indel事件数等于0或用户不执行BAQ：其中一个为真：执行flatBAQArray(read):全部为假：执行calculateBAQArray(read,refDS)
		// final byte[] baqArray = (nErrors == 0 || !recalArgs.enableBAQ) ? flatBAQArray(read) : calculateBAQArray(read, refDS); 
			// flatBAQArray(read) {
				// 创建一个BAQ形式的数组，意味着没有比对的不确定性。输入：输入需要执行BAQ的数组，返回：BAQ-style非空的byte[]数组来存储NO_BAQ_UNCERTAINTY（常数64='@'）数值。TODO:如果上面的计算代码是内联的，是否可以通过完全使用内联来优化避免使用这个函数
				protected static byte[] flatBAQArray(final GATKRead read){
					// 分配确定的byte数值给每个元素给确定的byte数组。输入：需要填充的数组；数组所有元素存储该值(常数64=‘@’)。
					Arrays.fill(baq, NO_BAQ_UNCERTAINTY);
					public static void fill(byte[] a, byte val)
				}
			// 基于所有碱基的质量值和reference序列，为read计算一个真实的BAQ数组。输入：需要执行BAQ的read；返回：给read返回一个非空BAQ标签的数组
			// calculateBAQArray(read, refDS)
			private byte[] calculateBAQArray( final GATKRead read, final ReferenceDataSource refDS ){
				// baq: BAQ the reads ,动态生成比对不确定性向量				
				// 适当的修改read，使得碱基的质量分数通过执行BAQ计算而覆盖。假如有BAQ标签并且alwaysRecalculate是false，就使用BAQ标签，否则启用HMM标签并在动态中执行BAQ，假如有需要，就使用包含reference碱基的refHeader：返回：假如qmode是DNOT_MODIFY，为用户返回BQ qualities
				// baq.baqRead(read, refDS, BAQ.CalculationMode.RECALCULATE, BAQ.QualityMode.ADD_TAG);
				public byte[] baqRead(GATKRead read, ReferenceDataSource refDS, CalculationMode calculationType, QualityMode qmode ) {
					// 通常情况下我们需要重写quals，所以仅仅需要一个引用指向他们
					// if 假如CalculationMode.OFF，我们不需要做任何事
					// else if ( excludeReadFromBAQ(read) ){
						// 假如我们认为该read用来执行BAQ是不合格，就返回true；比如包含non-PF(非pass-filter详见技术说明6)的reads，重复的或者未匹配上的reads。可以通过baqRead函数来决定一个read是否应该做calculation。
						// excludeReadFromBAQ(read)
						// public boolean excludeReadFromBAQ(GATKRead read){
							// 要保证是mapped reads，不管pairing状态或者是primary比对状态
							return read.isUnmapped() || read.failsVendorQualityCheck() || read.isDuplicate();
						}
					}else  {						
						// if 判断计算类型是RECALCULATE或者没有BAQ标签 {
							// 在动态中计算BAQ，根据read和reference计算隐马尔可夫模型的结果
							BAQCalculationResult hmmResult = calcBAQFromHMM(read, refDS);
							public BAQCalculationResult calcBAQFromHMM(GATKRead read, ReferenceDataSource refDS){
								// 给定一个read，对于该read通过BAQ获取一个区间表示reference bases的跨度。输入：将会作为执行BAQ的输入read；用于BAQ算法的band width；返回：对于给定的read通过BAQ，返回一个区间表示reference碱基的跨度。
								final SimpleInterval referenceWindow = getReferenceWindowForRead(read, getBandWidth());
								public static SimpleInterval getReferenceWindowForRead( final GATKRead read, final int bandWidth ){
									// 起始位置是比对开始减去band width除以2减去第一个I元素的大小，假如是一个，终止位置相同						
									// 创建一个不可变的基于1数组(form[start, end])形式的区间；输入：contig的名称，不能为null，包含基于1的开始位置；包含基于1的终止位置；
									return new SimpleInterval(read.getContig(), start, stop);
									public SimpleInterval(final String contig, final int start, final int end)
								}
							}
							// if 假如hmmResult不等于null{
								switch ( qmode ) {
									// 将隐马尔模型的hmmresult.bq作为BAQ标签值写入read中，不需要管QUAL字段（重点）
									case ADD_TAG: addBAQTag(read, hmmResult.bq); break;
									public static void addBAQTag(GATKRead read, byte[] baq){
											// 编码BAQ标签为BQ标签
											encodeBQTag(read, baq)
											public static String encodeBQTag(GATKRead read, byte[] baq){
												// BAQ的偏移量，和read的测序长度一样，在第i个read碱基，BAQi=Qi-(BQi-64),Qi表示第i个碱基的质量。因此从BQi=Qi-BAQi+64
												// 可能的错误1（模型错误）：修正因素的错误可能BQ标签值小于0，属于GATK（隐马尔可夫模型计算的BAQ标签值太高了，远远大于碱基的质量值）的错误
												// 可能的额错误2（测序者过于自信）：原始的碱基质量值太高，几乎可以确定是bam文件由于使用了错误的编码
											}
											// 在read上设置一个字符串数值的属性；输入：设置属性的名称，参照{@link ReadUtils#assertAttributeNameIsLegal}必须是合法的；属性的字符串值（也许是null）；假如属性名是非法的，参照{@link ReadUtils#assertAttributeNameIsLegal}
											 read.setAttribute(BAQ_TAG, encodeBQTag(read, baq));
											 void setAttribute( final String attributeName, final String attributeValue );
										}
									}									
									// 直接用隐马尔可夫模型的数组结果对read的碱基质量数组进行覆盖
									case OVERWRITE_QUALS：System.arraycopy(hmmResult.bq, 0, read.getBaseQualities(), 0, hmmResult.bq.length); break;	
									// 返回：二进制质量分数来表示碱基质量（不是ASCII），假如没有碱基质量，就返回空的byte数组。注意：该方法返回值之前，对碱基质量做了保护性的拷贝工作，因此修改返回的数组，不会改变read上原来碱基的质量值
									read.getBaseQualities()
									byte[]  getBaseQualities();
									// 不做任何修改，BAQ质量数组就是隐马尔可夫模型的结果
									case DNOT_MODIFY：BAQQuals = hmmResult.bq; break;
								}
							} // else if假如有BAQ标签{
								// 从read中移除BAQ标签（相当于键值），因为我们已不相信BAQ标签值，而相信hmmResult。在read上清除该独立的属性；输入：需要清除的属性名，必须参照{@link ReadUtils#assertAttributeNameIsLegal}是合法的；假如属性名不合法，参照{@link ReadUtils#assertAttributeNameIsLegal}，就抛出非法参数异常
								void clearAttribute( final String attributeName );
							}
						}
						// else if 假如我们重写quals，就要使其有意义{
							// 将会重写原始的qualities
							// 针对read返回一个新的qual数组，包含BAQ调整，不支持动态BAQ计算；输入：操作的GATKRead，overwirteOriginalQuals假如为真，我们就用它们BAQ的version替换原始的质量值；假如useRawQualsIfNoBAQTag为真，然后又没有BAQ注释结果的时候我们就用原始的质量值，抛出非法状态异常为false，而且没有BAQ标签。
							public static byte[] calcBAQFromTag(GATKRead read, boolean overwriteOriginalQuals, boolean useRawQualsIfNoBAQTag){
								// base alignment quality（BAQ）的位移，和read序列的长度保持一致
								// 在第i个read的碱基，BAQi=Qi-(BQi-64),Qi是第i个碱基的质量值
								// message：BAQ标签错误：BAQ的值比碱基质量值要大（可能的错误1，模型错误导致BAQ过大）
							}
						}
					}
				}
				// 在read上从tag上获取BAQ的属性值，当没有BAQ的标签，返回空值
				return BAQ.getBAQTag(read);
			}			
		}
		// baqArray不为空;注释：一些reads不能执行BAQ计算{
			// 在给定read中的每一偏移位置，通过调用covariate.getValues()，计算所有请求的协变量值。它填充一个协变量值数组，result[i][j]表示协变量的值，i表示在read的第i个碱基位置，j表示在requestedCovariates列表中请求的第j个协变量；输入：需要计算协变量值的read；read的SAM header；请求的协变量列表；是否应该计算记录BQSR的indel 的协变量(默认为true)；返回：针对read上每一个碱基计算所有的协变量值矩阵。
			// final ReadCovariates covariates = RecalUtils.computeCovariates(read, readsHeader, this.covariates, true, keyCache);
			// public static ReadCovariates computeCovariates(final GATKRead read, final SAMFileHeader header, final StandardCovariateList covariates, final boolean recordIndelValues, final CovariateKeyCache keyCache){
				// 利用LRU缓存，保存我们看到的每个read长度的键(int[][][])，而组建键的数组缓存;缓存使得我们避免了为每一条read重新建立昂贵的数组。LRU保存缓存数组的总数，比LRU_CACHE_SIZE（默认是500）要小
				// final ReadCovariates readCovariates = new ReadCovariates(read.getLength(), covariates.size(), keyCache);
				// public ReadCovariates(final int readLength, final int numberOfCovariates, final CovariateKeyCache keysCache){
					// 对于给定read长度获取缓存的值，或者获得没有被缓存的空值。
					// final int[][][] cachedKeys = keysCache.get(readLength);
					// 假如cachedKeys为null，建立缓存，并返回keys
					// 否则直接返回Keys=cachedKeys
					// key的解释说明：该keys，按事件类型x索引read长度x协变量{
						 private final int[][][] keys;
					}
				}
				// 通过调用covariate.getValues(...)，针对给定read的每一个偏移位置计算所有的请求协变量值；它填充一个协变量值数组，result[i][j]表示协变量的值，i表示read的第i个碱基位置，j表示协变量列表的第j个协变量；输入：用来计算协变量值的read。read的SAM header；协变量列表；存储协变量值的对象；我们是否应该针对indel BQSR计算协变量值（默认为true）。
				// computeCovariates(read, header, covariates, readCovariates, recordIndelValues);
				// public static void computeCovariates(final GATKRead read, final SAMFileHeader header, final StandardCovariateList covariates, final ReadCovariates resultsStorage, final boolean recordIndelValues) {
					// 在该read上的所有位点计算于每一个协变量值（协变量值）;并在提供的存储对象中记录该值（协变量值）
					// covariates.recordAllValuesInStorage(read, header, resultsStorage, recordIndelValues);
					// public void recordAllValuesInStorage(final GATKRead read, final SAMFileHeader header, final ReadCovariates resultsStorage, final boolean recordIndelValues){
						// 对该read的所有位点计算协变量值;输入：计算协变量值的read；read的SAM header；对read上每个碱基记录协变量值的对象；针对indels指示协变量值是否需要记录 
						cov.recordValues(read, header, resultsStorage, recordIndelValues);
						public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues);（每个协变量有不同的实现方式）	
					}
				}
			}
			/// 跳过已知的变异位点和低质量和非规律性的碱基
			//final boolean[] skip = calculateSkipArray(read, knownSites);
			// private boolean[] calculateSkipArray( final GATKRead read, final Iterable<? extends Locatable> knownSites ) {
				// 返回：read的碱基数量（注意：不一定和比对到reference上的碱基数量相同）
				// final int readLength = read.getLength();
				// int getLength();
				// 计算已知的变异位点
				// final boolean[] knownSitesArray = calculateKnownSites(read, knownSites);
				// protected boolean[] calculateKnownSites( final GATKRead read, final Iterable<? extends Locatable> knownSites ) {
					/// 初始化已知的变异位点数组的值都为false
					/// 已知变异位点在read软跳过窗口的外面；忽略软跳过（即就是前面说的dbsnp里面不包含soft clipped base）。
					/// 根据reference的坐标获取read的坐标
					// int featureStartOnRead = ReadUtils.getReadCoordinateForReferenceCoordinate(softStart, cigar, knownSite.getStart(), ReadUtils.ClippingTail.LEFT_TAIL, true);
					// public static int getReadCoordinateForReferenceCoordinate(final int alignmentStart, final Cigar cigar, final int refCoord, final ClippingTail tail, final boolean allowGoalNotReached){
						// 针对Reference的坐标获得read的坐标的具体方法{后面细看}
						// final Pair<Integer, Boolean> result = getReadCoordinateForReferenceCoordinate(alignmentStart, cigar, refCoord, allowGoalNotReached);
						/// 情形一角：跳过右边的末端和deletion的开始，移到下read下一个坐标点。对于左边的末端不是一个问题，因为getReadCoordinateForReferenceCoordinate (方法）将会给其前面read的坐标
						/// 跳过左边末端和insertion的第一个碱基，转到read的下一个坐标，拥有和reference一样的坐标；前进到下一个cigar元素或者假如没有下一个坐标，就到了read的结束位置
					}	
				}
				// 普通for遍历{
					// 假如出现的碱基是regular base(AGCT or *),返回true
					// 或者是返回索引位置为i的碱基质量,要是小于6，返回true
					// read.getBaseQuality(i) < recalArgs.PRESERVE_QSCORES_LESS_THAN  {
						// 返回：第i个碱基的质量；默认实现是返回getBaseQualities()[i].子类可能会提供更高效的重写实现。但是必须和getBaseQualities()[i]保持相同的语义；异常：会抛出非法参数异常，假如i是负值或者i不小于碱基质量数量（byte数组的长度）（通过[@link#getBaseQualityCount()获得)
						// read.getBaseQuality(i)
						// default byte getBaseQuality(final int i){
							// 返回：二进制质量分数的碱基质量byte数组，（非ASCAII），假如没有碱基质量，就返回空byte数组。注释：在返回byte数组前，该方法做了防护性的碱基质量数组的拷贝，因此修改返回的数组，不会改变原read的碱基质量
							// return getBaseQualities()[i];
							// byte[]  getBaseQualities();
						}
					}
					// 或者是已知的变异位点，返回true
				}					
			}
			// 根据isSNP和baqArray计算snpError数组
			// final double[] snpErrors = calculateFractionalErrorArray(isSNP, baqArray);
			// public static double[] calculateFractionalErrorArray( final int[] errorArray, final byte[] baqArray ) {
				// 计算并存储InBlock错误
				calculateAndStoreErrorsInBlock(i-1, blockStartIndex, errorArray, fractionalErrors);
				// 返回fractionErrors
				return fractionalErrors;
			}
			// 根据isInsertion和baqArray计算InsertionErrors数组
			final double[] insertionErrors = calculateFractionalErrorArray(isInsertion, baqArray);
			// 根据isDeletion和baqArray计算deletionErrors数组
			final double[] deletionErrors = calculateFractionalErrorArray(isDeletion, baqArray);
			/// 收集所有的信息到我们的info object，并更新数据
			// 创建ReadRecalibrationInfo info :根据:read , covariates,skip,snpErrors,insertionErrors,deletionsErrors
			// 使用Info中的信息，更新recalibration 统计信息;输入：recalInfo=Info：数据结构保存的信息是关于一个单独的read的重矫正值）
			// updateRecalTablesForRead(info);
			// private void updateRecalTablesForRead( final ReadRecalibrationInfo recalInfo ) {
				// for( int offset = 0; offset < readLength; offset++ ) {/// read上每个偏移量(碱基位点)
					// if 假如不是需要跳过的位点{
						// for (int idx=0;idx<cacheEventTypes.length;idx++){/// 针对缓存的SNP和INDEL，注释：我们快速明确的循环缓存的数据
							/// 获取事件类型（SNP或INDEL）
							// 在错误模型的read位点获取所有协变量对应的键值（int[] keys=[0=readgroup,1=Quality,2=Context,3=Cycle]=keys[错误模型的序号][碱基位点]）；输入：readPosition；错误模型（SNP或indel）；final int[] keys = readCovariates.getKeySet(offset, eventType);
							// 获取事件类型对应的枚举类索引：final int eventIndex = eventType.ordinal();
							// 获取事件类型在位点处的质量分数：输入：想要获取质量对应的事件类型，想要获取质量值的read上的偏移位点，返回：该位点事件类型合法的质量分数
							// final byte qual = recalInfo.getQual(eventType, offset);
							// public byte getQual(final EventType eventType, final int offset){
								switch 事件类型{
									/// 假如是mismatch:返回该位点的质量值
									/// 此处没有做优化--假如我们没有ins或del质量，我们仅仅直接返回默认的byte值。
									/// 假如是insertion：insertionQual是空就返回45，否则返回该位点insertion的质量值
									/// 假如是deletion：deletionQual为空就返回45，否则就返回该位点deletion的质量值
									/// 否则抛出非法状态异常（未知的事件类型）
								}
							}
							// 获取事件类型在偏移位置的错误率;说明：错误率在0和1之间的数值，说明在该偏移量处出现错误有多大的可能性，假如值是1，意味着在该位点肯定会出现错误。假如是0.0，说明此处肯定不会出现错误。0.5一半可能出现错误，一半可能不会出现错误。输入：为获取质量值的事件类型，为获取质量值的read偏移量(碱基位点)；返回：该位点错误率的权重值
							// final double isError = recalInfo.getErrorFraction(eventType, offset);
							// public double getErrorFraction(final EventType eventType, final int offset) {
								// switch 事件类型{
									/// 假如是mismatch：返回该位点的snpError
									/// 假如是insertion：返回该位点的isertionError
									/// 假如是DeletionError：返回该位点的deletionError
									/// 否则返回非法状态异常，未知的事件类型
								}
							}
						}	
					}
					// 在特定的table中的特定位置(碱基位点)增加RecalDatum，或者假如没有该项目,就增加一个新的项目。注意：我们有意此处不使用可变参数，为了避免对于每一次调用分配一个数组的性能耗费，它显示在（性能）分析器上；输入：（将）保存项目的表格；该事件的质量；该事件的错误率值；表格中项目的位置(即就是对象的索引)
					// RecalUtils.incrementDatumOrPutIfNecessary3keys(qualityScoreTable, qual, isError, key0, key1, eventIndex);
					//  public static void incrementDatumOrPutIfNecessary3keys( final NestedIntegerArray<RecalDatum> table,final byte qual,final double isError,final int key0, final int key1, final int key2){
						// 专门用来获取3个参数；变量需要一个大的成本，因为每次都要分配变量数组。使用一个特定的方法解决性能问题
						// final RecalDatum existingDatum = table.get3Keys(key0, key1, key2);
						// public T get3Keys(final int key0, final int key1, final int key2){
							// nextDimension(key0, data):
							// private Object[] nextDimension(final int key, final Object[] array){
								/// 注释：在调用者中完成了检查
							}
							// return leaf(key2, nextDimension(key1, nextDimension(key0, data)));
							// private T leaf(final int key, final Object[] array){
								/// 注释：在调用者中完成了检查
							}
						}
						// 假如existingDatum为null{
							/// 没有该项目(根据组合协变量构建的RecalDatum)存在，加入一个新的
							// 利用一个observation和一个或零个错误创建一个RecalDatum对象；输入：对于该碱基通过测序仪器报告的质量分数；观察该碱基是否为一个错误；返回：利用观察和错误返回一个新的RecalDatum对象。
							// createDatumObject(qual, isError)
							// private static RecalDatum createDatumObject(final byte reportedQual, final double isError) {
								 // 利用给定的观察和mismatch数和报告的质量，构建一个新的RecalDatum。输入：观察数；mismatch数，报告的质量
								 // return new RecalDatum(1, isError, reportedQual);
								 // public RecalDatum(final long _numObservations, final double _numMismatches, final byte reportedQuality) {
								 	numObservations = _numObservations;
							        numMismatches = (_numMismatches*MULTIPLIER);
							        estimatedQReported = reportedQuality;
							        empiricalQuality = UNINITIALIZED;
								 }
							}
							// 通过给定的键值在特定的位点插入一个数值；输入：插入的值RecalDatum；键是指定树中值的位置；
							// table.put(createDatumObject(qual, isError), key0, key1, key2);
							// public void put(final T value, final int... keys){
								/// 警告：值会先于键值
								/// 如果我们达到或超过了预先分配的最后一个维度，我们需要检查下一个现存的分支是否存在，假如不存在，我们就需要建立。
							}
						}// 假如existingDatum不为null{
							/// 简单案例：假如已经存在，增加就行。
							/// 增加观察数（碱基数）和mismatch数。
							/// empiricalQuality=UNINITIALIZED=-1.0
						}
					}
					// for:存在特殊的协变量(也就是ReadGroup和Quality)，假如其他两个协变量存在，就遍历添加{
						// 在特定表格的指定位点增加RecalDatum，或者假如没有的话就增加一个新的RecalDtatum;注释：我们此处不打算使用变量，为避免每次调用分配数组的性能损耗，主要体现在性能分析器上。输入：保存我们项目（Context或Cycle）的表格；该事件的质量值，该事件的错误值，0=readGroup，1=Quality，i(2,3)=Context或Cycle；事件索引值
						// RecalUtils.incrementDatumOrPutIfNecessary4keys(recalTables.getTable(i), qual, isError, key0, key1, keyi, eventIndex)
						//  public static void incrementDatumOrPutIfNecessary4keys( final NestedIntegerArray<RecalDatum> table,final byte qual,final double isError,final int key0, final int key1, final int key2, final int key3)
					}
				}				
			}
		}
		// 已处理的read数目加1
 	 }
 }