main.m





运行test1.m提取路径(会自动保存路径信息）
运行test1try.m(仿真）
运行testpen.m(运行机械臂抓笔）
运行test.m（运行机械臂）

test1.m 不进行角度判断
test2.m 进行角度判断，（放弃了关键点提取）
#注释（或者取消注释）两个文件第八行，计算的是线段不合并（或合并）的路径笔画；
##合并：代表粗线条在路径中表现为一条，

contour_get 参考自老师的contour_following.m，用于提取和计算图片的空间路径；其中contour_get3.m (不进行角度判断)，contour_get4.m (进行角度判断)

linedelete.m 原先用于contour_get函数中，删除已提取的线段，现在已经不需要了

frenet.m 照搬老师的函数，用于计算梯度等

main.m进行整个程序运行
画画：选图—图像处理—Matlab仿真—机械臂控制
写字：选图—文字识别—Matlab仿真—机械臂控制
studyData.m进行对文字训练
tryy.m为文字识别代码
create_database.m为建立标准字库
get_picture.m切割图片


