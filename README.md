# TXCloud_COS_RNSDK
为腾讯云对象存储服务cos、万象忧图提供专业、稳定、简单的react-naitve SDK!!!

android

1:到腾讯云cos教程里将android sdk接入
2:将android->java->TxUpload.java,MyPackage.java这两文件copy到您MainActivity.java这个目录，然后将new MyPackage()这句话放到相应的位置，参考官网教程－android－原生模块－注册模块部分


ios

1:到腾讯云ios教程里将android sdk接入

2:在你的ios目录下将我的ios目录下的UploadTx.h,UploadTx.m两个文件拷入


js

将我的TxUpload.js拷贝进你项目任一位置，引入该文件即可使用

API

var {uploadTxImg,uploadTxFile}=require('你的该文件位置')

var optionsImg={
	sign:'你的万象优图的签名',
	path:'图片路径',
	bucket:'你的万象优图bucket',
}

var optionsFile={
	sign:'你的cos的签名',
	path:'文件路径',
	bucket:'你的cos的bucket',
}


//返回promise对象

uploadTxImg(optionsImg).then(results=>{

	var url=results.url
	//url即是该图片在你的万象优图上的url
})

uploadTxFile(optionsFile).then(results=>{

	var url=results.url
	//url即是该文件在你的cos上的url
})

如有疑问，欢迎加我qq：1518223884
苏州想说信息科技有限公司
创始人：孙峰







