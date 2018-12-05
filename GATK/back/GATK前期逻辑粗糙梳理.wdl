
// 针对read计算真实的BAQ数组，基于read的质量和reference序列
private byte[] calculateBAQArray( final GATKRead read, final ReferenceDataSource refDS ){
	// 适当的修改read，使得碱基质量分数被BAQ计算所包裹，假如有BAQ标签并且alwaysRecalculate是false，就使用该标签，
	// 否则启用HMM标签，同时BAQ用于fly中
	// 当有需要的时候，使用包含reference 碱基的refReader。
	// 假如qmode是DNOT_MODIFY 针对用户返回BQ qualities
	BAQ.java
	public final class BAQ implements Serializable
	baq.baqRead(read, refDS, BAQ.CalculationMode.RECALCULATE, BAQ.QualityMode.ADD_TAG){
		// 通常情况下我们会覆盖quals，因此要获取一个引用指向他们

		// 计算类型是RECALCULATE 或者 没有BAQTAG{
			// 从HMM计算BAQ 
			BAQCalculationResult hmmResult = calcBAQFromHMM(read, refDS);{
				// 假如hmmResult不等于null {
						switch ( qmode ) {
						ADD_TAG：添加BAQ标签hmmResult.bq到read上
						OVERWRITE_QUALS：数组拷贝
						DNOT_MODIFY：BAQQuals=hmmResult.bq
						default：不识别的qmode
					}
				}
				假如read有BAQTAG{
					// 去掉BAQ的标签，因为我们不信任它
				}				
			}
		}
		// else if (qmode==QualityMode.OVERWRITE_QUALS){
			// 当我们覆盖了质量才有意义。
			// 将会覆盖原始的质量值
		}
	}
	// 返回一个非null BAQ tag的read 数组
}

// 有些read 就没有BAQ{
		计算协变量值
		// 在给定的read对于每一个offset计算所有需要的协变量值
		// 通过调用covariate.getValues(...)
		// 将会定位到协变量数组的值，对于result[i][j]是对于在read上的第i个位置，第j个协变量在requestedCovariates列表。
		public static ReadCovariates computeCovariates(final GATKRead read, final SAMFileHeader header, final StandardCovariateList covariates, final boolean recordIndelValues, final CovariateKeyCache keyCache){
			// 利用LRU缓存技术针对我们看到的每一个read长度作为缓存数组的key值，缓存针对每个read允许我们避免重建数组。
			// LRU使得缓存的数组总数比LRU_CACHE_SIZE要小。
			public ReadCovariates(final int readLength, final int numberOfCovariates, final CovariateKeyCache keysCache) {}
			public static void computeCovariates(final GATKRead read, final SAMFileHeader header, final StandardCovariateList covariates, final ReadCovariates resultsStorage, final boolean recordIndelValues) {
				// 在该read的所有位置，针对每一个协变量计算值，并且在提供的储备目标（协变量）记录值。
				public void recordAllValuesInStorage(final GATKRead read, final SAMFileHeader header, final ReadCovariates resultsStorage, final boolean recordIndelValues){
					// 在read上的针对所有位置计算协变量值
					public void recordValues(final GATKRead read, final SAMFileHeader header, final ReadCovariates values, final boolean recordIndelValues)
				}
			}
		}

//  跳过已知的变异位点，和低质量和非常规的碱基
// 计算部分数组的错误。（包含isSNP，isInsertion，isDeletion数组）
// 聚集所有的信息到我们的info object，同时更新数据。
// 更新重矫正统计信息，使用recalInfo中的信息。
