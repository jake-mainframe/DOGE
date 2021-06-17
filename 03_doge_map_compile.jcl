//MAPCOMP JOB (TSO),
//             'Compile Doge Map',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             REGION=0M,
//             USER=IBMUSER,PASSWORD=SYS1
//KIKMAPS PROC SOUT='*',
//        DSCTLIB=COBCOPY,
//        DSCTLIC=GCCCOPY,
//        MAPLIB=KIKRPL,
//        KICKSYS='KICKS.KICKSSYS',
//        KIKSUSR='KICKS.KICKS',
//        VER=V1R5M0,
//        ASM=IFOX00,                ASMA90 FOR Z/OS
//        MAPNAME=DUMMY
//*
//COPY    EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=&SOUT
//SYSIN    DD DUMMY
//SYSUT2   DD DSN=&&MAP,DISP=(,PASS),UNIT=SYSDA,SPACE=(TRK,(15,15))
//SYSUT1   DD DSN=&KIKSUSR..&VER..MAPSRC(&MAPNAME),DISP=SHR
//*
//BMAP     EXEC PGM=KIKMG,
// PARM='-v -t -g=map'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//SYSUDUMP DD SYSOUT=&SOUT
//SYSPRINT DD DSN=&&MAPOUT,DISP=(,PASS),
//         DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),
//         UNIT=SYSDA,SPACE=(TRK,(90,90),RLSE)
//SYSUT1   DD UNIT=SYSDA,SPACE=(TRK,(15,15)),
//         DCB=(RECFM=U,BLKSIZE=800)
//SYSTERM  DD SYSOUT=&SOUT,DCB=(BLKSIZE=120,RECFM=F)
//SYSIN    DD DSN=&&MAP,DISP=(OLD,PASS)
//*
//ASM      EXEC PGM=&ASM,COND=(5,LT),
//            PARM='DECK,NOLIST'
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR,DCB=BLKSIZE=32720
//SYSUT1   DD UNIT=SYSALLDA,SPACE=(CYL,(20,10))
//SYSUT2   DD UNIT=SYSALLDA,SPACE=(CYL,(10,10))
//SYSUT3   DD UNIT=SYSALLDA,SPACE=(CYL,(10,10))
//SYSPRINT DD SYSOUT=&SOUT
//SYSLIN   DD DUMMY
//SYSGO    DD DUMMY
//SYSPUNCH DD DSN=&&OBJSET,DISP=(,PASS),UNIT=SYSDA,SPACE=(TRK,(15,15))
//SYSIN    DD DSN=&&MAPOUT,DISP=(OLD,DELETE)
//*
//LINKMAP  EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//            COND=(8,LT)
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SYSIN    DD DUMMY
//SYSLMOD  DD DSN=&KIKSUSR..&VER..&MAPLIB(&MAPNAME),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=&SOUT
//*
//COBMAP   EXEC PGM=KIKMG,COND=(5,LT),
// PARM='-t -g=dsect -l=cobol'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//*YSUDUMP DD SYSOUT=&SOUT
//SYSPRINT DD DSN=&KIKSUSR..&VER..&DSCTLIB(&MAPNAME),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(TRK,(15,15)),
//         DCB=(RECFM=U,BLKSIZE=800)
//SYSTERM DD SYSOUT=&SOUT,DCB=(BLKSIZE=120,RECFM=F)
//SYSIN DD DSN=&&MAP,DISP=(OLD,PASS)
//*
//GCCMAP   EXEC PGM=KIKMG,COND=(5,LT),
// PARM='-t -g=dsect -l=c'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//*YSUDUMP DD SYSOUT=&SOUT
//SYSPRINT DD DSN=&KIKSUSR..&VER..&DSCTLIC(&MAPNAME),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(TRK,(15,15)),
//         DCB=(RECFM=U,BLKSIZE=800)
//SYSTERM DD SYSOUT=&SOUT,DCB=(BLKSIZE=120,RECFM=F)
//SYSIN DD DSN=&&MAP,DISP=(OLD,DELETE)
// PEND
//* DOGE GM Screen
//DOGEGM   EXEC PROC=KIKMAPS,MAPNAME=DOGECN
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEGMSC)
//* DOGE Main Screen
//DOGEMAIN EXEC PROC=KIKMAPS,MAPNAME=DOGEMN
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEMMAP)
//* DOGE Transaction History
//DOGETRAN EXEC PROC=KIKMAPS,MAPNAME=DOGETR
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGETMAP)
//* DOGE Send Doge
//DOGESEND EXEC PROC=KIKMAPS,MAPNAME=DOGESN
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGESMAP)
//* DOGE Detailed Transaction
//DOGEDEET EXEC PROC=KIKMAPS,MAPNAME=DOGEDT           
//COPY.SYSUT1 DD DISP=SHR,DSN=KICKS.DOGECICS(DOGEDMAP)