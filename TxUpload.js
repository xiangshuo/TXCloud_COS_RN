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


//上传万象优图 
function uploadTxImg (myoptions={}) {
  //必须有签名、appId,图片路径，bucket
   
   return new Promise((resolve,reject)=>{
        if(!myoptions.sign) return reject('请设置签名')
        if(!myoptions.path) return reject('请设置图片路径')
        if(!myoptions.bucket) return reject('请设置bucket')
        if(!myoptions.appId) return reject('请设置appId')
       
       if(Platform.OS==='ios'){
       		UploadTx.uploadImg(myoptions,(err,req)=>{
	           if(req.status){
	              resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
	       })
       }else{
       	  UploadTx.uploadImg(myoptions.appId,myoptions.bucket,myoptions.path,myoptions.sign,(req)=>{
       	  	 if(req.status){
       	  	 	 //console.log(req);
	             resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
       	  })
       }
       
   })
}

//上传cos
function uploadTxFile(myoptions={}) {
  //必须有签名、appId,图片路径，bucket
   return new Promise((resolve,reject)=>{
        if(!myoptions.sign) return reject('请设置签名')
        if(!myoptions.path) return reject('请设置图片路径')
        if(!myoptions.bucket) return reject('请设置bucket')
        if(!myoptions.appId) return reject('请设置appId')

        if(Platform.OS==='ios'){
   		    UploadTx.uploadFile(myoptions,(err,req)=>{
	           if(req.status){
	             resolve({url:req.url})
	           }else{
	              reject("上传出错，错误码是"+req.errCode)
	           }
	        })
       }else{
       	  
       		UploadTx.uploadFile(myoptions.appId,myoptions.bucket,myoptions.path,myoptions.sign,(req)=>{
	       	  	 if(req.status){
		             resolve({url:req.url})
		           }else{
		              reject("上传出错，错误码是"+req.errorCode)
                  //alert("上传出错，错误码是"+req.errorMsg+req.errorCode)
		           }
	       	  })
       }
     
   })
}

module.exports={uploadTxImg,uploadTxFile}