//COBCOMP JOB (TSO),
//             'Compile Doge Cobol',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=0M,
//             USER=IBMUSER,PASSWORD=SYS1
//K2KCOBCL    PROC SOUT='*',ZOUT='*',
//            UNT=SYSDA,
//            KICKSYS='KICKS.KICKSSYS',
//            KIKSUSR='KICKS.KICKS',
//            VER=V1R5M0,
//            CBLPARM='SUPMAP,DMAP,CLIST'
//COPY   EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=&ZOUT
//SYSIN    DD DUMMY
//SYSUT2   DD DSN=&&PPIN,DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(TRK,(90,15),RLSE)
//SYSUT1   DD DSN=&KIKSUSR..&VER..COBCOPY(&VER),DISP=SHR
//*
//* - first pp, make input for first cob
//PP1    EXEC PGM=KIKPPCOB,
//            PARM='-v -t -dmapin1'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//SYSPRINT DD DISP=(,PASS),UNIT=&UNT,SPACE=(800,(500,100),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSTERM  DD SYSOUT=&SOUT,DCB=(BLKSIZE=120,RECFM=F)
//SYSUDUMP DD SYSOUT=&SOUT
//SYSLIB   DD DISP=SHR,DSN=&KIKSUSR..&VER..COBCOPY
//         DD DISP=SHR,DSN=&KICKSYS..&VER..COBCOPY
//SYSIN    DD DSN=&&PPIN,DISP=(OLD,PASS)
//*
//* - first cob, generate dmap
//COB1   EXEC PGM=IKFCBL00,
//            REGION=4096K,
//            COND=(5,LT),
// PARM='DMAP,SOURCE,NOCLIST,NODECK,NOLOAD,SIZE=2048K,BUF=1024K,LIB'
//SYSPRINT DD DISP=(,PASS),UNIT=&UNT,SPACE=(1210,(500,100),RLSE),
//            DCB=(RECFM=FB,LRECL=121,BLKSIZE=1210)
//SYSPUNCH DD DUMMY
//SYSLIB   DD DISP=SHR,DSN=&KIKSUSR..&VER..COBCOPY
//         DD DISP=SHR,DSN=&KICKSYS..&VER..COBCOPY
//SYSLIN   DD UNIT=&UNT,SPACE=(80,(250,100)),DISP=(MOD,DELETE)
//SYSUT1   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT2   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT3   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT4   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSIN    DD DISP=(OLD,DELETE),DSN=*.PP1.SYSPRINT
//*
//* - 2nd pp, use dmap for LENGTH's, make input to 2nd cob
//PP2    EXEC PGM=KIKPPCOB,COND=((5,LT,PP1),(12,LT,COB1)),
//            PARM='-t -dmapin2'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//SYSPRINT DD DISP=(,PASS),UNIT=&UNT,SPACE=(800,(500,100),RLSE),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSTERM  DD SYSOUT=&SOUT,DCB=(BLKSIZE=120,RECFM=F)
//SYSUDUMP DD SYSOUT=&SOUT
//SYSLIB   DD DISP=SHR,DSN=&KIKSUSR..&VER..COBCOPY
//         DD DISP=SHR,DSN=&KICKSYS..&VER..COBCOPY
//DMAPIN   DD DISP=(OLD,DELETE),DSN=*.COB1.SYSPRINT
//SYSIN    DD DSN=&&PPIN,DISP=(OLD,DELETE)
//*
//* - 2nd cob, make object deck for linker
//COB2   EXEC PGM=IKFCBL00,
//            REGION=4096K,
//            COND=(5,LT),
//            PARM='NODECK,LOAD,SIZE=2048K,BUF=1024K,&CBLPARM,LIB'
//SYSPRINT DD SYSOUT=&SOUT
//SYSPUNCH DD DUMMY
//SYSLIB   DD DISP=SHR,DSN=&KIKSUSR..&VER..COBCOPY
//         DD DISP=SHR,DSN=&KICKSYS..&VER..COBCOPY
//SYSLIN   DD UNIT=&UNT,SPACE=(80,(250,100)),DISP=(MOD,PASS)
//SYSUT1   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT2   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT3   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSUT4   DD UNIT=&UNT,SPACE=(460,(350,100))
//SYSIN    DD DISP=(OLD,DELETE),DSN=*.PP2.SYSPRINT
//*
//LKED   EXEC PGM=IEWL,
//            COND=(5,LT),
//            PARM='XREF,LIST,LET,MAP'
//SYSPRINT DD SYSOUT=&SOUT
//SYSLIB   DD DISP=SHR,DSN=SYS1.COBLIB
//SYSLMOD  DD DISP=SHR,DSN=&KIKSUSR..&VER..KIKRPL
//SYSLIN   DD DISP=(OLD,DELETE),DSN=*.COB2.SYSLIN
//         DD DDNAME=SYSIN
//SYSUT1   DD UNIT=(SYSDA,SEP=(SYSLMOD,SYSLIN)),
//         SPACE=(1024,(200,20))
//SKIKLOAD DD DISP=SHR,DSN=&KICKSYS..&VER..SKIKLOAD
//KIKRPL   DD DISP=SHR,DSN=&KICKSYS..&VER..KIKRPL
//SYSIN    DD DUMMY
// PEND
//* MAIN DOGE SCREEN                                         
//DOGEMAIN EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEMAIN)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGECOIN                                              
 NAME DOGECOIN(R)                                            
//* MAIN DOGE SCREEN                                         
//DOGEMAIN EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEMAIN)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGECOIN                                              
 NAME DOGECOIN(R)                                            
//* DOGE TRANSACTION HISTORY                                 
//DOGETRAN EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=HERC01.DOGECICS(DOGETRAN)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGETRAN                                              
 NAME DOGETRAN(R)                                            
//* DOGE SEND MONEYS                                         
//DOGESEND EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=HERC01.DOGECICS(DOGESEND)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGESEND                                              
 NAME DOGESEND(R)                                            
//* DOGE TRANSACTION DETAILS                                 
//DOGEDEET EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=HERC01.DOGECICS(DOGEDEET)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGEDEET                                              
 NAME DOGEDEET(R)                                            
//* DOGE QUIT DOGE                                           
//DOGEQUIT EXEC K2KCOBCL                                     
//COPY.SYSUT1 DD DISP=SHR,DSN=HERC01.DOGECICS(DOGEQUIT)            
//LKED.SYSIN DD *                                            
 INCLUDE SKIKLOAD(KIKCOBGL)                                  
 ENTRY DOGEQUIT                                              
 NAME DOGEQUIT(R)  
 //*
