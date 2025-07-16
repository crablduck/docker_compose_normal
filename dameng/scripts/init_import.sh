#!/bin/bash
set -e

# 配置
DUMP_DIR=/opt/init
DUMP_FILE=htsp_bussiness.dmp
DUMP_PATH=${DUMP_DIR}/${DUMP_FILE}
DBHOST=${DB_HOST:-localhost}
DBPORT=${DB_PORT:-5236}
DMUSER=SYSDBA
DMPASS=Dameng123
LOGFILE=${DUMP_DIR}/import.log
SCHEMAS=HTSP_BUSSINESS

# 校验
if [ ! -f "$DUMP_PATH" ]; then
  echo "No dump file at $DUMP_PATH, skipping." | tee "$LOGFILE"
  exit 0
fi

echo "=== Importing $DUMP_FILE into ${SCHEMAS} on ${DBHOST}:${DBPORT} ===" | tee "$LOGFILE"


# 按官方示例构造批处理命令
#/opt/dmdbms/bin/dimp USERID="SYSDBA/Dameng123@dameng-db-container-test:5236"  FILE=htsp_bussiness.dmp DIRECTORY=/opt/init SCHEMAS=HTSP_BUSSINESS LOG=import1.log
/opt/dmdbms/bin/dimp \
  USERID="SYSDBA/Dameng123@dameng-db-container-test:5236" \
  DIRECTORY=/opt/init \
  FILE=${DUMP_FILE} \
  LOG=${LOGFILE} \
  SCHEMAS=${SCHEMAS} \
  IGNORE=Y \
  COMMIT_ROWS=5000 \

RC=$?
popd > /dev/null

if [ $RC -eq 0 ]; then
  echo "✅ Import succeeded." | tee -a "$LOGFILE"
else
  echo "❌ Import failed (code $RC). See $LOGFILE." | tee -a "$LOGFILE"
fi
exit $RC