//COBCOMP JOB (TSO),
//             'Compile Doge Cobol',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//PROCLIB  DD DSN=KICKS.KICKSSYS.V1R5M0.PROCLIB,DISP=SHR    
//* MAIN DOGE SCREEN                                         
//DOGEMAIN EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEMAIN)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGECOIN                                              
 NAME DOGECOIN(R)                                            
//* DOGE TRANSACTION HISTORY                                 
//DOGETRAN EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGETRAN)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGETRAN                                              
 NAME DOGETRAN(R)                                            
//* DOGE SEND MONEYS                                         
//DOGESEND EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGESEND)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGESEND                                              
 NAME DOGESEND(R)                                            
//* DOGE TRANSACTION DETAILS                                 
//DOGEDEET EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEDEET)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGEDEET                                              
 NAME DOGEDEET(R)                                            
//* DOGE QUIT DOGE                                           
//DOGEQUIT EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEQUIT)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGEQUIT                                              
 NAME DOGEQUIT(R)
//*
