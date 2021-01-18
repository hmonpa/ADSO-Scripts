#!/bin/bash

# ----------------------------------------------------------------- 
# mikes handy rotating-filesystem-snapshot utility 
# http://www.mikerubel.org/computers/rsync_snapshots 
# Modified by Mauricio Alvarez: http://people.ac.upc.edu/alvarez 
# ----------------------------------------------------------------- 
 
# ---------- system commands used by this script------------------ 
ID=/usr/bin/id 
ECHO=/bin/echo 
MOUNT=/bin/mount 
RM=/bin/rm 
MV=/bin/mv 
CP=/bin/cp 
TOUCH=/usr/bin/touch 
RSYNC=/usr/bin/rsync 
 
# ------------- file locations -----------------------------------
MOUNT_DEVICE=/dev/sda4
SNAPSHOT_MOUNTPOINT=/backup
SNAPSHOT_DIR=backup-rsync/snapshot
EXCLUDES=*.gz					# Archivos .gz excluidos
SOURCE_DIR=/var/log/ 			# Directorio origen (a copiar)
PERMISSIONS=700					# Permisos en el directorio destino
USER=root
ADDRESS=192.168.0.34			

# ------------- the script itself--------------------------------- 
 
# make sure we're running as root 
if (( `$ID -u` != 0 )); then { $ECHO "Sorry, must be root.  Exiting..."; exit; } fi 
 
# attempt to remount the RW mount point as RW; else abort 
$MOUNT -o remount,rw $MOUNT_DEVICE $SNAPSHOT_MOUNTPOINT ; 
if (( $? )); then 
{ 
    $ECHO "snapshot: could not remount $SNAPSHOT_MOUNTPOINT readwrite"; 
    exit; 
} 
fi; 
 
# rotating snapshots of /$SNAPSHOT_DIR 
 
# step 1: delete the oldest snapshot, if it exists: 
if [ -d $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.3 ] ; then 
    $RM -rf $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.3 
fi 
 
# step 2: shift the middle snapshotss back by one, if they exist
if [ -d $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.2 ] ; then 
    $MV $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.2 $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.3 
fi 
 
if [ -d $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.1 ] ; then 
    $MV $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.1 $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.2 
fi 
 
if [ -d $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.0 ] ; then 
    $MV $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.0 $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.1 
fi; 
 
# step 3: rsync from the system into the latest snapshot 
$RSYNC -avz --chmod=$PERMISSIONS --delete --exclude=$EXCLUDES --link-dest=$SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.1 $SOURCE_DIR -e ssh $USER@$ADDRESS:$SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.0  
				
# complete here what is missing for the rsync command: 
# - basic options: 
# - excludes: 
# - --link-dest= 
# - source and destination directories 
 
# step 5: update the mtime of daily.0 to reflect the snapshot time 
$TOUCH $SNAPSHOT_MOUNTPOINT/$SNAPSHOT_DIR/daily.0 ; 
 
# now remount the RW snapshot mountpoint as readonly 
$MOUNT -o remount,ro $MOUNT_DEVICE $SNAPSHOT_MOUNTPOINT ; 
if (( $? )); then 
{ 
    $ECHO "snapshot: could not remount $SNAPSHOT_MOUNTPOINT readonly"; 
    exit; 
} fi; 

