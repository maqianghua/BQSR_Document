应用碱基质量分数重矫正
该工具是BQSR(Base Quality Score Recalibration)两阶段处理流程的第二步
特别是：它基于通过BaseRecalibrator工具产生的重矫正表格，重矫正输入read的碱基质量，并且输出重矫正bam或cram文件
BQSR处理总结：
	该流程的目标是修正系统偏向性，它影响碱基质量分数的分配被测序者。
	第一步：包含计算经验错误，并找出错误如何随所有碱基的basecall特征而变化的模式。相关的观察数被输出到重矫正表中
	第二步：包含应用数字修正到每个单独的basecall，基于第一步被认定的模式（记录在重矫正表格中）并会把重矫正数据输出到一个新的bam或cram文件中
// 注意：该工具替代了PrintReads，在早期的GATK（2.x和3.x）版本，对于应用碱基质量分数重矫正的实践
// 你可以仅仅使用输入的BAM或cram文件产生的协变量表，来应用于ApplyBQSR
// 假如需要，原始的质量应该被保存在输出文件的OQ标签下。可以具体查看--emit-original-quals参数查看详情
// 应用碱基质量分数重矫正
// 使用重矫正工具，应用一个线性的碱基质量重矫正模型训练
// 输出文件路径{
	@Argument(fullName = StandardArgumentDefinitions.OUTPUT_LONG_NAME, shortName = StandardArgumentDefinitions.OUTPUT_SHORT_NAME, doc="Write output to this file")
    public String OUTPUT;
}
// 该请求的参数用来做BQSR，通过BaseRecalibrator工具产生的重矫正表是一个文件
// 注意你应该仅仅使用重矫正文件运行重矫正，在相同的输入数据上{
	@Argument(fullName=StandardArgumentDefinitions.BQSR_TABLE_LONG_NAME, shortName=StandardArgumentDefinitions.BQSR_TABLE_SHORT_NAME, doc="Input recalibration table for BQSR")
    public File BQSR_RECAL_FILE;
 }
// 命令行参数可以对重矫正进行微调{
	@ArgumentCollection
    public ApplyBQSRArgumentCollection bqsrArgs = new ApplyBQSRArgumentCollection();
}

// 返回BQSRpost-transformer{
	public ReadTransformer makePostReadFilterTransformer(){
		// getHeaderForReads():对于reads数据资源返回SAM header，假如是多个输入文件，将所有的header合并，假如只有一个输入文件，直接返回header。没有reads就返回null
		// 使用GATK报告文件的构造函数{
			return new BQSRReadTransformer(getHeaderForReads(), BQSR_RECAL_FILE, bqsrArgs);{
				// 使用RecalibrationrReport的构造函数{
					this(header, new RecalibrationReport(bqsrRecalFile), args);
				}				 
			}
		}
	}
}

// 开始遍历：{
	public void onTraversalStart(){
		// 针对该工具使用reference和read header创建一个通用的SAMFileWriter；
		// outputPath：假如该路径有一个.cram的扩展名，reference必须要有的，不能为null
		// preSorted:假如为真，然后记录必须已经被存储了，并且能匹配header的顺序
		// throws:用户异常，假如OutputFile是以".cram"结尾，reference必须提供		
		// 返回SAMFileWriter{
			参数：{
				// 将给定的URI转换成一个{@link Path}object。如果文件系统以通常的方式找不到，然后尝试使用线程context类加载器，加载提供的文件系统，使用一个URL类加载器有必要加载提供的文件系统，（举例：在spark-submit）
				// 假如不是一个URL，也会尝试解析参数为一个文件名{
					IOUtils.getPath(OUTPUT){	
						// 不是一个合法的URL，调用者可能给了我们一个文件名
						// 特殊情况的GCS，提供的文件系统没有安装正确，但是可以得到
						// 不是一个合法的URL，调用者可能提供给我们一个文件名或"chr1:1-2"
					}
				}
			}
			outputWriter = createSAMWriter(IOUtils.getPath(OUTPUT), true);{
				// 一个GATKRead writer输出一个SAM/BAM文件
				// 在处理过程中，将每条read转成SAMRecord，假如该read没有在SAM个失踪，有可能会是有损操作（lossy operation）{
					return new SAMFileGATKReadWriter{
						// 给用户利用GATK工具创建一个共同的SAMFileWriter
					}
				}
			}
		}
	}
}

// 执行处理一个独立的read（利用可选的contextual information）.应该被工具使用者实现
// 通常，工具使用者应该简单从apply()方法stream他们的输出，并尽可能的保留一点内在状态
//Todo: 确定GATK引擎是否以及在何种程度上应该提供减少操作
//Todo: 补充这个操作。至少，我们应该让apply()返回一个值
// Todo: 在walkers不鼓励有状态，但是如何处理这个值是TBD(待定) {
	参数{
		// 包装FeatureManager，从特定的区间展现特征数据给客户工具。没有不正确的暴露engine内部处理
		// 客户传递一个或多个FeatureInputs，被声明为工具参数，并从那些特征输入里面获得一个所有Features的列表，该列表通过该FeatureContext和区间跨度有交集
		// 选择性的返回Features，并被附加的约束从指定的位置开始
		// 根据请求的每个特性的类型参数返回强类型特性;因此，对FeatureInput的查询将返回VariantContext对象(没有被工具使用者要求转换)。
		// Feature源被惰性地查询，所以如果客户端选择不检查，就没有开销（开放）
		// 一个FeatureContext也许没有备份资源，或区间。在这些情况下，查询他们通常返回空的列表。你可以通过{@link #hasBackingDataSource()}决定Features受有备份资源，并通过{@link #getInterval}决定是否有区间。
		// 注意：这个类不打算扩展到测试工具之外。{
			 FeatureContext featureContext
		}
	}
	public void apply( GATKRead read, ReferenceContext referenceContext, FeatureContext featureContext ){
		// 将该read天添加到outputWriter中{
			 outputWriter.addRead(read);{
			 	// 将该read转变成一个SAMRecord
				// 警告：返回值不保证与该read是独立的。（举例：假如该read已经存在于SAMRecord格式中，不会产生副本）{
					read.convertToSAMRecord(samWriter.getFileHeader())
				}
			 }
		}		
	}
}