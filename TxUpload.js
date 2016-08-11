import React, { Component } from 'react';
import {
  Platform,
  NativeModules, 
} from 'react-native';

var UploadTx
if (Platform.OS==='ios') {
  UploadTx=NativeModules.TxUploadIOS
} else {
  UploadTx=NativeModules.TxUploadAndroid
}



function uploadTxImg (myoptions={}) {
  //必须有sign
   var opt=Object.assign(options,myoptions)
   return new Promise((resolve,reject)=>{
        if(!opt.sign) return reject('请设置签名')
        if(!opt.path) return reject('请设置图片路径')
        if(!opt.bucket) return reject('请设置bucket')
       if(Platform.OS==='ios'){
       		UploadTx.uploadImg(opt,(err,req)=>{
	           if(req.status){
	              resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
	       })
       }else{
       		//console.log(UploadTx,opt);
       	  UploadTx.uploadImg(appId,bucketImg,opt.path,opt.sign,(req)=>{
       	  	 if(req.status){
       	  	 	 console.log(req);
	             resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
       	  })
       }
       
   })
}
function uploadTxFile(myoptions={}) {
  //必须有sign
   var opt=Object.assign(optionsFile,myoptions)
   //console.log(opt);
   return new Promise((resolve,reject)=>{
        if(!opt.sign) return reject('请设置签名')
        if(!opt.path) return reject('请设置文件路径')
        if(!opt.bucket) return reject('请设置bucket')
       if(Platform.OS==='ios'){
   		    UploadTx.uploadFile(opt,(err,req)=>{
	           if(req.status){
	             resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
	        })
       }else{
       	  //console.log(UploadTx,opt);
       		UploadTx.uploadFile(appId,bucketFile,opt.path,opt.sign,(req)=>{
	       	  	 if(req.status){
		             resolve({url:req.url})
		           }else{
		              reject("上传出错，错误码是"+req.errorCode)
                  alert("上传出错，错误码是"+req.errorMsg+req.errorCode)
		           }
	       	  })
       }
     
   })
}

module.exports={uploadTxImg,uploadTxFile}